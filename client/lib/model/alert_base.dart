import 'package:ccquarters/model/alert_filter_base.dart';
import 'package:ccquarters/model/building_type.dart';
import 'package:ccquarters/model/filter.dart';
import 'package:ccquarters/model/offer_type.dart';


abstract class AlertBase extends AlertFilterBase {
  String? voivodeship;

  AlertBase({
    double? minPrice,
    double? maxPrice,
    double? maxPricePerM2,
    double? minPricePerM2,
    double? minArea,
    double? maxArea,
    int? minRoomCount,
    int? maxRoomCount,
    List<int>? floors,
    int? minFloor,
    OfferType? offerType,
    BuildingType? buildingType,
    this.voivodeship,
    List<String>? cities,
    List<String>? districts,
  }) : super(
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
          cities: cities,
          districts: districts,
        );

  AlertBase.empty();

  AlertBase.fromHouseFilter(HouseFilter filters)
      : voivodeship = filters.voivodeship?.toString(),
        super(
          minPrice: filters.minPrice,
          maxPrice: filters.maxPrice,
          maxPricePerM2: filters.maxPricePerM2,
          minPricePerM2: filters.minPricePerM2,
          minArea: filters.minArea,
          maxArea: filters.maxArea,
          minRoomCount: filters.minRoomCount,
          maxRoomCount: filters.maxRoomCount,
          floors: filters.floors,
          minFloor: filters.minFloor,
          offerType: filters.offerType,
          buildingType: filters.buildingType,
          cities: filters.cities,
          districts: filters.districts,
        );

}
