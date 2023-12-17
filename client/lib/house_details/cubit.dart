import 'package:ccquarters/house_details/states.dart';
import 'package:ccquarters/model/detailed_house.dart';
import 'package:ccquarters/services/houses/service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      emit(ErrorState(
          message:
              "Nie udało się pobrać ogłoszenia. Spróbuj ponownie później!"));
    } else {
      house = response.data!;
      emit(DetailsState(house));
    }
  }

  Future<bool> deleteHouse() async {
    var response = await houseService.deleteHouse(houseId);
    return response.data;
  }

  Future<void> goBackToHouseDetails() async {
    emit(DetailsState(house));
  }

  Future<void> goToEditHouse() async {
    emit(EditHouseState(house));
  }
}
