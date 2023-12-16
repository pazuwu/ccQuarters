import 'package:ccquarters/model/building_type.dart';

class HouseDetails {
  HouseDetails({
    this.description,
    required this.title,
    required this.price,
    required this.area,
    this.roomCount,
    this.floor,
    required this.buildingType,
    this.virtualTourId,
  });

  String? description;
  String title;
  double price;
  int? roomCount;
  double area;
  int? floor;
  BuildingType buildingType;
  String? virtualTourId;
}
