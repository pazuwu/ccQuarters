
enum OfferType {
  rent,
  sale;

  @override
  toString() => name;
}

extension OfferTypeEx on OfferType {
  String get name {
    switch (this) {
      case OfferType.rent:
        return "Wynajem";
      case OfferType.sale:
        return "Sprzedaż";
    }
  }
}