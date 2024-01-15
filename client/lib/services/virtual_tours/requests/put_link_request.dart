import 'dart:convert';

import 'package:ccquarters/model/virtual_tours/geo_point.dart';

class PutLinkRequest {
  final String? text;
  final String? destinationId;
  final GeoPoint? position;
  final GeoPoint? nextOrientation;
  PutLinkRequest({
    this.text,
    this.destinationId,
    this.position,
    this.nextOrientation,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'text': text,
      'destinationId': destinationId,
      'position': position?.toMap(),
      'nextOrientation': nextOrientation?.toMap(),
    };
  }

  factory PutLinkRequest.fromMap(Map<String, dynamic> map) {
    return PutLinkRequest(
      text: map['text'] != null ? map['text'] as String : null,
      destinationId:
          map['destinationId'] != null ? map['destinationId'] as String : null,
      position: map['position'] != null
          ? GeoPoint.fromMap(map['position'] as Map<String, dynamic>)
          : null,
      nextOrientation: map['nextOrientation'] != null
          ? GeoPoint.fromMap(map['nextOrientation'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PutLinkRequest.fromJson(String source) =>
      PutLinkRequest.fromMap(json.decode(source) as Map<String, dynamic>);
}
