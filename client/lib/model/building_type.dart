import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

enum BuildingType {
  house,
  apartment,
  room;

  @override
  toString() => name;
}

extension BuildingTypeEx on BuildingType {
  String get name {
    switch (this) {
      case BuildingType.house:
        return "Dom";
      case BuildingType.apartment:
        return "Mieszkanie";
      case BuildingType.room:
        return "Pokój";
    }
  }

  IconData get icon {
    switch (this) {
      case BuildingType.house:
        return Icons.house;
      case BuildingType.apartment:
        return Icons.apartment;
      case BuildingType.room:
        return Icons.bed;
    }
  }
}

class BuildingTypeConverter implements JsonConverter<BuildingType, int> {
  const BuildingTypeConverter();

  @override
  BuildingType fromJson(int json) {
    return BuildingType.values[json];
  }

  @override
  int toJson(BuildingType? object) {
    if (object == null) {
      return 0;
    }

    return object.index;
  }
}
