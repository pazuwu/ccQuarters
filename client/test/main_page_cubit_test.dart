import 'package:bloc_test/bloc_test.dart';
import 'package:ccquarters/main_page/cubit.dart';
import 'package:ccquarters/services/houses/service.dart';
import 'package:test/test.dart';

import 'mocks/houses_api_mock.dart';

const url = "http://ccquarters.com";

void main() {
  mainPageCubit();
}

void mainPageCubit() {
  group('MainPageCubit', () {
    blocTest<MainPageCubit, MainPageState>(
      'emits MainPageInitialState when goBack is called',
      build: () => MainPageCubit(
        HouseService(
          HousesAPIMock.createHousesApiMock("$url/houses"),
          "$url/houses",
        ),
      ),
      act: (cubit) => cubit.goBack(),
      expect: () => [isA<MainPageInitialState>()],
    );
  });
}
