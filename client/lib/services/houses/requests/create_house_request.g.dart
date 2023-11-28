// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_house_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateHouseRequest _$CreateHouseRequestFromJson(Map<String, dynamic> json) =>
    CreateHouseRequest(
      json['title'] as String?,
      (json['price'] as num?)?.toDouble(),
      json['roomCount'] as int?,
      (json['area'] as num?)?.toDouble(),
      json['floor'] as int?,
      json['description'] as String?,
      (json['additionalInfo'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      json['city'] as String?,
      json['zipCode'] as String?,
      json['district'] as String?,
      json['streetName'] as String?,
      json['streetNumber'] as String?,
      json['flatNumber'] as String?,
      (json['geoX'] as num?)?.toDouble(),
      (json['geoY'] as num?)?.toDouble(),
      $enumDecode(_$OfferTypeEnumMap, json['offerType']),
      $enumDecode(_$BuildingTypeEnumMap, json['buildingType']),
    );

Map<String, dynamic> _$CreateHouseRequestToJson(CreateHouseRequest instance) =>
    <String, dynamic>{
      'title': instance.title,
      'price': instance.price,
      'roomCount': instance.roomCount,
      'area': instance.area,
      'floor': instance.floor,
      'description': instance.description,
      'additionalInfo': instance.additionalInfo,
      'city': instance.city,
      'zipCode': instance.zipCode,
      'district': instance.district,
      'streetName': instance.streetName,
      'streetNumber': instance.streetNumber,
      'flatNumber': instance.flatNumber,
      'geoX': instance.geoX,
      'geoY': instance.geoY,
      'offerType': _$OfferTypeEnumMap[instance.offerType]!,
      'buildingType': _$BuildingTypeEnumMap[instance.buildingType]!,
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
