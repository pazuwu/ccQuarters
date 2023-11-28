class User {
  User({
    this.name = "",
    this.surname = "",
    this.company,
    this.email = "",
    this.phoneNumber,
    this.photoUrl,
  });

  String name;
  String surname;
  String? company;
  String email;
  String? phoneNumber;
  String? photoUrl;
  DateTime registrationDate = DateTime(2021, 1, 1);
}
