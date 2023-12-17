// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'detailed_house.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HouseWithDetails _$HouseWithDetailsFromJson(Map<String, dynamic> json) =>
    HouseWithDetails(
      json['title'] as String,
      json['description'] as String?,
      json['additionalInfo'] as Map<String, dynamic>,
      (json['price'] as num).toDouble(),
      json['roomCount'] as int,
      (json['area'] as num).toDouble(),
      json['floor'] as int?,
      json['voivodeship'] as String,
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
      json['userId'] as String,
      json['userName'] as String?,
      json['userSurname'] as String?,
      json['userCompany'] as String?,
      json['userEmail'] as String,
      json['userPhoneNumber'] as String?,
      json['userPhotoUrl'] as String?,
    );

Map<String, dynamic> _$HouseWithDetailsToJson(HouseWithDetails instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'additionalInfo': instance.additionalInfo,
      'price': instance.price,
      'roomCount': instance.roomCount,
      'area': instance.area,
      'floor': instance.floor,
      'voivodeship': instance.voivodeship,
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
      'userId': instance.userId,
      'userName': instance.userName,
      'userSurname': instance.userSurname,
      'userCompany': instance.userCompany,
      'userEmail': instance.userEmail,
      'userPhoneNumber': instance.userPhoneNumber,
      'userPhotoUrl': instance.userPhotoUrl,
    };
