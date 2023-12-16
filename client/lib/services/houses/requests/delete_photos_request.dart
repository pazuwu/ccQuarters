import 'package:json_annotation/json_annotation.dart';

part 'delete_photos_request.g.dart';

@JsonSerializable()
class DeletePhotosRequest {
  List<String> photos;

  DeletePhotosRequest(this.photos);

  Map<String, dynamic> toJson() => _$DeletePhotosRequestToJson(this);
  factory DeletePhotosRequest.fromJson(Map<String, dynamic> json) =>
      _$DeletePhotosRequestFromJson(json);
}
