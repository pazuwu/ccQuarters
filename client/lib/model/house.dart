import 'package:ccquarters/model/building_type.dart';
import 'package:ccquarters/model/offer_type.dart';
import 'package:ccquarters/model/user.dart';

class House {
  House(
    this.location,
    this.details,
    this.user,
    this.photos, {
    this.offerType = OfferType.rent,
    this.isLiked = false,
    this.virtualTourId = "vu7TKNy0zkPj6jHy6lIq",
  });

  String? id;
  String? virtualTourId;
  Location location;
  HouseDetails details;
  OfferType offerType;
  User user;
  bool isLiked;
  List<String> photos = <String>[
    "https://picsum.photos/600/900?=${DateTime.now().millisecondsSinceEpoch}",
    "https://picsum.photos/1900/600",
    "https://picsum.photos/512",
    "https://picsum.photos/600/900",
    "https://picsum.photos/900/600",
    "https://picsum.photos/900",
  ];
}

class Location {
  Location(
      {this.city = 'Warszawa',
      this.voivodeship = "Mazowieckie",
      this.district = "Wilanów",
      this.streetName = "Klimczaka",
      this.zipCode = '14-121',
      this.streetNumber = "12",
      this.flatNumber,
      this.geoX = 52.22202584979946,
      this.geoY = 21.006980596300632});

  String city;
  String voivodeship;
  String? district;
  String? streetName;
  String zipCode;
  String? streetNumber;
  String? flatNumber;
  double? geoX;
  double? geoY;
}

class HouseDetails {
  HouseDetails({
    this.description =
        '''Lorem ipsum is typically a corrupted version of 'De finibus bonorum et malorum', a 1st century BC text by the Roman statesman and philosopher Cicero, with words altered, added, and removed to make it nonsensical and improper Latin.''',
    this.title = "Title",
    this.price = 10000,
    this.roomCount = 3,
    this.area = 100,
    this.floor,
    this.buildingType = BuildingType.house,
  });

  String description;
  String title;
  double price;
  int? roomCount;
  double area;
  int? floor;
  BuildingType buildingType;
}
