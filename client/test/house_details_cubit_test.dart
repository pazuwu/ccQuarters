import 'package:bloc_test/bloc_test.dart';
import 'package:ccquarters/house_details/cubit.dart';
import 'package:ccquarters/house_details/states.dart';
import 'package:ccquarters/services/houses/service.dart';
import 'package:test/test.dart';

import 'mocks/houses_api_mock.dart';
import 'mocks/mock_data.dart';

const url = "http://ccquarters.com";

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
        DetailsState(mockDetailedHouse),
      ),
      act: (cubit) => cubit.loadHouseDetails(),
      expect: () => [isA<LoadingState>(), isA<DetailsState>()],
    );

    blocTest<HouseDetailsCubit, HouseDetailsState>(
      'emits DetailsState when goBackToHouseDetails is called',
      build: () => HouseDetailsCubit(
        "cb849fa2-1033-4d6b-7c88-08db36d6f10f",
        HouseService(
          HousesAPIMock.createHousesApiMock("$url/houses"),
          "$url/houses",
        ),
        DetailsState(mockDetailedHouse),
      ),
      act: (cubit) => cubit.goBackToHouseDetails(),
      expect: () => [isA<DetailsState>()],
    );

    blocTest<HouseDetailsCubit, HouseDetailsState>(
      'emits EditHouseState when goToEditHouse is called',
      build: () => HouseDetailsCubit(
        "cb849fa2-1033-4d6b-7c88-08db36d6f10f",
        HouseService(
          HousesAPIMock.createHousesApiMock("$url/houses"),
          "$url/houses",
        ),
        DetailsState(mockDetailedHouse),
      ),
      act: (cubit) => cubit.goToEditHouse(),
      expect: () => [isA<EditHouseState>()],
    );
  });
}
