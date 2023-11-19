class User {
  User({
    this.name = "",
    this.surname = "",
    this.company,
    this.email = "",
    this.phoneNumber,
  });

  String name;
  String surname;
  String? company;
  String email;
  String? phoneNumber;
  String? photoUrl =
      "https://picsum.photos/512?=${DateTime.now().millisecondsSinceEpoch}";
  DateTime registrationDate = DateTime(2021, 1, 1);
}
