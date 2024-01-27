import 'package:ccquarters/house_details/states.dart';
import 'package:ccquarters/model/houses/detailed_house.dart';
import 'package:ccquarters/services/houses/service.dart';
import 'package:ccquarters/services/service_response.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HouseDetailsCubit extends Cubit<HouseDetailsState> {
  HouseDetailsCubit(this.houseId, this.houseService, initialState)
      : super(initialState) {
    if (initialState is LoadingState) {
      loadHouseDetails();
    } else {
      house = (initialState as DetailsState).house;
    }
  }

  String houseId;
  HouseService houseService;
  late DetailedHouse house;

  Future<void> loadHouseDetails() async {
    emit(LoadingState());
    var response = await houseService.getHouse(houseId);
    if (response.data == null) {
      emit(ErrorState(
          message: "Wystąpił błąd podczas próby\n pobrania ogłoszenia",
          tip: "Spróbuj ponownie później"));
    } else {
      house = response.data!;
      emit(DetailsState(house));
    }
  }

  Future<bool> deleteHouse() async {
    var response = await houseService.deleteHouse(houseId);
    return response.data;
  }

  Future<bool> likeHouse(String houseId, bool isLiked) async {
    ServiceResponse<bool> response;
    if (isLiked) {
      response = await houseService.unlikeHouse(houseId);
    } else {
      response = await houseService.likeHouse(houseId);
    }

    if (response.error != ErrorType.none) {
      return isLiked;
    }

    return !isLiked;
  }

  Future<void> goBackToHouseDetails() async {
    emit(DetailsState(house));
  }

  Future<void> goToEditHouse() async {
    emit(EditHouseState(house));
  }
}
