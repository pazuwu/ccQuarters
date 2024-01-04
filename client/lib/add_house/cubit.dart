import 'dart:typed_data';

import 'package:ccquarters/add_house/states.dart';
import 'package:ccquarters/model/house/photo.dart';
import 'package:ccquarters/virtual_tour_model/tour_info.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ccquarters/model/house/building_type.dart';
import 'package:ccquarters/model/house/new_house.dart';
import 'package:ccquarters/model/house/offer_type.dart';
import 'package:ccquarters/services/houses/service.dart';
import 'package:ccquarters/services/virtual_tours/service.dart';

class AddHouseFormCubit extends Cubit<HouseFormState> {
  AddHouseFormCubit(
      {required this.houseService, required this.vtService, NewHouse? house})
      : house = house ?? NewHouse("", NewLocation(), NewHouseDetails(), []),
        super(ChooseTypeFormState(house?.houseDetails ?? NewHouseDetails()));

  HouseService houseService;
  VTService vtService;
  late NewHouse house;
  List<Photo> photosToDelete = [];
  String? houseId;
  (int, int)? photosSendingProgress;

  void goToLocationForm() {
    emit(LocationFormState(house.location, house.buildingType));
  }

  void goToDetailsForm() {
    emit(MobileDetailsFormState(house.houseDetails, house.buildingType));
  }

  void goToChooseTypeForm() {
    emit(ChooseTypeFormState(
      house.houseDetails,
      offerType: house.offerType,
      buildingType: house.buildingType,
    ));
  }

  void goToMap() {
    emit(MapState());
  }

  void goToPhotosForm() {
    emit(PhotosFormState(
      house.oldPhotos,
      house.newPhotos,
      photosToDelete,
    ));
  }

  void goToVirtualTourForm() {
    emit(VirtualTourFormState(house.houseDetails.virtualTourId));
  }

  Future<void> sendData() async {
    emit(SendingDataState());

    if (houseId == null) {
      var result = await houseService.createHouse(house);
      if (result.data != null) {
        houseId = result.data!;
      } else {
        emit(ErrorState("Wystąpił błąd w tworzeniu ogłoszenia"));
        return;
      }
    }

    if (!await _uploadPhotos(houseId!, house.newPhotos)) {
      return;
    }

    emit(SendingFinishedState(houseId: houseId!));
  }

  Future<void> updateHouse() async {
    emit(SendingDataState());

    var response = await houseService.updateHouse(house.id, house);
    if (!response.data) {
      emit(
          ErrorState("Nie udało się zapisać zmian. Spróbuj ponownie pózniej!"));
      return;
    }

    if (photosToDelete.isNotEmpty) {
      var responsePhotos = await houseService.deletePhotos(photosToDelete);
      if (!responsePhotos.data) {
        emit(ErrorState(
            "Nie udało się usunąć zdjęć. Spróbuj ponownie później!"));
        return;
      } else {
        photosToDelete = [];
      }
    }

    if (!await _uploadPhotos(house.id, house.newPhotos)) {
      return;
    }

    emit(SendingFinishedState(houseId: house.id));
  }

  Future<bool> _uploadPhotos(String houseId, List<Uint8List> photos) async {
    var futures = <Future<bool>>[];
    var failedImages = <Uint8List>[];

    for (var file in photos) {
      futures.add(
        _uploadPhoto(houseId, file).then(
          (result) {
            if (result == false) {
              failedImages.add(file);
            }

            return result;
          },
        ),
      );
    }

    await Future.wait(futures);

    if (failedImages.isNotEmpty) {
      if (photosSendingProgress == null) {
        photosSendingProgress = (
          house.newPhotos.length - failedImages.length,
          house.newPhotos.length
        );
      } else {
        photosSendingProgress = (
          photosSendingProgress!.$2 - failedImages.length,
          photosSendingProgress!.$2
        );
      }

      house.newPhotos = failedImages;
      emit(ErrorState(
          "Wystąpił błąd i wysłano ${photosSendingProgress!.$1} z ${photosSendingProgress!.$2} zdjęć"));
      return false;
    }

    photosSendingProgress = null;
    return true;
  }

  Future<bool> _uploadPhoto(String houseId, Uint8List photoBytes) async {
    var serviceResponse = await houseService.addPhoto(houseId, photoBytes);

    return serviceResponse.data;
  }

  Future<List<TourInfo>> getMyTours() async {
    var serviceResult = await vtService.getMyTours();
    return serviceResult.data ?? [];
  }

  void saveDetails(NewHouseDetails details) {
    house.houseDetails = details;
  }

  void saveLocation(NewLocation location) {
    house.location = location;
  }

  void saveCoordinates({double? longitute, double? latitude}) {
    house.location.geoX = longitute ?? house.location.geoX;
    house.location.geoY = latitude ?? house.location.geoX;
  }

  void saveOfferType(OfferType offerType) {
    house.offerType = offerType;
  }

  void saveBuildingType(BuildingType buildingType) {
    house.buildingType = buildingType;
    emit(ChooseTypeFormState(house.houseDetails,
        offerType: house.offerType, buildingType: house.buildingType));
  }

  void savePhotos(List<Uint8List> photos, List<Photo> oldPhotos,
      List<Photo> deletedPhotos) {
    house.newPhotos = photos;
    house.oldPhotos = oldPhotos;
    photosToDelete = deletedPhotos;
  }

  void saveChosenVirtualTour(String? virtualTourId) {
    house.houseDetails.virtualTourId = virtualTourId;
  }

  void clear() {
    houseId = null;
    photosSendingProgress = null;
    house = NewHouse("", NewLocation(), NewHouseDetails(), []);
    emit(ChooseTypeFormState(NewHouseDetails()));
  }
}
