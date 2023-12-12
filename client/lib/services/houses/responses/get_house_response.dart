import 'package:ccquarters/model/photo.dart';
import 'package:json_annotation/json_annotation.dart';

import '../data/detailed_house.dart';

part 'get_house_response.g.dart';

@JsonSerializable()
class GetHouseResponse {
  HouseWithDetails house;
  List<Photo>? photos;

  GetHouseResponse(this.house, this.photos);

  Map<String, dynamic> toJson() => _$GetHouseResponseToJson(this);
  factory GetHouseResponse.fromJson(Map<String, dynamic> json) =>
      _$GetHouseResponseFromJson(json);
}
