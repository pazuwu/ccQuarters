import 'package:ccquarters/model/houses/photo.dart';
import 'package:flutter/foundation.dart';

import 'package:ccquarters/model/houses/building_type.dart';
import 'package:ccquarters/model/houses/new_house.dart';
import 'package:ccquarters/model/houses/offer_type.dart';

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

class PortraitDetailsFormState extends StepperPageState {
  PortraitDetailsFormState(this.houseDetails, this.buildingType);

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
  );

  List<Photo> oldPhotos;
  List<Uint8List> newPhotos;
  List<Photo> deletedPhotos;
}

class VirtualTourFormState extends StepperPageState {
  VirtualTourFormState(this.usedVirtualTour);

  String? usedVirtualTour;
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
