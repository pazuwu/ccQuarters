import 'dart:convert';

import 'package:ccquarters/model/virtual_tours/geo_point.dart';

class Link {
  Link(
      {this.id,
      this.parentId,
      required this.destinationId,
      required this.position,
      this.nextOrientation,
      this.text});

  final String? id;
  final String? parentId;
  final String destinationId;
  final GeoPoint position;
  final GeoPoint? nextOrientation;
  final String? text;

  Link copyWith({
    String? id,
    String? parentId,
    String? destinationId,
    GeoPoint? position,
    GeoPoint? nextOrientation,
    String? text,
  }) {
    return Link(
      id: id ?? this.id,
      parentId: parentId ?? this.parentId,
      destinationId: destinationId ?? this.destinationId,
      position: position ?? this.position,
      nextOrientation: nextOrientation ?? this.nextOrientation,
      text: text ?? this.text,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'parentId': parentId,
      'destinationId': destinationId,
      'position': position.toMap(),
      'nextOrientation': nextOrientation?.toMap(),
      'text': text,
    };
  }

  factory Link.fromMap(Map<String, dynamic> map) {
    return Link(
      id: map['id'] as String,
      parentId: map['parentId'] != null ? map['parentId'] as String : null,
      destinationId: map['destinationId'] as String,
      position: GeoPoint.fromMap(map['position'] as Map<String, dynamic>),
      nextOrientation: map['nextOrientation'] != null
          ? GeoPoint.fromMap(map['nextOrientation'] as Map<String, dynamic>)
          : null,
      text: map['text'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Link.fromJson(String source) =>
      Link.fromMap(json.decode(source) as Map<String, dynamic>);
}
