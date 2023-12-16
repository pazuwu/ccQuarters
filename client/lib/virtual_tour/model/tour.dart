import 'dart:convert';

import 'package:ccquarters/virtual_tour/model/area.dart';
import 'package:ccquarters/virtual_tour/model/link.dart';
import 'package:ccquarters/virtual_tour/model/scene.dart';

class Tour {
  Tour({
    required this.name,
    required this.id,
    this.areas = const [],
    this.scenes = const [],
    this.links = const [],
  });

  final String name;
  final String id;
  final List<Area> areas;
  final List<Scene> scenes;
  final List<Link> links;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'id': id,
      'areas': areas.map((x) => x.toMap()).toList(),
      'scenes': scenes.map((x) => x.toMap()).toList(),
      'links': links.map((x) => x.toMap()).toList(),
    };
  }

  factory Tour.fromMap(Map<String, dynamic> map) {
    return Tour(
      name: map['name'] as String,
      id: map['id'] as String,
      areas: List<Area>.from(
        (map['areas'] as List<dynamic>).map<Area>(
          (x) => Area.fromMap(x as Map<String, dynamic>),
        ),
      ),
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
    );
  }

  String toJson() => json.encode(toMap());

  factory Tour.fromJson(String source) =>
      Tour.fromMap(json.decode(source) as Map<String, dynamic>);
}
