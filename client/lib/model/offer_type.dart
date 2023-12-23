import 'package:json_annotation/json_annotation.dart';

enum OfferType {
  rent,
  sell;

  @override
  toString() => name;
}

extension OfferTypeEx on OfferType {
  String get name {
    switch (this) {
      case OfferType.rent:
        return "Wynajem";
      case OfferType.sell:
        return "Sprzedaż";
    }
  }
}

class OfferTypeConverter implements JsonConverter<OfferType, int> {
  const OfferTypeConverter();

  @override
  OfferType fromJson(int json) {
    return OfferType.values[json];
  }

  @override
  int toJson(OfferType? object) {
    if (object == null) {
      return 0;
    }

    return object.index;
  }
}
