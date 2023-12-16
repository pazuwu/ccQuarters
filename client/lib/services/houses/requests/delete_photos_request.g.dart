// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_photos_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeletePhotosRequest _$DeletePhotosRequestFromJson(Map<String, dynamic> json) =>
    DeletePhotosRequest(
      (json['filenames'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$DeletePhotosRequestToJson(
        DeletePhotosRequest instance) =>
    <String, dynamic>{
      'filenames': instance.filenames,
    };
