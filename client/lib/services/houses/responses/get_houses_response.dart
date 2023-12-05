import 'package:ccquarters/services/houses/data/simple_house.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_houses_response.g.dart';

@JsonSerializable()
class GetHousesResponse {
  final List<SimpleHouse> data;
  final int pageNumber;
  final int pageSize;

  GetHousesResponse(this.pageNumber, this.pageSize, this.data);

  Map<String, dynamic> toJson() => _$GetHousesResponseToJson(this);
  factory GetHousesResponse.fromJson(Map<String, dynamic> json) =>
      _$GetHousesResponseFromJson(json);
}
