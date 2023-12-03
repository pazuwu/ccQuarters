// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_house_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetHouseResponse _$GetHouseResponseFromJson(Map<String, dynamic> json) =>
    GetHouseResponse(
      DetailedHouse.fromJson(json['house'] as Map<String, dynamic>),
      (json['photos'] as List<dynamic>?)
          ?.map((e) => Photo.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetHouseResponseToJson(GetHouseResponse instance) =>
    <String, dynamic>{
      'house': instance.house,
      'photos': instance.photos,
    };
