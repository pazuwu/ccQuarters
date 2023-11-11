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
}