import 'package:ccquarters/model/houses/building_type.dart';
import 'package:ccquarters/model/houses/offer_type.dart';

class AlertFilterBase {
  double? minPrice;
  double? maxPrice;
  double? minPricePerM2;
  double? maxPricePerM2;
  double? minArea;
  double? maxArea;
  int? minRoomCount;
  int? maxRoomCount;
  List<int>? floors;
  int? minFloor;
  @BuildingTypeConverter()
  BuildingType? buildingType;
  @OfferTypeConverter()
  OfferType? offerType;
  List<String>? cities;
  List<String>? districts;

  AlertFilterBase({
    this.minPrice,
    this.maxPrice,
    this.maxPricePerM2,
    this.minPricePerM2,
    this.minArea,
    this.maxArea,
    this.minRoomCount,
    this.maxRoomCount,
    this.floors,
    this.minFloor,
    this.offerType,
    this.buildingType,
    this.cities,
    this.districts,
  });
}
