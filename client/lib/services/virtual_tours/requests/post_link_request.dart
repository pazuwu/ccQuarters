import 'dart:convert';

import 'package:ccquarters/model/virtual_tour/geo_point.dart';

class PostLinkRequest {
  final String? parentId;
  final String? text;
  final String? destinationId;
  final GeoPoint? position;
  final GeoPoint? nextOrientation;
  PostLinkRequest({
    this.parentId,
    this.text,
    this.destinationId,
    this.position,
    this.nextOrientation,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'parentId': parentId,
      'text': text,
      'destinationId': destinationId,
      'position': position?.toMap(),
      'nextOrientation': nextOrientation?.toMap(),
    };
  }

  factory PostLinkRequest.fromMap(Map<String, dynamic> map) {
    return PostLinkRequest(
      parentId: map['parentId'] != null ? map['parentId'] as String : null,
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

  factory PostLinkRequest.fromJson(String source) =>
      PostLinkRequest.fromMap(json.decode(source) as Map<String, dynamic>);
}
