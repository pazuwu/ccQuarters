import 'package:ccquarters/model/alerts/alert.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_alerts_response.g.dart';

@JsonSerializable()
class GetAlertsResponse {
  List<Alert> data;
  int pageNumber;
  int pageSize;

  GetAlertsResponse({
    required this.data,
    required this.pageNumber,
    required this.pageSize,
  });

  Map<String, dynamic> toJson() => _$GetAlertsResponseToJson(this);
  factory GetAlertsResponse.fromJson(Map<String, dynamic> json) =>
      _$GetAlertsResponseFromJson(json);
}
