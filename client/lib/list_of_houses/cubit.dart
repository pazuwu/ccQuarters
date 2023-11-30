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

  Future<List<House>> getHouses(int pageNumber, int pageCount) async {
    final response = await houseService.getHouses(
      pageNumber: pageNumber,
      pageCount: pageCount,
    );

    if (response.error != ErrorType.none) {
      return [];
    }

    return response.data;
  }
}
