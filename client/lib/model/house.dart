import 'package:ccquarters/model/building_type.dart';
import 'package:ccquarters/model/offer_type.dart';

class House {
  House(
    this.location,
    this.houseDetails, {
    this.offerType = OfferType.rent,
  });

  Location location;
  HouseDetails houseDetails;
  OfferType offerType;
  List<String> photos = <String>[
    "https://picsum.photos/512",
    "https://picsum.photos/600/900"
  ];
}

class Location {
  Location({
    this.city = 'Warszawa',
    this.district = "Wilanów",
    this.streetName = "Klimczaka",
    this.zipCode = '14-121',
    this.streetNumber = "12",
    this.flatNumber,
    this.geoX = 53.13136734945723,
    this.geoY = 23.14663008605068,
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
