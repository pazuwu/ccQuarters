import 'package:json_annotation/json_annotation.dart';

part 'photo.g.dart';

@JsonSerializable()
class Photo {
  Photo({
    required this.filename,
    required this.url,
    required this.order,
  });

  String filename;
  String url;
  int order;

  Map<String, dynamic> toJson() => _$PhotoToJson(this);
  factory Photo.fromJson(Map<String, dynamic> json) => _$PhotoFromJson(json);
}
