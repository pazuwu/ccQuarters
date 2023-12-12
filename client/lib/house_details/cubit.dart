import 'package:ccquarters/model/detailed_house.dart';
import 'package:ccquarters/services/houses/service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HouseDetailsState {}

class LoadingState extends HouseDetailsState {}

class ErrorState extends HouseDetailsState {}

class DetailsState extends HouseDetailsState {
  DetailsState(this.house);

  final DetailedHouse house;
}

class HouseDetailsCubit extends Cubit<HouseDetailsState> {
  HouseDetailsCubit(
    this.houseId,
    this.houseService,
    initialState,
  ) : super(initialState) {
    if (initialState is LoadingState) {
      loadHouseDetails();
    }
  }

  String houseId;
  HouseService houseService;
  late DetailedHouse house;

  Future<void> loadHouseDetails() async {
    emit(LoadingState());
    var response = await houseService.getHouse(houseId);
    if (response.data == null) {
      emit(ErrorState());
    } else {
      house = response.data!;
      emit(DetailsState(house));
    }
  }
}
