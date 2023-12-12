// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'simple_house.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SimpleHouse _$SimpleHouseFromJson(Map<String, dynamic> json) => SimpleHouse(
      json['id'] as String,
      json['title'] as String,
      (json['price'] as num).toDouble(),
      json['roomCount'] as int,
      (json['area'] as num).toDouble(),
      json['floor'] as int?,
      json['city'] as String,
      json['voivodeship'] as String,
      json['zipCode'] as String,
      json['district'] as String?,
      json['streetName'] as String?,
      json['streetNumber'] as String?,
      json['flatNumber'] as String?,
      const OfferTypeConverter().fromJson(json['offerType'] as int),
      const BuildingTypeConverter().fromJson(json['buildingType'] as int),
      json['isLiked'] as bool,
      json['photoUrl'] as String?,
    );

Map<String, dynamic> _$SimpleHouseToJson(SimpleHouse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'price': instance.price,
      'roomCount': instance.roomCount,
      'area': instance.area,
      'floor': instance.floor,
      'city': instance.city,
      'voivodeship': instance.voivodeship,
      'zipCode': instance.zipCode,
      'district': instance.district,
      'streetName': instance.streetName,
      'streetNumber': instance.streetNumber,
      'flatNumber': instance.flatNumber,
      'offerType': const OfferTypeConverter().toJson(instance.offerType),
      'buildingType':
          const BuildingTypeConverter().toJson(instance.buildingType),
      'isLiked': instance.isLiked,
      'photoUrl': instance.photoUrl,
    };
