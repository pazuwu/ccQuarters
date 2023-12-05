// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_houses_query.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetHousesQuery _$GetHousesQueryFromJson(Map<String, dynamic> json) =>
    GetHousesQuery(
      json['pageSize'] as int?,
      json['pageNumber'] as int?,
      _$JsonConverterFromJson<int, SortingMethod>(
          json['sortMethod'], const SortingMethodConverter().fromJson),
      (json['minPrice'] as num?)?.toDouble(),
      (json['maxPrice'] as num?)?.toDouble(),
      (json['minPricePerM2'] as num?)?.toDouble(),
      (json['maxPricePerM2'] as num?)?.toDouble(),
      (json['maxArea'] as num?)?.toDouble(),
      (json['minArea'] as num?)?.toDouble(),
      json['maxRoomCount'] as int?,
      json['minRoomCount'] as int?,
      (json['floors'] as List<dynamic>?)?.map((e) => e as int).toList(),
      json['minFloor'] as int?,
      json['maxFloor'] as int?,
      (json['offerTypes'] as List<dynamic>?)
          ?.map((e) => const OfferTypeConverter().fromJson(e as int))
          .toList(),
      (json['buildingTypes'] as List<dynamic>?)
          ?.map((e) => const BuildingTypeConverter().fromJson(e as int))
          .toList(),
      json['voivodeship'] as String?,
      (json['cities'] as List<dynamic>?)?.map((e) => e as String).toList(),
      (json['districts'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$GetHousesQueryToJson(GetHousesQuery instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('pageSize', instance.pageSize);
  writeNotNull('pageNumber', instance.pageNumber);
  writeNotNull(
      'sortMethod',
      _$JsonConverterToJson<int, SortingMethod>(
          instance.sortMethod, const SortingMethodConverter().toJson));
  writeNotNull('minPrice', instance.minPrice);
  writeNotNull('maxPrice', instance.maxPrice);
  writeNotNull('minPricePerM2', instance.minPricePerM2);
  writeNotNull('maxPricePerM2', instance.maxPricePerM2);
  writeNotNull('maxArea', instance.maxArea);
  writeNotNull('minArea', instance.minArea);
  writeNotNull('maxRoomCount', instance.maxRoomCount);
  writeNotNull('minRoomCount', instance.minRoomCount);
  writeNotNull('floors', instance.floors);
  writeNotNull('minFloor', instance.minFloor);
  writeNotNull('maxFloor', instance.maxFloor);
  writeNotNull('offerTypes',
      instance.offerTypes?.map(const OfferTypeConverter().toJson).toList());
  writeNotNull(
      'buildingTypes',
      instance.buildingTypes
          ?.map(const BuildingTypeConverter().toJson)
          .toList());
  writeNotNull('voivodeship', instance.voivodeship);
  writeNotNull('cities', instance.cities);
  writeNotNull('districts', instance.districts);
  return val;
}

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
