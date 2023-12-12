import 'package:ccquarters/model/alert.dart';
import 'package:ccquarters/model/building_type.dart';
import 'package:ccquarters/model/offer_type.dart';
import 'package:ccquarters/model/voivodeship.dart';
import 'package:json_annotation/json_annotation.dart';

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
      this.sortBy = SortingMethod.newest});

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
  Voivodeship? voivodeship;
  List<String> cities = [];
  List<String> districts = [];
  SortingMethod sortBy;

  HouseFilter.fromAlert(Alert alert)
      : minPrice = alert.maxPrice,
        maxPrice = alert.maxPrice,
        minPricePerMeter = alert.maxPricePerM2,
        maxPricePerMeter = alert.maxPricePerM2,
        minArea = alert.minArea,
        maxArea = alert.maxArea,
        minRoomCount = alert.minRoomCount,
        maxRoomCount = alert.maxRoomCount,
        floor = alert.floor != null ? [alert.floor!] : null,
        buildingType = alert.buildingType,
        offerType = alert.offerType,
        sortBy = SortingMethod.newest;
}

enum SortingMethod {
  newest,
  lowestPrice,
  highestPrice,
  lowestPricePerMeter,
  highestPricePerMeter;

  @override
  toString() => name;
}

class SortingMethodConverter implements JsonConverter<SortingMethod, int> {
  const SortingMethodConverter();

  @override
  SortingMethod fromJson(int json) {
    return SortingMethod.values[json];
  }

  @override
  int toJson(SortingMethod? object) {
    if (object == null) {
      return 0;
    }

    return object.index;
  }
}

extension SortByTypeEx on SortingMethod {
  String get name {
    switch (this) {
      case SortingMethod.newest:
        return "Najnowsze";
      case SortingMethod.lowestPrice:
        return "Najtańsze";
      case SortingMethod.highestPrice:
        return "Najdroższe";
      case SortingMethod.lowestPricePerMeter:
        return "Najtańsze za m2";
      case SortingMethod.highestPricePerMeter:
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
