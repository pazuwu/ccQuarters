// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:ccquarters/virtual_tour/model/geo_point.dart';

class PostLinkRequest {
  final String? parentId;
  final String? text;
  final String? destinationId;
  final double? latitude;
  final double? longitude;
  final GeoPoint? nextOrientation;
  PostLinkRequest({
    this.parentId,
    this.text,
    this.destinationId,
    this.latitude,
    this.longitude,
    this.nextOrientation,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'parentId': parentId,
      'text': text,
      'destinationId': destinationId,
      'latitude': latitude,
      'longitude': longitude,
      'nextOrientation': nextOrientation?.toMap(),
    };
  }

  factory PostLinkRequest.fromMap(Map<String, dynamic> map) {
    return PostLinkRequest(
      parentId: map['parentId'] != null ? map['parentId'] as String : null,
      text: map['text'] != null ? map['text'] as String : null,
      destinationId:
          map['destinationId'] != null ? map['destinationId'] as String : null,
      latitude: map['latitude'] != null ? map['latitude'] as double : null,
      longitude: map['longitude'] != null ? map['longitude'] as double : null,
      nextOrientation: map['nextOrientation'] != null
          ? GeoPoint.fromMap(map['nextOrientation'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PostLinkRequest.fromJson(String source) =>
      PostLinkRequest.fromMap(json.decode(source) as Map<String, dynamic>);
}
