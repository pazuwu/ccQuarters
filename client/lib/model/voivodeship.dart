enum Voivodeship {
  dolnoslaskie,
  kujawskoPomorskie,
  lubelskie,
  lubuskie,
  lodzkie,
  malopolskie,
  mazowieckie,
  opolskie,
  podkarpackie,
  podlaskie,
  pomorskie,
  slaskie,
  swietokrzyskie,
  warminskoMazurskie,
  wielkopolskie,
  zachodniopomorskie;

  @override
  toString() => name;
}

extension VoivodeshipEx on Voivodeship {
  String get name {
    switch (this) {
      case Voivodeship.dolnoslaskie:
        return "Dolnośląskie";
      case Voivodeship.kujawskoPomorskie:
        return "Kujawsko-Pomorskie";
      case Voivodeship.lubelskie:
        return "Lubelskie";
      case Voivodeship.lubuskie:
        return "Lubuskie";
      case Voivodeship.lodzkie:
        return "Łódzkie";
      case Voivodeship.malopolskie:
        return "Małopolskie";
      case Voivodeship.mazowieckie:
        return "Mazowieckie";
      case Voivodeship.opolskie:
        return "Opolskie";
      case Voivodeship.podkarpackie:
        return "Podkarpackie";
      case Voivodeship.podlaskie:
        return "Podlaskie";
      case Voivodeship.pomorskie:
        return "Pomorskie";
      case Voivodeship.slaskie:
        return "Śląskie";
      case Voivodeship.swietokrzyskie:
        return "Świętokrzyskie";
      case Voivodeship.warminskoMazurskie:
        return "Warmińsko-Mazurskie";
      case Voivodeship.wielkopolskie:
        return "Wielkopolskie";
      case Voivodeship.zachodniopomorskie:
        return "Zachodniopomorskie";
    }
  }
}
