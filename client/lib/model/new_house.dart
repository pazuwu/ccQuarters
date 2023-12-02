import 'dart:typed_data';

import 'package:ccquarters/model/building_type.dart';
import 'package:ccquarters/model/voivodeship.dart';
import 'package:ccquarters/model/offer_type.dart';

class NewHouse {
  NewHouse(
    this.location,
    this.houseDetails, {
    this.offerType = OfferType.rent,
    this.buildingType = BuildingType.house,
  });
  NewLocation location;
  NewHouseDetails houseDetails;
  OfferType offerType;
  BuildingType buildingType;
  List<Uint8List> photos = <Uint8List>[];
}

class NewLocation {
  NewLocation({
    this.voivodeship,
    this.city = '',
    this.district,
    this.streetName,
    this.zipCode = '',
    this.streetNumber = '',
    this.flatNumber,
    this.geoX,
    this.geoY,
  });

  Voivodeship? voivodeship;
  String city;
  String? district;
  String? streetName;
  String zipCode;
  String streetNumber;
  String? flatNumber;
  double? geoX;
  double? geoY;
}

class NewHouseDetails {
  NewHouseDetails({
    this.description = "",
    this.title = "",
    this.price = 0,
    this.roomCount = 0,
    this.area = 0,
    this.floor,
  });

  String description;
  String title;
  double price;
  int roomCount;
  double area;
  int? floor;
}
