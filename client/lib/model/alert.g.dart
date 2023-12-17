// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alert.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Alert _$AlertFromJson(Map<String, dynamic> json) => Alert(
      id: json['id'] as String,
      minPrice: json['minPrice'],
      maxPrice: json['maxPrice'],
      maxPricePerM2: json['maxPricePerM2'],
      minPricePerM2: json['minPricePerM2'],
      minArea: json['minArea'],
      maxArea: json['maxArea'],
      minRoomCount: json['minRoomCount'],
      maxRoomCount: json['maxRoomCount'],
      floors: json['floors'],
      minFloor: json['minFloor'],
      offerType: json['offerType'],
      buildingType: json['buildingType'],
      voivodeship: json['voivodeship'] as String?,
      cities: json['cities'],
      districts: json['districts'],
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
  val['id'] = instance.id;
  writeNotNull('voivodeship', instance.voivodeship);
  return val;
}

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
