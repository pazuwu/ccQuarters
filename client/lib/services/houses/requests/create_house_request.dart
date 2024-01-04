import 'package:ccquarters/model/house/building_type.dart';
import 'package:ccquarters/model/house/new_house.dart';
import 'package:ccquarters/model/house/offer_type.dart';
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
  String voivodeship;
  String city;
  String? zipCode;
  String? district;
  String? streetName;
  String? streetNumber;
  String? flatNumber;
  double? geoX;
  double? geoY;
  @OfferTypeConverter()
  OfferType offerType;
  @BuildingTypeConverter()
  BuildingType buildingType;
  String? virtualTourId;

  CreateHouseRequest(
      this.title,
      this.price,
      this.roomCount,
      this.area,
      this.floor,
      this.description,
      this.additionalInfo,
      this.voivodeship,
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
        additionalInfo = newHouse.houseDetails.additionalInfo,
        virtualTourId = newHouse.houseDetails.virtualTourId,
        voivodeship = newHouse.location.voivodeship.toString(),
        city = newHouse.location.city,
        zipCode = newHouse.location.zipCode,
        district = newHouse.location.district,
        streetName = newHouse.location.streetName,
        streetNumber = newHouse.location.streetNumber,
        flatNumber = newHouse.location.flatNumber,
        geoX = newHouse.location.geoX,
        geoY = newHouse.location.geoY;

  Map<String, dynamic> toJson() => _$CreateHouseRequestToJson(this);
  factory CreateHouseRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateHouseRequestFromJson(json);
}
