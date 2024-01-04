import 'package:ccquarters/model/user/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'update_user_request.g.dart';

@JsonSerializable()
class UpdateUserRequest {
  UpdateUserRequest(
      {required this.name,
      required this.surname,
      this.company,
      required this.email,
      this.phoneNumber});

  String? name;
  String? surname;
  String? company;
  String email;
  String? phoneNumber;

  UpdateUserRequest.fromUser(User user)
      : name = user.name,
        surname = user.surname,
        company = user.company,
        email = user.email,
        phoneNumber = user.phoneNumber;

  Map<String, dynamic> toJson() => _$UpdateUserRequestToJson(this);
  factory UpdateUserRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateUserRequestFromJson(json);
}
