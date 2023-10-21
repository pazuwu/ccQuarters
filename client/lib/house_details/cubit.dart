import 'package:ccquarters/model/house.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HouseDetailsState {}

class DetailsState extends HouseDetailsState {
  DetailsState(this.house);

  final House house;
}

class HouseDetailsCubit extends Cubit<HouseDetailsState> {
  HouseDetailsCubit(this.house) : super(DetailsState(house));

  House house;
}
