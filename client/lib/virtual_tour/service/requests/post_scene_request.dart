import 'dart:convert';

class PostSceneRequest {
  final String? parentId;
  final String name;

  PostSceneRequest({
    this.parentId,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'parentId': parentId,
      'name': name,
    };
  }

  factory PostSceneRequest.fromMap(Map<String, dynamic> map) {
    return PostSceneRequest(
      parentId: map['parentId'] != null ? map['parentId'] as String : null,
      name: map['name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory PostSceneRequest.fromJson(String source) =>
      PostSceneRequest.fromMap(json.decode(source) as Map<String, dynamic>);
}
