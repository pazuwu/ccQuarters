import 'dart:typed_data';

import 'package:ccquarters/add_house/states.dart';
import 'package:ccquarters/model/photo.dart';
import 'package:ccquarters/virtual_tour/model/tour_info.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ccquarters/model/building_type.dart';
import 'package:ccquarters/model/new_house.dart';
import 'package:ccquarters/model/offer_type.dart';
import 'package:ccquarters/services/houses/service.dart';
import 'package:ccquarters/virtual_tour/service/service.dart';

class AddHouseFormCubit extends Cubit<HouseFormState> {
  AddHouseFormCubit(
      {required this.houseService, required this.vtService, NewHouse? house})
      : house = house ?? NewHouse("", NewLocation(), NewHouseDetails(), []),
        super(ChooseTypeFormState(house?.houseDetails ?? NewHouseDetails()));

  HouseService houseService;
  VTService vtService;
  late NewHouse house;
  List<Photo> photosToDelete = [];
  int? nextPhotoIndexToResend;
  String? houseId;

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

    for (int i = nextPhotoIndexToResend ?? 0; i < house.newPhotos.length; i++) {
      var res = await houseService.addPhoto(houseId!, house.newPhotos[i]);
      if (!res.data) {
        nextPhotoIndexToResend = i;
        emit(ErrorState(
            "Wystąpił błąd i wysłano $i z ${house.newPhotos.length} zdjęć"));
        return;
      }
    }

    nextPhotoIndexToResend = null;
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

    if (house.newPhotos.isNotEmpty) {
      for (int i = nextPhotoIndexToResend ?? 0;
          i < house.newPhotos.length;
          i++) {
        var res = await houseService.addPhoto(house.id, house.newPhotos[i]);
        if (!res.data) {
          nextPhotoIndexToResend = i;
          emit(ErrorState(
              "Wystąpił błąd i wysłano $i z ${house.newPhotos.length} nowych zdjęć"));
          return;
        }
      }
    }

    nextPhotoIndexToResend = null;
    emit(SendingFinishedState(houseId: house.id));
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
    nextPhotoIndexToResend = null;
    house = NewHouse("", NewLocation(), NewHouseDetails(), []);
    emit(ChooseTypeFormState(NewHouseDetails()));
  }
}
