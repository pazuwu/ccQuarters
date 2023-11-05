import 'package:ccquarters/model/building_type.dart';
import 'package:ccquarters/model/offer_type.dart';

class HouseFilter {
  HouseFilter(
      {this.title,
      this.minPrice,
      this.maxPrice,
      this.minPricePerMeter,
      this.maxPricePerMeter,
      this.minArea,
      this.maxArea,
      this.minRoomCount,
      this.maxRoomCount,
      this.floor,
      this.minFloor,
      this.buildingType,
      this.offerType,
      this.sortBy = SortByType.newest});

  String? title;
  double? minPrice;
  double? maxPrice;
  double? minPricePerMeter;
  double? maxPricePerMeter;
  double? minArea;
  double? maxArea;
  int? minRoomCount;
  int? maxRoomCount;
  List<int>? floor;
  int? minFloor;
  BuildingType? buildingType;
  OfferType? offerType;
  SortByType sortBy;
}

enum SortByType {
  newest,
  lowestPrice,
  highestPrice,
  lowestPricePerMeter,
  highestPricePerMeter;

  @override
  toString() => name;
}

extension SortByTypeEx on SortByType {
  String get name {
    switch (this) {
      case SortByType.newest:
        return "Najnowsze";
      case SortByType.lowestPrice:
        return "Najtańsze";
      case SortByType.highestPrice:
        return "Najdroższe";
      case SortByType.lowestPricePerMeter:
        return "Najtańsze za m2";
      case SortByType.highestPricePerMeter:
        return "Najdroższe za m2";
    }
  }
}

class FloorNumber {
  FloorNumber(this.floorNumber);

  int floorNumber;

  @override
  String toString() {
    if (floorNumber == 0) {
      return "Parter";
    } else if (floorNumber > 10) {
      return "Powyżej 10";
    } else if (floorNumber > 0) {
      return floorNumber.toString();
    } else {
      return "Poniżej 0";
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FloorNumber &&
          runtimeType == other.runtimeType &&
          floorNumber == other.floorNumber;

  @override
  int get hashCode => floorNumber.hashCode;
}
