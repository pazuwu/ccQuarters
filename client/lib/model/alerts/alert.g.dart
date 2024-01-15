// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alert.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Alert _$AlertFromJson(Map<String, dynamic> json) => Alert(
      id: json['id'] as String,
      minPrice: (json['minPrice'] as num?)?.toDouble(),
      maxPrice: (json['maxPrice'] as num?)?.toDouble(),
      maxPricePerM2: (json['maxPricePerM2'] as num?)?.toDouble(),
      minPricePerM2: (json['minPricePerM2'] as num?)?.toDouble(),
      minArea: (json['minArea'] as num?)?.toDouble(),
      maxArea: (json['maxArea'] as num?)?.toDouble(),
      minRoomCount: json['minRoomCount'] as int?,
      maxRoomCount: json['maxRoomCount'] as int?,
      floors: (json['floors'] as List<dynamic>?)?.map((e) => e as int).toList(),
      minFloor: json['minFloor'] as int?,
      offerType: _$JsonConverterFromJson<int, OfferType>(
          json['offerType'], const OfferTypeConverter().fromJson),
      buildingType: _$JsonConverterFromJson<int, BuildingType>(
          json['buildingType'], const BuildingTypeConverter().fromJson),
      voivodeship: json['voivodeship'] as String?,
      cities:
          (json['cities'] as List<dynamic>?)?.map((e) => e as String).toList(),
      districts: (json['districts'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$AlertToJson(Alert instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('minPrice', instance.minPrice);
  writeNotNull('maxPrice', instance.maxPrice);
  writeNotNull('minPricePerM2', instance.minPricePerM2);
  writeNotNull('maxPricePerM2', instance.maxPricePerM2);
  writeNotNull('minArea', instance.minArea);
  writeNotNull('maxArea', instance.maxArea);
  writeNotNull('minRoomCount', instance.minRoomCount);
  writeNotNull('maxRoomCount', instance.maxRoomCount);
  writeNotNull('floors', instance.floors);
  writeNotNull('minFloor', instance.minFloor);
  writeNotNull(
      'buildingType',
      _$JsonConverterToJson<int, BuildingType>(
          instance.buildingType, const BuildingTypeConverter().toJson));
  writeNotNull(
      'offerType',
      _$JsonConverterToJson<int, OfferType>(
          instance.offerType, const OfferTypeConverter().toJson));
  writeNotNull('cities', instance.cities);
  writeNotNull('districts', instance.districts);
  writeNotNull('voivodeship', instance.voivodeship);
  val['id'] = instance.id;
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
