import 'dart:convert';

class PostTourRequest {
  String name;

  PostTourRequest({
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
    };
  }

  factory PostTourRequest.fromMap(Map<String, dynamic> map) {
    return PostTourRequest(
      name: map['name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory PostTourRequest.fromJson(String source) =>
      PostTourRequest.fromMap(json.decode(source) as Map<String, dynamic>);
}
