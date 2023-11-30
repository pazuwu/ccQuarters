// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alert.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Alert _$AlertFromJson(Map<String, dynamic> json) => Alert(
      id: json['id'] as String,
      userId: json['userId'] as String,
      maxPrice: (json['maxPrice'] as num?)?.toDouble(),
      maxPricePerM2: (json['maxPricePerM2'] as num?)?.toDouble(),
      minArea: (json['minArea'] as num?)?.toDouble(),
      maxArea: (json['maxArea'] as num?)?.toDouble(),
      minRoomCount: json['minRoomCount'] as int?,
      maxRoomCount: json['maxRoomCount'] as int?,
      floor: json['floor'] as int?,
      offerType: $enumDecodeNullable(_$OfferTypeEnumMap, json['offerType']),
      buildingType:
          $enumDecodeNullable(_$BuildingTypeEnumMap, json['buildingType']),
      city: json['city'] as String?,
      zipCode: json['zipCode'] as String?,
      district: json['district'] as String?,
      streetName: json['streetName'] as String?,
      streetNumber: json['streetNumber'] as String?,
      flatNumber: json['flatNumber'] as String?,
    );

Map<String, dynamic> _$AlertToJson(Alert instance) => <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'maxPrice': instance.maxPrice,
      'maxPricePerM2': instance.maxPricePerM2,
      'minArea': instance.minArea,
      'maxArea': instance.maxArea,
      'minRoomCount': instance.minRoomCount,
      'maxRoomCount': instance.maxRoomCount,
      'floor': instance.floor,
      'offerType': _$OfferTypeEnumMap[instance.offerType],
      'buildingType': _$BuildingTypeEnumMap[instance.buildingType],
      'city': instance.city,
      'zipCode': instance.zipCode,
      'district': instance.district,
      'streetName': instance.streetName,
      'streetNumber': instance.streetNumber,
      'flatNumber': instance.flatNumber,
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
