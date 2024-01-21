import 'dart:convert';

class PutSceneRequest {
  String? name;
  PutSceneRequest({
    this.name,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
    };
  }

  factory PutSceneRequest.fromMap(Map<String, dynamic> map) {
    return PutSceneRequest(
      name: map['name'] != null ? map['name'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PutSceneRequest.fromJson(String source) =>
      PutSceneRequest.fromMap(json.decode(source) as Map<String, dynamic>);
}
