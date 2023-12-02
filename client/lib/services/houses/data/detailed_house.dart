import 'package:ccquarters/model/building_type.dart';
import 'package:ccquarters/model/house.dart';
import 'package:ccquarters/model/offer_type.dart';
import 'package:ccquarters/model/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'detailed_house.g.dart';

@JsonSerializable()
class DetailedHouse {
  String title;
  String? description;
  Map<String, dynamic> details;
  double price;
  int roomCount;
  double area;
  int? floor;
  String city;
  String zipCode;
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
  bool isLiked;
  String? userName;
  String? userSurname;
  String? userCompany;
  String? userEmail;
  String? userPhoneNumber;
  String? userPhotoUrl;

  DetailedHouse(
    this.title,
    this.description,
    this.details,
    this.price,
    this.roomCount,
    this.area,
    this.floor,
    this.city,
    this.zipCode,
    this.district,
    this.streetName,
    this.streetNumber,
    this.flatNumber,
    this.geoX,
    this.geoY,
    this.offerType,
    this.buildingType,
    this.isLiked,
    this.userName,
    this.userSurname,
    this.userCompany,
    this.userEmail,
    this.userPhoneNumber,
    this.userPhotoUrl,
  );

  Map<String, dynamic> toJson() => _$DetailedHouseToJson(this);
  factory DetailedHouse.fromJson(Map<String, dynamic> json) =>
      _$DetailedHouseFromJson(json);

  House toHouse(List<String>? photos) {
    return House(
      Location(
        city: city,
        district: district,
        streetName: streetName,
        zipCode: zipCode,
        streetNumber: streetNumber,
        flatNumber: flatNumber,
      ),
      HouseDetails(
        title: title,
        price: price,
        roomCount: roomCount,
        area: area,
        floor: floor,
        buildingType: buildingType,
      ),
      User.fromGetHouses(
        userName ?? "",
        userSurname ?? "",
        userCompany,
        userEmail ?? "",
        userPhoneNumber,
        userPhotoUrl,
      ),
      photos ?? [],
      offerType: offerType,
      isLiked: isLiked,
    );
  }
}
