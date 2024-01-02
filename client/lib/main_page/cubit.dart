import 'package:ccquarters/model/filter.dart';
import 'package:ccquarters/model/house.dart';
import 'package:ccquarters/model/offer_type.dart';
import 'package:ccquarters/services/houses/service.dart';
import 'package:ccquarters/services/service_response.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainPageState {}

class MainPageInitialState extends MainPageState {}

class MainPageCubit extends Cubit<MainPageState> {
  MainPageCubit(this.houseService) : super(MainPageInitialState());

  HouseService houseService;

  Future<List<House>?> getHousesToRent(int pageNumber, int pageCount) async {
    return _getHouses(pageNumber, pageCount, OfferType.rent);
  }

  Future<List<House>?> getHousesToBuy(int pageNumber, int pageCount) async {
    return _getHouses(pageNumber, pageCount, OfferType.sell);
  }

  Future<List<House>?> _getHouses(
      int pageNumber, int pageCount, OfferType offerType) async {
    final response = await houseService.getHouses(
      pageNumber: pageNumber,
      pageCount: pageCount,
      filter: HouseFilter(offerType: offerType),
    );

    if (response.error != ErrorType.none) {
      return null;
    }

    return response.data;
  }
}
