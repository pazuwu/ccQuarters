import 'dart:convert';

class GeoPoint {
  final double latitude;
  final double longitude;

  GeoPoint({required this.latitude, required this.longitude});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory GeoPoint.fromMap(Map<String, dynamic> map) {
    return GeoPoint(
      latitude: double.tryParse(map['latitude'].toString()) ??
          int.tryParse(map['latitude'])?.toDouble() ??
          0.0,
      longitude: double.tryParse(map['longitude'].toString()) ??
          int.tryParse(map['longitude'])?.toDouble() ??
          0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory GeoPoint.fromJson(String source) =>
      GeoPoint.fromMap(json.decode(source) as Map<String, dynamic>);
}
