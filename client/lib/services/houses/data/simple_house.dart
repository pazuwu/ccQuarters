import 'package:ccquarters/model/building_type.dart';
import 'package:ccquarters/model/house.dart';
import 'package:ccquarters/model/offer_type.dart';
import 'package:ccquarters/model/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'simple_house.g.dart';

@JsonSerializable()
class SimpleHouse {
  String id;
  String title;
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
  OfferType offerType;
  BuildingType buildingType;
  bool isLiked;
  String photoUrl;

  SimpleHouse(
      this.id,
      this.title,
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
      this.offerType,
      this.buildingType,
      this.isLiked,
      this.photoUrl);

  Map<String, dynamic> toJson() => _$SimpleHouseToJson(this);
  factory SimpleHouse.fromJson(Map<String, dynamic> json) =>
      _$SimpleHouseFromJson(json);

  House toHouse() {
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
      User(),
      [photoUrl],
      offerType: offerType,
      isLiked: isLiked,
    );
  }
}

// class Photo {
//   String houseId;
//   String photoId;
// }

