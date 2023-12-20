import 'dart:convert';

class PutTourRequest {
  final String name;

  PutTourRequest({required this.name});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
    };
  }

  factory PutTourRequest.fromMap(Map<String, dynamic> map) {
    return PutTourRequest(
      name: map['name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory PutTourRequest.fromJson(String source) =>
      PutTourRequest.fromMap(json.decode(source) as Map<String, dynamic>);
}
