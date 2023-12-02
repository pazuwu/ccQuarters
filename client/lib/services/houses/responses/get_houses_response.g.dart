// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_houses_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetHousesResponse _$GetHousesResponseFromJson(Map<String, dynamic> json) =>
    GetHousesResponse(
      json['pageNumber'] as int,
      json['pageSize'] as int,
      (json['data'] as List<dynamic>)
          .map((e) => SimpleHouse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetHousesResponseToJson(GetHousesResponse instance) =>
    <String, dynamic>{
      'data': instance.data,
      'pageNumber': instance.pageNumber,
      'pageSize': instance.pageSize,
    };
