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

  static Voivodeship getFromName(String name) {
    switch (name) {
      case "Dolnośląskie":
        return Voivodeship.dolnoslaskie;
      case "Kujawsko-Pomorskie":
        return Voivodeship.kujawskoPomorskie;
      case "Lubelskie":
        return Voivodeship.lubelskie;
      case "Lubuskie":
        return Voivodeship.lubuskie;
      case "Łódzkie":
        return Voivodeship.lodzkie;
      case "Małopolskie":
        return Voivodeship.malopolskie;
      case "Mazowieckie":
        return Voivodeship.mazowieckie;
      case "Opolskie":
        return Voivodeship.opolskie;
      case "Podkarpackie":
        return Voivodeship.podkarpackie;
      case "Podlaskie":
        return Voivodeship.podlaskie;
      case "Pomorskie":
        return Voivodeship.pomorskie;
      case "Śląskie":
        return Voivodeship.slaskie;
      case "Świętokrzyskie":
        return Voivodeship.swietokrzyskie;
      case "Warmińsko-Mazurskie":
        return Voivodeship.warminskoMazurskie;
      case "Wielkopolskie":
        return Voivodeship.wielkopolskie;
      case "Zachodniopomorskie":
        return Voivodeship.zachodniopomorskie;
      default:
        return Voivodeship.dolnoslaskie;
    }
  }
}
