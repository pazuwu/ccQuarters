import 'package:ccquarters/model/alerts/alert_base.dart';
import 'package:ccquarters/model/houses/building_type.dart';
import 'package:ccquarters/model/houses/filter.dart';
import 'package:ccquarters/model/houses/offer_type.dart';
import 'package:json_annotation/json_annotation.dart';

part 'alert.g.dart';

@JsonSerializable(includeIfNull: false)
class Alert extends AlertBase {
  String id;

  Alert({
    required this.id,
    double? minPrice,
    double? maxPrice,
    double? maxPricePerM2,
    double? minPricePerM2,
    double? minArea,
    double? maxArea,
    int? minRoomCount,
    int? maxRoomCount,
    List<int>? floors,
    int? minFloor,
    OfferType? offerType,
    BuildingType? buildingType,
    String? voivodeship,
    List<String>? cities,
    List<String>? districts,
  }) : super(
          minPrice: minPrice,
          maxPrice: maxPrice,
          maxPricePerM2: maxPricePerM2,
          minPricePerM2: minPricePerM2,
          minArea: minArea,
          maxArea: maxArea,
          minRoomCount: minRoomCount,
          maxRoomCount: maxRoomCount,
          floors: floors,
          minFloor: minFloor,
          offerType: offerType,
          buildingType: buildingType,
          voivodeship: voivodeship,
          cities: cities,
          districts: districts,
        );

  Alert.fromHouseFilter(HouseFilter filters, this.id)
      : super.fromHouseFilter(filters);

  Map<String, dynamic> toJson() => _$AlertToJson(this);
  factory Alert.fromJson(Map<String, dynamic> json) => _$AlertFromJson(json);
}
