import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  String id;
  String? name;
  String? surname;
  String? company;
  String email;
  String? phoneNumber;
  String? photoUrl;
  DateTime registerTime = DateTime(2021, 1, 1);

  User(this.id, this.name, this.surname, this.company, this.email,
      this.phoneNumber, this.photoUrl, this.registerTime);

  User.fromGetHouses(this.name, this.surname, this.company, this.email,
      this.phoneNumber, this.photoUrl)
      : id = "";

  User.empty() : this("", "", "", "", "", "", "", DateTime.now());

  Map<String, dynamic> toJson() => _$UserToJson(this);
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
