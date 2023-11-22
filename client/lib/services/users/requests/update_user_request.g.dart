// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_user_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateUserRequest _$UpdateUserRequestFromJson(Map<String, dynamic> json) =>
    UpdateUserRequest(
      name: json['name'] as String,
      surname: json['surname'] as String,
      company: json['company'] as String?,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String?,
    );

Map<String, dynamic> _$UpdateUserRequestToJson(UpdateUserRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'surname': instance.surname,
      'company': instance.company,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
    };
