import 'package:ccquarters/model/alert.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_alerts_response.g.dart';

@JsonSerializable()
class GetAlertsResponse {
  List<Alert> alerts;

  GetAlertsResponse({required this.alerts});

  Map<String, dynamic> toJson() => _$GetAlertsResponseToJson(this);
  factory GetAlertsResponse.fromJson(Map<String, dynamic> json) =>
      _$GetAlertsResponseFromJson(json);
}
