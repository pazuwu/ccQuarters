import 'dart:typed_data';

import 'package:ccquarters/model/photo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ccquarters/model/building_type.dart';
import 'package:ccquarters/model/new_house.dart';
import 'package:ccquarters/model/offer_type.dart';
import 'package:ccquarters/services/houses/service.dart';
import 'package:ccquarters/virtual_tour/service/service.dart';

class HouseFormState {}

class StepperPageState extends HouseFormState {}

class ChooseTypeFormState extends StepperPageState {
  ChooseTypeFormState(
    this.houseDetails, {
    this.offerType = OfferType.rent,
    this.buildingType = BuildingType.house,
  });

  final OfferType offerType;
  final BuildingType buildingType;
  final NewHouseDetails houseDetails;
}

class MobileDetailsFormState extends StepperPageState {
  MobileDetailsFormState(this.houseDetails, this.buildingType);

  final NewHouseDetails houseDetails;
  final BuildingType buildingType;
}

class LocationFormState extends StepperPageState {
  LocationFormState(this.location, this.buildingType);

  final NewLocation location;
  final BuildingType buildingType;
}

class MapState extends StepperPageState {}

class PhotosFormState extends StepperPageState {
  PhotosFormState(
    this.oldPhotos,
    this.newPhotos,
    this.deletedPhotos,
    this.createVirtualTour,
  );

  List<Photo> oldPhotos;
  List<Uint8List> newPhotos;
  List<Photo> deletedPhotos;
  bool createVirtualTour;
}

class SendingFinishedState extends HouseFormState {
  String houseId;
  SendingFinishedState({
    required this.houseId,
  });
}

class ErrorState extends HouseFormState {
  ErrorState(this.message);
  String message;
}

class SendingDataState extends HouseFormState {}

class AddHouseFormCubit extends Cubit<HouseFormState> {
  AddHouseFormCubit(
      {required this.houseService, required this.vtService, NewHouse? house})
      : house = house ?? NewHouse(NewLocation(), NewHouseDetails(), []),
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
      var result = await vtService.postTour();
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
    house = NewHouse(NewLocation(), NewHouseDetails(), []);
    emit(ChooseTypeFormState(NewHouseDetails()));
  }
}
