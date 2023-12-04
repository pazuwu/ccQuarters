// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      json['id'] as String,
      json['name'] as String,
      json['surname'] as String,
      json['company'] as String?,
      json['email'] as String,
      json['phoneNumber'] as String?,
      json['photoUrl'] as String?,
      DateTime.parse(json['registerTime'] as String),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'surname': instance.surname,
      'company': instance.company,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'photoUrl': instance.photoUrl,
      'registerTime': instance.registerTime.toIso8601String(),
    };
