import 'package:ccquarters/model/filter.dart';
import 'package:ccquarters/model/house.dart';
import 'package:ccquarters/services/houses/service.dart';
import 'package:ccquarters/services/service_response.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListOfHousesState {}

class ListOfHousesInitialState extends ListOfHousesState {}

class ListOfHousesCubit extends Cubit<ListOfHousesState> {
  ListOfHousesCubit({
    required this.houseService,
  }) : super(ListOfHousesInitialState());

  HouseService houseService;
  HouseFilter filter = HouseFilter();

  void saveFilter(HouseFilter filter) {
    this.filter = filter;
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
}
