import 'dart:convert';

class PutTourRequest {
  final String? name;
  final String? primarySceneId;

  PutTourRequest({
    this.name,
    this.primarySceneId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'primarySceneId': primarySceneId,
    };
  }

  factory PutTourRequest.fromMap(Map<String, dynamic> map) {
    return PutTourRequest(
      name: map['name'] != null ? map['name'] as String : null,
      primarySceneId: map['primarySceneId'] != null
          ? map['primarySceneId'] as String
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PutTourRequest.fromJson(String source) =>
      PutTourRequest.fromMap(json.decode(source) as Map<String, dynamic>);
}
