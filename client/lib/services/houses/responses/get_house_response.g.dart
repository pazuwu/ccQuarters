// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_house_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetHouseResponse _$GetHouseResponseFromJson(Map<String, dynamic> json) =>
    GetHouseResponse(
      DetailedHouse.fromJson(json['house'] as Map<String, dynamic>),
      (json['photoUrls'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$GetHouseResponseToJson(GetHouseResponse instance) =>
    <String, dynamic>{
      'house': instance.house,
      'photoUrls': instance.photoUrls,
    };
