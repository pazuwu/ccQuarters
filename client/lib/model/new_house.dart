import 'dart:typed_data';

class NewHouse {
  NewHouse(
    this.location,
    this.houseDetails, {
    this.offerType = OfferType.rent,
    this.buildingType = BuildingType.house,
  });
  NewLocation location;
  NewHouseDetails houseDetails;
  OfferType offerType;
  BuildingType buildingType;
  List<Uint8List> photos = <Uint8List>[];
}

class NewLocation {
  NewLocation({
    this.city = '',
    this.district,
    this.streetName,
    this.zipCode = '',
    this.streetNumber,
    this.flatNumber,
    this.geoX,
    this.geoY,
  });

  String city;
  String? district;
  String? streetName;
  String zipCode;
  String? streetNumber;
  String? flatNumber;
  double? geoX;
  double? geoY;
}

class NewHouseDetails {
  NewHouseDetails({
    this.description = "",
    this.title = "",
    this.price = 0,
    this.roomCount = 0,
    this.area = 0,
    this.floor,
  });

  String description;
  String title;
  double price;
  int roomCount;
  double area;
  int? floor;
}

enum BuildingType {
  house,
  apartment,
  room;

  @override
  toString() => name;
}

extension BuildingTypeEx on BuildingType {
  String get name {
    switch (this) {
      case BuildingType.house:
        return "Dom";
      case BuildingType.apartment:
        return "Mieszkanie";
      case BuildingType.room:
        return "Pokój";
    }
  }
}

enum OfferType {
  rent,
  sale;

  @override
  toString() => name;
}

extension OfferTypeEx on OfferType {
  String get name {
    switch (this) {
      case OfferType.rent:
        return "Wynajem";
      case OfferType.sale:
        return "Sprzedaż";
    }
  }
}
