import 'package:bloc_test/bloc_test.dart';
import 'package:ccquarters/house_details/cubit.dart';
import 'package:ccquarters/services/houses/service.dart';
import 'package:test/test.dart';

import 'mocks/houses_api_mock.dart';

const url = "http://ccquarters.com";

class TestingState extends HouseDetailsState {}

void main() {
  houseDetailsCubit();
}

void houseDetailsCubit() {
  group('HouseDetailsCubit', () {
    blocTest<HouseDetailsCubit, HouseDetailsState>(
      'emits LoadingState and DetailsState when loadHouseDetails is called',
      build: () => HouseDetailsCubit(
        "cb849fa2-1033-4d6b-7c88-08db36d6f10f",
        HouseService(
          HousesAPIMock.createHousesApiMock("$url/houses"),
          "$url/houses",
        ),
        TestingState(),
      ),
      act: (cubit) => cubit.loadHouseDetails(),
      expect: () => [isA<LoadingState>(), isA<DetailsState>()],
    );
  });
}
