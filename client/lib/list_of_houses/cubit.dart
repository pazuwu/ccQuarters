import 'package:ccquarters/model/houses/filter.dart';
import 'package:ccquarters/model/houses/house.dart';
import 'package:ccquarters/model/alerts/new_alert.dart';
import 'package:ccquarters/model/houses/offer_type.dart';
import 'package:ccquarters/services/alerts/service.dart';
import 'package:ccquarters/services/houses/service.dart';
import 'package:ccquarters/services/service_response.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListOfHousesState {}

class MessageState extends ListOfHousesState {
  MessageState({required this.message});

  String message;
}

class ErrorState extends MessageState {
  ErrorState({required super.message});
}

class SuccessState extends MessageState {
  SuccessState({required super.message});
}

class LoadingState extends MessageState {
  LoadingState({required super.message});
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

  void clearMessages() {
    emit(ListOfHousesState());
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

  Future<void> createAlertFromHouseFilter(HouseFilter filter) async {
    emit(LoadingState(message: "Wysyłanie alertu..."));

    var alert = NewAlert.fromHouseFilter(filter);
    final response = await alertService.createAlert(alert);

    if (response.error != ErrorType.none) {
      if (response.error == ErrorType.emptyRequest) {
        emit(ErrorState(message: "Nie można wysłać pustego alertu."));
      } else {
        emit(ErrorState(
            message: "Nie udało się wysłać alertu.\n"
                "Spróbuj ponownie później."));
      }
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
