import 'dart:convert';

class Area {
  final String? id;
  final String? transformsid;
  final String name;
  final List<String> photoIds;
  String? operationId;

  Area({
    this.id,
    this.transformsid,
    this.name = "",
    this.photoIds = const [],
    this.operationId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'transformsid': transformsid,
      'name': name,
      'photoIds': photoIds,
      'operationId': operationId,
    };
  }

  factory Area.fromMap(Map<String, dynamic> map) {
    return Area(
      id: map['id'] != null ? map['id'] as String : null,
      transformsid:
          map['transformsid'] != null ? map['transformsid'] as String : null,
      name: map['name'] as String,
      photoIds: List<String>.from((map['photoIds'] as List<dynamic>? ?? [])),
      operationId:
          map['operationId'] != null ? map['operationId'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Area.fromJson(String source) =>
      Area.fromMap(json.decode(source) as Map<String, dynamic>);
}
