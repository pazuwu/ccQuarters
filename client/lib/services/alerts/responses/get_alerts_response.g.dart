// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_alerts_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetAlertsResponse _$GetAlertsResponseFromJson(Map<String, dynamic> json) =>
    GetAlertsResponse(
      alerts: (json['alerts'] as List<dynamic>)
          .map((e) => Alert.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetAlertsResponseToJson(GetAlertsResponse instance) =>
    <String, dynamic>{
      'alerts': instance.alerts,
    };
