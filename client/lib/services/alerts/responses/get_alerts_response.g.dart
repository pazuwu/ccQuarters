// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_alerts_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetAlertsResponse _$GetAlertsResponseFromJson(Map<String, dynamic> json) =>
    GetAlertsResponse(
      data: (json['data'] as List<dynamic>)
          .map((e) => Alert.fromJson(e as Map<String, dynamic>))
          .toList(),
      pageNumber: json['pageNumber'] as int,
      pageSize: json['pageSize'] as int,
    );

Map<String, dynamic> _$GetAlertsResponseToJson(GetAlertsResponse instance) =>
    <String, dynamic>{
      'data': instance.data,
      'pageNumber': instance.pageNumber,
      'pageSize': instance.pageSize,
    };
