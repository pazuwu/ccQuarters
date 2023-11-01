import 'dart:convert';

class Scene {
  Scene({
    this.id,
    this.parentId,
    required this.name,
    required this.photo360Url,
  });

  final String? id;
  final String? parentId;
  final String name;
  final String? photo360Url;

  @override
  String toString() {
    return name;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'parentId': parentId,
      'name': name,
      'photo360Url': photo360Url,
    };
  }

  factory Scene.fromMap(Map<String, dynamic> map) {
    return Scene(
      id: map['id'] as String,
      parentId: map['parentId'] != null ? map['parentId'] as String : null,
      name: map['name'] as String,
      photo360Url: map['photo360Url'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Scene.fromJson(String source) =>
      Scene.fromMap(json.decode(source) as Map<String, dynamic>);
}
