// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'houses_filter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HousesFilter _$HousesFilterFromJson(Map<String, dynamic> json) => HousesFilter(
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
          ?.map((e) => $enumDecode(_$OfferTypeEnumMap, e))
          .toList(),
      (json['buildingTypes'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$BuildingTypeEnumMap, e))
          .toList(),
      (json['cities'] as List<dynamic>?)?.map((e) => e as String).toList(),
      (json['voivodeships'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      (json['districts'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$HousesFilterToJson(HousesFilter instance) =>
    <String, dynamic>{
      'minPrice': instance.minPrice,
      'maxPrice': instance.maxPrice,
      'minPricePerM2': instance.minPricePerM2,
      'maxPricePerM2': instance.maxPricePerM2,
      'maxArea': instance.maxArea,
      'minArea': instance.minArea,
      'maxRoomCount': instance.maxRoomCount,
      'minRoomCount': instance.minRoomCount,
      'floors': instance.floors,
      'minFloor': instance.minFloor,
      'maxFloor': instance.maxFloor,
      'offerTypes':
          instance.offerTypes?.map((e) => _$OfferTypeEnumMap[e]!).toList(),
      'buildingTypes': instance.buildingTypes
          ?.map((e) => _$BuildingTypeEnumMap[e]!)
          .toList(),
      'cities': instance.cities,
      'voivodeships': instance.voivodeships,
      'districts': instance.districts,
    };

const _$OfferTypeEnumMap = {
  OfferType.rent: 'rent',
  OfferType.sale: 'sale',
};

const _$BuildingTypeEnumMap = {
  BuildingType.house: 'house',
  BuildingType.apartment: 'apartment',
  BuildingType.room: 'room',
};
