import 'package:bloc_test/bloc_test.dart';
import 'package:ccquarters/list_of_houses/cubit.dart';
import 'package:ccquarters/model/houses/building_type.dart';
import 'package:ccquarters/model/houses/filter.dart';
import 'package:ccquarters/services/alerts/service.dart';
import 'package:ccquarters/services/houses/service.dart';
import 'package:test/test.dart';

import 'mocks/alerts_api_mock.dart';
import 'mocks/houses_api_mock.dart';

const url = "http://ccquarters.com";

void main() {
  listOfHousesCubit();
}

void listOfHousesCubit() {
  group('ListOfHousesCubit', () {
    blocTest<ListOfHousesCubit, ListOfHousesState>(
      'emits ListOfHousesState when clearMessages is called',
      build: () => ListOfHousesCubit(
        houseService: HouseService(
          HousesAPIMock.createHousesApiMock("$url/houses"),
          "$url/houses",
        ),
        alertService: AlertService(
          AlertsAPIMock.createAlertsApiMock("$url/alerts"),
          "$url/alerts",
        ),
      ),
      act: (cubit) => cubit.clearMessages(),
      expect: () => [isA<ListOfHousesState>()],
    );

    blocTest<ListOfHousesCubit, ListOfHousesState>(
      'emits LoadingState and SuccessState when createAlert with not empty alert is called',
      build: () => ListOfHousesCubit(
        houseService: HouseService(
          HousesAPIMock.createHousesApiMock("$url/houses"),
          "$url/houses",
        ),
        alertService: AlertService(
          AlertsAPIMock.createAlertsApiMock("$url/alerts"),
          "$url/alerts",
        ),
      ),
      act: (cubit) => cubit.createAlertFromHouseFilter(
          HouseFilter(buildingType: BuildingType.apartment)),
      expect: () => [isA<LoadingState>(), isA<SuccessState>()],
    );

    blocTest<ListOfHousesCubit, ListOfHousesState>(
      'emits LoadingState and ErrorState when createAlert with empty alert is called',
      build: () => ListOfHousesCubit(
        houseService: HouseService(
          HousesAPIMock.createHousesApiMock("$url/houses"),
          "$url/houses",
        ),
        alertService: AlertService(
          AlertsAPIMock.createAlertsApiMock("$url/alerts"),
          "$url/alerts",
        ),
      ),
      act: (cubit) => cubit.createAlertFromHouseFilter(HouseFilter()),
      expect: () => [isA<LoadingState>(), isA<ErrorState>()],
    );
  });
}
