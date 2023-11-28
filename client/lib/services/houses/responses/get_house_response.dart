import 'package:json_annotation/json_annotation.dart';

import '../data/detailed_house.dart';

part 'get_house_response.g.dart';

@JsonSerializable()
class GetHouseResponse {
  DetailedHouse house;
  List<String>? photoUrls;

  GetHouseResponse(this.house, this.photoUrls);

  Map<String, dynamic> toJson() => _$GetHouseResponseToJson(this);
  factory GetHouseResponse.fromJson(Map<String, dynamic> json) =>
      _$GetHouseResponseFromJson(json);
}

