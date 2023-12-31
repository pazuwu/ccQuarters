import 'dart:convert';

import 'package:ccquarters/model/building_type.dart';
import 'package:ccquarters/model/filter.dart';
import 'package:ccquarters/model/offer_type.dart';
import 'package:ccquarters/model/voivodeship.dart';

class HouseFilterQuery {
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
  BuildingType? buildingType;
  OfferType? offerType;
  List<String>? cities;
  List<String>? districts;
  String? title;
  Voivodeship? voivodeship;
  SortingMethod sortBy;

  HouseFilterQuery({
    this.minPrice,
    this.maxPrice,
    this.minPricePerM2,
    this.maxPricePerM2,
    this.minArea,
    this.maxArea,
    this.minRoomCount,
    this.maxRoomCount,
    this.floors,
    this.minFloor,
    this.buildingType,
    this.offerType,
    this.cities,
    this.districts,
    this.title,
    this.voivodeship,
    this.sortBy = SortingMethod.newest,
  });

  factory HouseFilterQuery.fromHouseFilter(HouseFilter filter) {
    return HouseFilterQuery(
      minPrice: filter.minPrice,
      maxPrice: filter.maxPrice,
      minPricePerM2: filter.minPricePerM2,
      maxPricePerM2: filter.maxPricePerM2,
      minArea: filter.minArea,
      maxArea: filter.maxArea,
      minRoomCount: filter.minRoomCount,
      maxRoomCount: filter.maxRoomCount,
      floors: filter.floors,
      minFloor: filter.minFloor,
      buildingType: filter.buildingType,
      offerType: filter.offerType,
      cities: filter.cities,
      districts: filter.districts,
      title: filter.title,
      voivodeship: filter.voivodeship,
      sortBy: filter.sortBy,
    );
  }

  HouseFilter toHouseFilter() {
    return HouseFilter(
      minPrice: minPrice,
      maxPrice: maxPrice,
      minPricePerM2: minPricePerM2,
      maxPricePerM2: maxPricePerM2,
      minArea: minArea,
      maxArea: maxArea,
      minRoomCount: minRoomCount,
      maxRoomCount: maxRoomCount,
      floors: floors,
      minFloor: minFloor,
      buildingType: buildingType,
      offerType: offerType,
      cities: cities,
      districts: districts,
      title: title,
      voivodeship: voivodeship,
      sortBy: sortBy,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      if (minPrice != null) 'minPrice': minPrice.toString(),
      if (maxPrice != null) 'maxPrice': maxPrice.toString(),
      if (minPricePerM2 != null) 'minPricePerM2': minPricePerM2.toString(),
      if (maxPricePerM2 != null) 'maxPricePerM2': maxPricePerM2.toString(),
      if (minArea != null) 'minArea': minArea.toString(),
      if (maxArea != null) 'maxArea': maxArea.toString(),
      if (minRoomCount != null) 'minRoomCount': minRoomCount.toString(),
      if (maxRoomCount != null) 'maxRoomCount': maxRoomCount.toString(),
      if (floors != null) 'floors': floors.toString(),
      if (minFloor != null) 'minFloor': minFloor.toString(),
      if (buildingType != null) 'buildingType': buildingType!.name,
      if (offerType != null) 'offerType': offerType!.name,
      if (cities != null && cities!.isNotEmpty) 'cities': json.encode(cities),
      if (districts != null && districts!.isNotEmpty)
        'districts': json.encode(districts),
      if (title != null) 'title': title,
      if (voivodeship != null) 'voivodeship': voivodeship!.name,
      'sortBy': sortBy.name,
    };
  }

  factory HouseFilterQuery.fromMap(Map<String, dynamic> map) {
    return HouseFilterQuery(
      minPrice: map['minPrice'] != null ? double.parse(map['minPrice']) : null,
      maxPrice: map['maxPrice'] != null ? double.parse(map['maxPrice']) : null,
      minPricePerM2: map['minPricePerM2'] != null
          ? double.parse(map['minPricePerM2'])
          : null,
      maxPricePerM2: map['maxPricePerM2'] != null
          ? double.parse(map['maxPricePerM2'])
          : null,
      minArea: map['minArea'] != null ? double.parse(map['minArea']) : null,
      maxArea: map['maxArea'] != null ? double.parse(map['maxArea']) : null,
      minRoomCount:
          map['minRoomCount'] != null ? int.parse(map['minRoomCount']) : null,
      maxRoomCount:
          map['maxRoomCount'] != null ? int.parse(map['maxRoomCount']) : null,
      floors:
          map['floors'] != null ? json.decode(map['floors']).cast<int>() : null,
      minFloor: map['minFloor'] != null ? int.parse(map['minFloor']) : null,
      buildingType: map['buildingType'] != null
          ? BuildingType.values.byName(map['buildingType'])
          : null,
      offerType: map['offerType'] != null
          ? OfferType.values.byName(map['offerType'])
          : null,
      cities: map['cities'] != null
          ? json.decode(map['cities']).cast<String>()
          : null,
      districts: map['districts'] != null
          ? json.decode(map['districts']).cast<String>()
          : null,
      title: map['title'] != null ? map['title'] as String : null,
      voivodeship: map['voivodeship'] != null
          ? Voivodeship.values.byName(map['voivodeship'])
          : null,
      sortBy: map['sortBy'] != null
          ? SortingMethod.values.byName(map['sortBy'])
          : SortingMethod.newest,
    );
  }

  String toJson() => json.encode(toMap());

  factory HouseFilterQuery.fromJson(String source) =>
      HouseFilterQuery.fromMap(json.decode(source) as Map<String, dynamic>);
}
