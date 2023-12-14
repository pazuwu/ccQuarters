import 'dart:convert';

class TourInfo {
  String id;
  String name;

  TourInfo({required this.id, required this.name});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
    };
  }

  factory TourInfo.fromMap(Map<String, dynamic> map) {
    return TourInfo(
      id: map['id'] as String,
      name: map['name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory TourInfo.fromJson(String source) =>
      TourInfo.fromMap(json.decode(source) as Map<String, dynamic>);
}
