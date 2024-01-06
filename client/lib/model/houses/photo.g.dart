// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Photo _$PhotoFromJson(Map<String, dynamic> json) => Photo(
      filename: json['filename'] as String,
      url: json['url'] as String,
      order: json['order'] as int,
    );

Map<String, dynamic> _$PhotoToJson(Photo instance) => <String, dynamic>{
      'filename': instance.filename,
      'url': instance.url,
      'order': instance.order,
    };
