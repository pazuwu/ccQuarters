import 'package:ccquarters/model/filter.dart';
import 'package:json_annotation/json_annotation.dart';

import '../data/houses_filter.dart';

part 'get_houses_request_body.g.dart';

@JsonSerializable()
class GetHousesRequestBody {
  final SortingMethod? sortMethod;
  final HousesFilter? filter;

  GetHousesRequestBody(this.sortMethod, this.filter);

  Map<String, dynamic> toJson() => _$GetHousesRequestBodyToJson(this);
  factory GetHousesRequestBody.fromJson(Map<String, dynamic> json) =>
      _$GetHousesRequestBodyFromJson(json);
}
