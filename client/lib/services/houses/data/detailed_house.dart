import 'package:ccquarters/model/houses/building_type.dart';
import 'package:ccquarters/model/houses/detailed_house.dart';
import 'package:ccquarters/model/houses/house_details.dart';
import 'package:ccquarters/model/houses/location.dart';
import 'package:ccquarters/model/houses/offer_type.dart';
import 'package:ccquarters/model/houses/photo.dart';
import 'package:ccquarters/model/users/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'detailed_house.g.dart';

@JsonSerializable()
class HouseWithDetails {
  String title;
  String? description;
  Map<String, dynamic>? additionalInfo;
  double price;
  int roomCount;
  double area;
  int? floor;
  String voivodeship;
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
  String userId;
  String? userName;
  String? userSurname;
  String? userCompany;
  String userEmail;
  String? userPhoneNumber;
  String? userPhotoUrl;
  String? virtualTourId;

  HouseWithDetails(
    this.title,
    this.description,
    this.additionalInfo,
    this.price,
    this.roomCount,
    this.area,
    this.floor,
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
    this.buildingType,
    this.isLiked,
    this.userId,
    this.userName,
    this.userSurname,
    this.userCompany,
    this.userEmail,
    this.userPhoneNumber,
    this.userPhotoUrl,
    this.virtualTourId,
  );

  Map<String, dynamic> toJson() => _$HouseWithDetailsToJson(this);
  factory HouseWithDetails.fromJson(Map<String, dynamic> json) =>
      _$HouseWithDetailsFromJson(json);

  DetailedHouse toDetailedHouse(List<Photo>? photos, String id) {
    return DetailedHouse(
      Location(
        voivodeship: voivodeship,
        city: city,
        district: district,
        streetName: streetName,
        zipCode: zipCode,
        streetNumber: streetNumber ?? "",
        flatNumber: flatNumber,
        geoX: geoX,
        geoY: geoY,
      ),
      HouseDetails(
        title: title,
        price: price,
        roomCount: roomCount,
        area: area,
        floor: floor,
        buildingType: buildingType,
        virtualTourId: virtualTourId,
        additionalInfo: additionalInfo?.cast<String, String>(),
      ),
      User.fromGetHouse(
        userId,
        userName,
        userSurname,
        userCompany,
        userEmail,
        userPhoneNumber,
        userPhotoUrl,
      ),
      photos ?? [],
      id: id,
      offerType: offerType,
      isLiked: isLiked,
    );
  }
}
