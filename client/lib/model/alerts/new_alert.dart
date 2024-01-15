import 'package:ccquarters/model/alerts/alert_base.dart';
import 'package:ccquarters/model/houses/building_type.dart';
import 'package:ccquarters/model/houses/filter.dart';
import 'package:ccquarters/model/houses/offer_type.dart';
import 'package:json_annotation/json_annotation.dart';

part 'new_alert.g.dart';

@JsonSerializable(includeIfNull: false)
class NewAlert extends AlertBase {
  NewAlert();

  NewAlert.fromHouseFilter(HouseFilter filters)
      : super.fromHouseFilter(filters);

  bool isEmpty() {
    return !(offerType != null ||
        buildingType != null ||
        (voivodeship?.isNotEmpty ?? false) ||
        (cities?.isNotEmpty ?? false) ||
        (districts?.isNotEmpty ?? false) ||
        minPrice != null ||
        maxPrice != null ||
        minPricePerM2 != null ||
        maxPricePerM2 != null ||
        minArea != null ||
        maxArea != null ||
        minRoomCount != null ||
        maxRoomCount != null ||
        minFloor != null ||
        floors != null);
  }

  Map<String, dynamic> toJson() => _$NewAlertToJson(this);
  factory NewAlert.fromJson(Map<String, dynamic> json) =>
      _$NewAlertFromJson(json);
}
