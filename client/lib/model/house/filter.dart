import 'package:ccquarters/model/alert/alert_base.dart';
import 'package:ccquarters/model/alert/alert_filter_base.dart';
import 'package:ccquarters/model/house/voivodeship.dart';
import 'package:json_annotation/json_annotation.dart';

class HouseFilter extends AlertFilterBase {
  HouseFilter(
      {this.title,
      minPrice,
      maxPrice,
      minPricePerM2,
      maxPricePerM2,
      minArea,
      maxArea,
      minRoomCount,
      maxRoomCount,
      floors,
      minFloor,
      buildingType,
      offerType,
      cities,
      districts,
      this.voivodeship,
      this.sortBy = SortingMethod.newest})
      : super(
          minPrice: minPrice,
          maxPrice: maxPrice,
          maxPricePerM2: maxPricePerM2,
          minPricePerM2: minPricePerM2,
          minArea: minArea,
          maxArea: maxArea,
          minRoomCount: minRoomCount,
          maxRoomCount: maxRoomCount,
          floors: floors,
          minFloor: minFloor,
          offerType: offerType,
          buildingType: buildingType,
          cities: cities ?? [],
          districts: districts ?? [],
        );

  String? title;
  Voivodeship? voivodeship;
  SortingMethod sortBy;

  HouseFilter.fromAlert(AlertBase alert)
      : voivodeship = alert.voivodeship != null
            ? VoivodeshipEx.getFromName(alert.voivodeship!)
            : null,
        sortBy = SortingMethod.newest,
        super(
          minPrice: alert.minPrice,
          maxPrice: alert.maxPrice,
          maxPricePerM2: alert.maxPricePerM2,
          minPricePerM2: alert.minPricePerM2,
          minArea: alert.minArea,
          maxArea: alert.maxArea,
          minRoomCount: alert.minRoomCount,
          maxRoomCount: alert.maxRoomCount,
          floors: alert.floors,
          minFloor: alert.minFloor,
          offerType: alert.offerType,
          buildingType: alert.buildingType,
          cities: alert.cities ?? [],
          districts: alert.districts ?? [],
        );
}

enum SortingMethod {
  newest,
  lowestPrice,
  highestPrice,
  lowestPricePerMeter,
  highestPricePerMeter;

  @override
  String toString() {
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

class FloorNumber {
  FloorNumber(this.floorNumber);

  FloorNumber.aboveTen() : floorNumber = 11 {
    isAboveTen = true;
  }

  int floorNumber;
  bool isAboveTen = false;

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
          floorNumber == other.floorNumber &&
          isAboveTen == other.isAboveTen;

  @override
  int get hashCode => floorNumber.hashCode;
}
