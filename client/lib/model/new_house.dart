import 'dart:typed_data';

import 'package:ccquarters/model/building_type.dart';
import 'package:ccquarters/model/detailed_house.dart';
import 'package:ccquarters/model/house_details.dart';
import 'package:ccquarters/model/location.dart';
import 'package:ccquarters/model/photo.dart';
import 'package:ccquarters/model/voivodeship.dart';
import 'package:ccquarters/model/offer_type.dart';

class NewHouse {
  NewHouse(
    this.id,
    this.location,
    this.houseDetails,
    this.oldPhotos, {
    this.offerType = OfferType.rent,
    this.buildingType = BuildingType.house,
  });

  String id;
  NewLocation location;
  NewHouseDetails houseDetails;
  OfferType offerType;
  BuildingType buildingType;
  List<Photo> oldPhotos = [];
  List<Photo> deletedPhotos = [];
  List<Uint8List> newPhotos = <Uint8List>[];

  NewHouse.fromDetailedHouse(DetailedHouse house)
      : this(
          house.id,
          NewLocation.fromLocation(house.location),
          NewHouseDetails.fromHouseDetails(house.details),
          house.photos.toList(),
          offerType: house.offerType,
          buildingType: house.details.buildingType,
        );
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

  NewLocation.fromLocation(Location location)
      : this(
          voivodeship: VoivodeshipEx.getFromName(location.voivodeship),
          city: location.city,
          district: location.district,
          streetName: location.streetName,
          zipCode: location.zipCode,
          streetNumber: location.streetNumber ?? "",
          flatNumber: location.flatNumber,
          geoX: location.geoX,
          geoY: location.geoY,
        );
}

class NewHouseDetails {
  NewHouseDetails({
    this.description = "",
    this.title = "",
    this.price = 0,
    this.roomCount = 0,
    this.area = 0,
    this.floor,
    this.virtualTourId,
    this.additionalInfo,
  });

  String description;
  String title;
  double price;
  int roomCount;
  double area;
  int? floor;
  String? virtualTourId;
  Map<String, String>? additionalInfo;

  NewHouseDetails.fromHouseDetails(HouseDetails details)
      : this(
          description: details.description ?? "",
          title: details.title,
          price: details.price,
          roomCount: details.roomCount ?? 0,
          area: details.area,
          floor: details.floor,
          virtualTourId: details.virtualTourId,
          additionalInfo: details.additionalInfo,
        );
}
