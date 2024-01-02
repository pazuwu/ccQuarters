import 'dart:convert';

class PostAreaRequest {
  final String name;

  PostAreaRequest({required this.name});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
    };
  }

  factory PostAreaRequest.fromMap(Map<String, dynamic> map) {
    return PostAreaRequest(
      name: map['name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory PostAreaRequest.fromJson(String source) =>
      PostAreaRequest.fromMap(json.decode(source) as Map<String, dynamic>);
}
