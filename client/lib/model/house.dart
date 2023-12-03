import 'package:ccquarters/model/building_type.dart';
import 'package:ccquarters/model/offer_type.dart';
import 'package:ccquarters/model/photo.dart';
import 'package:ccquarters/model/user.dart';

class House {
  House(
    this.location,
    this.details,
    this.user,
    this.photos, {
    required this.id,
    required this.offerType,
    required this.isLiked,
    this.virtualTourId = "vu7TKNy0zkPj6jHy6lIq",
  });

  String id;
  String? virtualTourId;
  Location location;
  HouseDetails details;
  OfferType offerType;
  User user;
  bool isLiked;
  List<Photo> photos;
}

class Location {
  Location({
    required this.city,
    required this.voivodeship,
    required this.zipCode,
    this.district,
    this.streetName,
    this.streetNumber,
    this.flatNumber,
    this.geoX,
    this.geoY,
  });

  String city;
  String voivodeship;
  String? district;
  String? streetName;
  String zipCode;
  String? streetNumber;
  String? flatNumber;
  double? geoX;
  double? geoY;
}

class HouseDetails {
  HouseDetails({
    this.description,
    required this.title,
    required this.price,
    required this.area,
    this.roomCount,
    this.floor,
    required this.buildingType,
  });

  String? description;
  String title;
  double price;
  int? roomCount;
  double area;
  int? floor;
  BuildingType buildingType;
}
