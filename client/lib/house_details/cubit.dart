import 'package:ccquarters/model/house.dart';
import 'package:ccquarters/services/houses/service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HouseDetailsState {}

class LoadingState extends HouseDetailsState {}

class ErrorState extends HouseDetailsState {}

class DetailsState extends HouseDetailsState {
  DetailsState(this.house);

  final House house;
}

class HouseDetailsCubit extends Cubit<HouseDetailsState> {
  HouseDetailsCubit(
    this.houseId,
    this.houseService,
  ) : super(LoadingState()) {
    loadHouseDetails();
  }

  String houseId;
  HouseService houseService;
  late House house;

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
