// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_houses_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetHousesRequestBody _$GetHousesRequestBodyFromJson(
        Map<String, dynamic> json) =>
    GetHousesRequestBody(
      $enumDecodeNullable(_$SortingMethodEnumMap, json['sortMethod']),
      json['filter'] == null
          ? null
          : HousesFilter.fromJson(json['filter'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GetHousesRequestBodyToJson(
        GetHousesRequestBody instance) =>
    <String, dynamic>{
      'sortMethod': _$SortingMethodEnumMap[instance.sortMethod],
      'filter': instance.filter,
    };

const _$SortingMethodEnumMap = {
  SortingMethod.newest: 'newest',
  SortingMethod.lowestPrice: 'lowestPrice',
  SortingMethod.highestPrice: 'highestPrice',
  SortingMethod.lowestPricePerMeter: 'lowestPricePerMeter',
  SortingMethod.highestPricePerMeter: 'highestPricePerMeter',
};
