import 'package:ccquarters/model/houses/building_type.dart';
import 'package:ccquarters/model/houses/house_details.dart';
import 'package:ccquarters/model/houses/location.dart';
import 'package:ccquarters/model/houses/offer_type.dart';

class House {
  House({
    required this.id,
    required this.offerType,
    required this.isLiked,
    required this.location,
    required this.details,
    this.photoUrl,
  });

  String id;
  Location location;
  HouseDetails details;
  OfferType offerType;
  bool isLiked;
  String? photoUrl;

  getFilenameDependOnBuildingType() {
    switch (details.buildingType) {
      case BuildingType.apartment:
        return "assets/graphics/apartment.png";
      case BuildingType.house:
        return "assets/graphics/house.png";
      case BuildingType.room:
        return "assets/graphics/room.png";
    }
  }
}
