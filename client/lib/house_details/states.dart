import 'package:ccquarters/model/detailed_house.dart';

class HouseDetailsState {}

class LoadingState extends HouseDetailsState {}

class ErrorState extends HouseDetailsState {
  ErrorState({required this.message});

  final String message;
}

class DetailsState extends HouseDetailsState {
  DetailsState(this.house);

  final DetailedHouse house;
}

class EditHouseState extends HouseDetailsState {
  EditHouseState(this.house);

  final DetailedHouse house;
}