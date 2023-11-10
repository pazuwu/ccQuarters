class User {
  User({
    this.name = "Jan",
    this.surname = "Kowalski",
    this.company = "CCQuarters",
    this.email = "adna@ccquarters.com",
    this.phoneNumber = "21314134",
  });

  String? name;
  String? surname;
  String? company;
  String? email;
  String? phoneNumber;
  String? photoUrl =
      "https://picsum.photos/512?=${DateTime.now().millisecondsSinceEpoch}";
  DateTime registrationDate = DateTime(2021, 1, 1);
}
