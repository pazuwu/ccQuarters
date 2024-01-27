class Location {
  Location({
    required this.city,
    required this.voivodeship,
    required this.zipCode,
    required this.streetNumber,
    this.district,
    this.streetName,
    this.flatNumber,
    this.geoX,
    this.geoY,
  });

  String city;
  String voivodeship;
  String? district;
  String? streetName;
  String zipCode;
  String streetNumber;
  String? flatNumber;
  double? geoX;
  double? geoY;
}
