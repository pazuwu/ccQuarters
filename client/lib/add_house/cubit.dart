import 'dart:typed_data';

import 'package:ccquarters/add_house/states.dart';
import 'package:ccquarters/model/photo.dart';
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
        super(ChooseTypeFormState(NewHouseDetails()));

  HouseService houseService;
  late NewHouse house;
  List<Photo> deletedPhotos = [];

  VTService vtService;
  bool _createVirtualTour = false;

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
      deletedPhotos,
      _createVirtualTour,
    ));
  }

  Future<void> sendData() async {
    emit(SendingDataState());

    if (_createVirtualTour) {
      var result = await vtService.postTour(name: "");
      if (result.data != null) {
        house.houseDetails.virtualTourId = result.data!;
      }
    }

    var result = await houseService.createHouse(house);
    if (result.data != null) {
      var houseId = result.data!;
      for (var photo in house.newPhotos) {
        var res = await houseService.addPhoto(houseId, photo);
        if (!res.data) {
          emit(ErrorState("Błąd w wysyłaniu zdjęć!"));
          return;
        }
      }
    } else {
      emit(ErrorState("Błąd!"));
      return;
    }

    emit(SendingFinishedState(houseId: result.data!));
  }

  Future<void> updateHouse() async {
    emit(SendingDataState());

    var response = await houseService.updateHouse(house.id, house);
    if (!response.data) {
      emit(
          ErrorState("Nie udało się zapisać zmian. Spróbuj ponownie pózniej!"));
      return;
    }

    if (deletedPhotos.isNotEmpty) {
      var responsePhotos = await houseService.deletePhotos(deletedPhotos);
      if (!responsePhotos.data) {
        emit(ErrorState(
            "Nie udało się usunąć zdjęć. Spróbuj ponownie pózniej!"));
        return;
      }
    }

    if (house.newPhotos.isNotEmpty) {
      for (var photo in house.newPhotos) {
        var res = await houseService.addPhoto(house.id, photo);
        if (!res.data) {
          emit(ErrorState(
              "Nie udało się dodać nowych zdjęć. Spróbuj ponownie później!"));
          return;
        }
      }
    }

    emit(SendingFinishedState(houseId: house.id));
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
    this.deletedPhotos = deletedPhotos;
  }

  void saveCreateVirtualTour(bool createVirtualTour) {
    _createVirtualTour = createVirtualTour;
  }

  void clear() {
    house = NewHouse("", NewLocation(), NewHouseDetails(), []);
    emit(ChooseTypeFormState(NewHouseDetails()));
  }
}
