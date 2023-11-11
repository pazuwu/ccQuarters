import 'dart:convert';

class PostSceneRequest {
  final String? parentId;

  PostSceneRequest({
    this.parentId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'parentId': parentId,
    };
  }

  factory PostSceneRequest.fromMap(Map<String, dynamic> map) {
    return PostSceneRequest(
      parentId: map['parentId'] != null ? map['parentId'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PostSceneRequest.fromJson(String source) =>
      PostSceneRequest.fromMap(json.decode(source) as Map<String, dynamic>);
}
