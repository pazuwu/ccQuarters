// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_houses_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetHousesResponse _$GetHousesResponseFromJson(Map<String, dynamic> json) =>
    GetHousesResponse(
      json['pageNumber'] as int,
      json['count'] as int,
      (json['houses'] as List<dynamic>)
          .map((e) => SimpleHouse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetHousesResponseToJson(GetHousesResponse instance) =>
    <String, dynamic>{
      'houses': instance.houses,
      'pageNumber': instance.pageNumber,
      'count': instance.count,
    };
