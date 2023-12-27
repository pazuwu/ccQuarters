import 'package:ccquarters/model/building_type.dart';
import 'package:ccquarters/model/filter.dart';
import 'package:ccquarters/model/offer_type.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_houses_query.g.dart';

@JsonSerializable(includeIfNull: false)
class GetHousesQuery {
  int? pageSize;
  int? pageNumber;
  @SortingMethodConverter()
  SortingMethod? sortMethod;
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
  OfferType? offerType;
  @BuildingTypeConverter()
  BuildingType? buildingType;
  String? voivodeship;
  List<String>? cities;
  List<String>? districts;

  GetHousesQuery(
    this.pageSize,
    this.pageNumber,
    this.sortMethod,
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
    this.offerType,
    this.buildingType,
    this.voivodeship,
    this.cities,
    this.districts,
  );

  GetHousesQuery.fromHouseFilter(
      HouseFilter? filter, this.pageSize, this.pageNumber)
      : sortMethod = filter?.sortBy,
        minPrice = filter?.minPrice,
        maxPrice = filter?.maxPrice,
        minPricePerM2 = filter?.minPricePerM2,
        maxPricePerM2 = filter?.maxPricePerM2,
        maxArea = filter?.maxArea,
        minArea = filter?.minArea,
        maxRoomCount = filter?.maxRoomCount,
        minRoomCount = filter?.minRoomCount,
        floors = filter?.floors,
        minFloor = filter?.minFloor,
        offerType = filter?.offerType,
        buildingType = filter?.buildingType,
        voivodeship = filter?.cities?.isNotEmpty ?? false
            ? filter!.voivodeship.toString()
            : null,
        cities = filter?.cities,
        districts = filter?.districts;

  Map<String, dynamic> toJson() => _$GetHousesQueryToJson(this);
  factory GetHousesQuery.fromJson(Map<String, dynamic> json) =>
      _$GetHousesQueryFromJson(json);
}
