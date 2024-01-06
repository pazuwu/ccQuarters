import 'package:ccquarters/model/houses/detailed_house.dart';

class HouseDetailsState {}

class LoadingState extends HouseDetailsState {}

class ErrorState extends HouseDetailsState {
  ErrorState({required this.message, this.tip});

  final String message;
  String? tip;
}

class DetailsState extends HouseDetailsState {
  DetailsState(this.house);

  final DetailedHouse house;
}

class EditHouseState extends HouseDetailsState {
  EditHouseState(this.house);

  final DetailedHouse house;
}
