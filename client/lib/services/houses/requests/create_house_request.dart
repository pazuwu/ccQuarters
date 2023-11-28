import 'package:ccquarters/model/building_type.dart';
import 'package:ccquarters/model/house.dart';
import 'package:ccquarters/model/new_house.dart';
import 'package:ccquarters/model/offer_type.dart';
import 'package:json_annotation/json_annotation.dart';

part 'create_house_request.g.dart';

@JsonSerializable()
class CreateHouseRequest {
  String? title;
  double? price;
  int? roomCount;
  double? area;
  int? floor;
  String? description;
  Map<String, String>? additionalInfo;
  String? city;
  String? zipCode;
  String? district;
  String? streetName;
  String? streetNumber;
  String? flatNumber;
  double? geoX;
  double? geoY;
  OfferType offerType;
  BuildingType buildingType;

  CreateHouseRequest(
      this.title,
      this.price,
      this.roomCount,
      this.area,
      this.floor,
      this.description,
      this.additionalInfo,
      this.city,
      this.zipCode,
      this.district,
      this.streetName,
      this.streetNumber,
      this.flatNumber,
      this.geoX,
      this.geoY,
      this.offerType,
      this.buildingType);

  CreateHouseRequest.fromNewHouse(NewHouse newHouse)
      : buildingType = newHouse.buildingType,
        offerType = newHouse.offerType,
        title = newHouse.houseDetails.title,
        price = newHouse.houseDetails.price,
        roomCount = newHouse.houseDetails.roomCount,
        area = newHouse.houseDetails.area,
        floor = newHouse.houseDetails.floor,
        description = newHouse.houseDetails.description,
        city = newHouse.location.city,
        zipCode = newHouse.location.zipCode,
        district = newHouse.location.district,
        streetName = newHouse.location.streetName,
        streetNumber = newHouse.location.streetNumber,
        flatNumber = newHouse.location.flatNumber,
        geoX = newHouse.location.geoX,
        geoY = newHouse.location.geoY;

  CreateHouseRequest.fromHouse(House house)
      : buildingType = house.details.buildingType,
        offerType = house.offerType,
        title = house.details.title,
        price = house.details.price,
        roomCount = house.details.roomCount,
        area = house.details.area,
        floor = house.details.floor,
        description = house.details.description,
        city = house.location.city,
        zipCode = house.location.zipCode,
        district = house.location.district,
        streetName = house.location.streetName,
        streetNumber = house.location.streetNumber,
        flatNumber = house.location.flatNumber,
        geoX = house.location.geoX,
        geoY = house.location.geoY;

  Map<String, dynamic> toJson() => _$CreateHouseRequestToJson(this);
  factory CreateHouseRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateHouseRequestFromJson(json);
}
