// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'detailed_house.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DetailedHouse _$DetailedHouseFromJson(Map<String, dynamic> json) =>
    DetailedHouse(
      json['title'] as String,
      json['description'] as String?,
      json['details'] as Map<String, dynamic>,
      (json['price'] as num).toDouble(),
      json['roomCount'] as int,
      (json['area'] as num).toDouble(),
      json['floor'] as int?,
      json['city'] as String,
      json['zipCode'] as String,
      json['district'] as String?,
      json['streetName'] as String?,
      json['streetNumber'] as String?,
      json['flatNumber'] as String?,
      (json['geoX'] as num?)?.toDouble(),
      (json['geoY'] as num?)?.toDouble(),
      const OfferTypeConverter().fromJson(json['offerType'] as int),
      const BuildingTypeConverter().fromJson(json['buildingType'] as int),
      json['isLiked'] as bool,
      json['userName'] as String?,
      json['userSurname'] as String?,
      json['userCompany'] as String?,
      json['userEmail'] as String?,
      json['userPhoneNumber'] as String?,
      json['userPhotoUrl'] as String?,
    );

Map<String, dynamic> _$DetailedHouseToJson(DetailedHouse instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'details': instance.details,
      'price': instance.price,
      'roomCount': instance.roomCount,
      'area': instance.area,
      'floor': instance.floor,
      'city': instance.city,
      'zipCode': instance.zipCode,
      'district': instance.district,
      'streetName': instance.streetName,
      'streetNumber': instance.streetNumber,
      'flatNumber': instance.flatNumber,
      'geoX': instance.geoX,
      'geoY': instance.geoY,
      'offerType': const OfferTypeConverter().toJson(instance.offerType),
      'buildingType':
          const BuildingTypeConverter().toJson(instance.buildingType),
      'isLiked': instance.isLiked,
      'userName': instance.userName,
      'userSurname': instance.userSurname,
      'userCompany': instance.userCompany,
      'userEmail': instance.userEmail,
      'userPhoneNumber': instance.userPhoneNumber,
      'userPhotoUrl': instance.userPhotoUrl,
    };
