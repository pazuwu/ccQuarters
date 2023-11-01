import 'dart:convert';

class Area {
  final String? id;
  final String? transformsid;
  final String name;

  Area({
    this.id,
    this.transformsid,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'transformsid': transformsid,
      'name': name,
    };
  }

  factory Area.fromMap(Map<String, dynamic> map) {
    return Area(
      id: map['id'] as String,
      transformsid:
          map['transformsid'] != null ? map['transformsid'] as String : null,
      name: map['name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Area.fromJson(String source) =>
      Area.fromMap(json.decode(source) as Map<String, dynamic>);
}
