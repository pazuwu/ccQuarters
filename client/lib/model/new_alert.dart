import 'package:ccquarters/model/alert_base.dart';
import 'package:ccquarters/model/building_type.dart';
import 'package:ccquarters/model/filter.dart';
import 'package:ccquarters/model/offer_type.dart';
import 'package:json_annotation/json_annotation.dart';

part 'new_alert.g.dart';

@JsonSerializable(includeIfNull: false)
class NewAlert extends AlertBase {
  NewAlert();

  NewAlert.fromHouseFilter(HouseFilter filters)
      : super.fromHouseFilter(filters);

  Map<String, dynamic> toJson() => _$NewAlertToJson(this);
  factory NewAlert.fromJson(Map<String, dynamic> json) =>
      _$NewAlertFromJson(json);
}
