// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:ccquarters/model/virtual_tours/area.dart';
import 'package:ccquarters/model/virtual_tours/link.dart';
import 'package:ccquarters/model/virtual_tours/scene.dart';
import 'package:ccquarters/model/virtual_tours/tour.dart';

class TourForEdit extends Tour {
  final List<Area> areas;

  TourForEdit({
    required super.id,
    required super.name,
    required super.ownerId,
    super.primarySceneId,
    super.scenes,
    super.links,
    required this.areas,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'areas': areas.map((x) => x.toMap()).toList(),
    }..addAll(super.toMap());
  }

  factory TourForEdit.fromMap(Map<String, dynamic> map) {
    return TourForEdit(
      name: map['name'] as String,
      id: map['id'] as String,
      ownerId: map['ownerId'] as String,
      primarySceneId: map['primarySceneId'] != null
          ? map['primarySceneId'] as String
          : null,
      scenes: List<Scene>.from(
        (map['scenes'] as List<dynamic>).map<Scene>(
          (x) => Scene.fromMap(x as Map<String, dynamic>),
        ),
      ),
      links: List<Link>.from(
        (map['links'] as List<dynamic>).map<Link>(
          (x) => Link.fromMap(x as Map<String, dynamic>),
        ),
      ),
      areas: List<Area>.from(
        (map['areas'] as List<dynamic>).map<Area>(
          (x) => Area.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory TourForEdit.fromJson(String source) =>
      TourForEdit.fromMap(json.decode(source) as Map<String, dynamic>);
}
