import 'package:ccquarters/model/houses/filter.dart';
import 'package:ccquarters/model/houses/house.dart';
import 'package:ccquarters/model/alerts/new_alert.dart';
import 'package:ccquarters/model/houses/offer_type.dart';
import 'package:ccquarters/services/alerts/service.dart';
import 'package:ccquarters/services/houses/service.dart';
import 'package:ccquarters/services/service_response.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListOfHousesState {}

class ErrorState extends ListOfHousesState {
  ErrorState({required this.message});

  String message;
}

class SuccessState extends ListOfHousesState {
  SuccessState({required this.message});

  String message;
}

class LoadingState extends ListOfHousesState {
  LoadingState({required this.message});
  String message;
}

class ListOfHousesCubit extends Cubit<ListOfHousesState> {
  ListOfHousesCubit({
    required this.houseService,
    required this.alertService,
    OfferType? offerType,
    HouseFilter? filter,
  })  : filter = filter ?? HouseFilter(),
        super(ListOfHousesState());

  HouseService houseService;
  AlertService alertService;
  HouseFilter filter;

  void saveFilter(HouseFilter filter) {
    this.filter = filter;
  }

  void saveSearch(String search) {
    filter.title = search;
  }

  Future<List<House>> getHouses(int pageNumber, int pageCount) async {
    final response = await houseService.getHouses(
      pageNumber: pageNumber,
      pageCount: pageCount,
      filter: filter,
    );

    if (response.error != ErrorType.none) {
      return [];
    }

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

  Future<void> createAlert(HouseFilter filter) async {
    emit(LoadingState(message: "Wysyłanie alertu..."));

    var alert = NewAlert.fromHouseFilter(filter);
    final response = await alertService.createAlert(alert);

    if (response.error != ErrorType.none) {
      emit(ErrorState(
          message: "Nie udało się wysłać alertu.\n"
              "Spróbuj ponownie później."));
      return;
    } else {
      emit(
        SuccessState(
            message: "Alert został wysłany. Otrzymasz powiadomienie,\n"
                "gdy pojawi się nowa oferta spełniająca kryteria."),
      );
    }
  }
}
