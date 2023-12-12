import 'package:ccquarters/model/building_type.dart';
import 'package:ccquarters/model/filter.dart';
import 'package:ccquarters/model/offer_type.dart';
import 'package:json_annotation/json_annotation.dart';

part 'alert.g.dart';

@JsonSerializable()
class Alert {
  String id;
  String userId;
  double? maxPrice;
  double? maxPricePerM2;
  double? minArea;
  double? maxArea;
  int? minRoomCount;
  int? maxRoomCount;
  int? floor;
  OfferType? offerType;
  BuildingType? buildingType;
  String? city;
  String? zipCode;
  String? district;
  String? streetName;
  String? streetNumber;
  String? flatNumber;

  Alert(
      {required this.id,
      required this.userId,
      this.maxPrice,
      this.maxPricePerM2,
      this.minArea,
      this.maxArea,
      this.minRoomCount,
      this.maxRoomCount,
      this.floor,
      this.offerType,
      this.buildingType,
      this.city,
      this.zipCode,
      this.district,
      this.streetName,
      this.streetNumber,
      this.flatNumber});

  Alert.empty()
      : id = "",
        userId = "";

  Alert.fromHouseFilter(HouseFilter filters)
      : id = "",
        userId = "",
        maxPrice = filters.maxPrice,
        maxPricePerM2 = filters.maxPricePerMeter,
        minArea = filters.minArea,
        maxArea = filters.maxArea,
        minRoomCount = filters.minRoomCount,
        maxRoomCount = filters.maxRoomCount,
        floor = filters.floor?.first,
        offerType = filters.offerType,
        buildingType = filters.buildingType,
        city = filters.cities.isNotEmpty ? filters.cities.first : null,
        district =
            filters.districts.isNotEmpty ? filters.districts.first : null;

  Map<String, dynamic> toJson() => _$AlertToJson(this);
  factory Alert.fromJson(Map<String, dynamic> json) => _$AlertFromJson(json);
}
