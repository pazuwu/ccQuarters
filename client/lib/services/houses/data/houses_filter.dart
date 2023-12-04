import 'package:ccquarters/model/building_type.dart';
import 'package:ccquarters/model/filter.dart';
import 'package:ccquarters/model/offer_type.dart';
import 'package:json_annotation/json_annotation.dart';

part 'houses_filter.g.dart';

@JsonSerializable()
class HousesFilter {
  double? minPrice;
  double? maxPrice;
  double? minPricePerM2;
  double? maxPricePerM2;
  double? maxArea;
  double? minArea;
  int? maxRoomCount;
  int? minRoomCount;
  List<int>? floors;
  int? minFloor;
  int? maxFloor;
  @OfferTypeConverter()
  List<OfferType>? offerTypes;
  @BuildingTypeConverter()
  List<BuildingType>? buildingTypes;
  List<CityFilter>? cities;
  List<String>? districts;

  HousesFilter(
    this.minPrice,
    this.maxPrice,
    this.minPricePerM2,
    this.maxPricePerM2,
    this.maxArea,
    this.minArea,
    this.maxRoomCount,
    this.minRoomCount,
    this.floors,
    this.minFloor,
    this.maxFloor,
    this.offerTypes,
    this.buildingTypes,
    this.cities,
    this.districts,
  );

  HousesFilter.empty();

  HousesFilter.fromHouseFilter(HouseFilter filter)
      : minPrice = filter.minPrice,
        maxPrice = filter.maxPrice,
        minPricePerM2 = filter.minPricePerMeter,
        maxPricePerM2 = filter.maxPricePerMeter,
        maxArea = filter.maxArea,
        minArea = filter.minArea,
        maxRoomCount = filter.maxRoomCount,
        minRoomCount = filter.minRoomCount,
        floors = filter.floor,
        minFloor = filter.minFloor,
        offerTypes = filter.offerType != null ? [filter.offerType!] : null,
        buildingTypes =
            filter.buildingType != null ? [filter.buildingType!] : null,
        cities = filter.voivodeshipsAndCities
            .map((e) => CityFilter(
                  e.voivodeship.name,
                  e.city,
                ))
            .toList(),
        districts = filter.districts;

  Map<String, dynamic> toJson() => _$HousesFilterToJson(this);
  factory HousesFilter.fromJson(Map<String, dynamic> json) =>
      _$HousesFilterFromJson(json);
}

@JsonSerializable()
class CityFilter {
  String voivodeship;
  String city;

  CityFilter(this.voivodeship, this.city);

  Map<String, dynamic> toJson() => _$CityFilterToJson(this);
  factory CityFilter.fromJson(Map<String, dynamic> json) =>
      _$CityFilterFromJson(json);
}
