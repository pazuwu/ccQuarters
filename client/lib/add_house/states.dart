import 'package:ccquarters/model/photo.dart';
import 'package:flutter/foundation.dart';

import 'package:ccquarters/model/building_type.dart';
import 'package:ccquarters/model/new_house.dart';
import 'package:ccquarters/model/offer_type.dart';

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
