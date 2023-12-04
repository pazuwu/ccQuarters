// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_houses_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetHousesRequestBody _$GetHousesRequestBodyFromJson(
        Map<String, dynamic> json) =>
    GetHousesRequestBody(
      _$JsonConverterFromJson<int, SortingMethod>(
          json['sortMethod'], const SortingMethodConverter().fromJson),
      json['filter'] == null
          ? null
          : HousesFilter.fromJson(json['filter'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GetHousesRequestBodyToJson(
        GetHousesRequestBody instance) =>
    <String, dynamic>{
      'sortMethod': _$JsonConverterToJson<int, SortingMethod>(
          instance.sortMethod, const SortingMethodConverter().toJson),
      'filter': instance.filter,
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
