import 'package:bloc_test/bloc_test.dart';
import 'package:ccquarters/add_house/cubit.dart';
import 'package:ccquarters/model/building_type.dart';
import 'package:ccquarters/services/houses/service.dart';
import 'package:ccquarters/virtual_tour/service/service.dart';
import 'package:test/test.dart';

import 'mocks/houses_api_mock.dart';
import 'mocks/vt_api_mock.dart';

const url = "http://ccquarters.com";

void main() {
  addHouseFormCubit();
}

void addHouseFormCubit() {
  group('AddHouseFormCubit', () {
    blocTest<AddHouseFormCubit, HouseFormState>(
      'emits ChooseTypeFormState when goToChooseTypeForm is called',
      build: () => AddHouseFormCubit(
        houseService: HouseService(
          HousesAPIMock.createHousesApiMock("$url/houses"),
          "$url/houses",
        ),
        vtService: VTService(
          VTAPIMock.createVTApiMock(url),
          url,
        ),
      ),
      act: (cubit) => cubit.goToChooseTypeForm(),
      expect: () => [isA<ChooseTypeFormState>()],
    );

    blocTest<AddHouseFormCubit, HouseFormState>(
      'emits MobileDetailsFormState when goToDetailsForm is called',
      build: () => AddHouseFormCubit(
        houseService: HouseService(
          HousesAPIMock.createHousesApiMock("$url/houses"),
          "$url/houses",
        ),
        vtService: VTService(VTAPIMock.createVTApiMock(url), url),
      ),
      act: (cubit) => cubit.goToDetailsForm(),
      expect: () => [isA<MobileDetailsFormState>()],
    );

    blocTest<AddHouseFormCubit, HouseFormState>(
      'emits LocationFormState when goToLocationForm is called',
      build: () => AddHouseFormCubit(
        houseService: HouseService(
          HousesAPIMock.createHousesApiMock("$url/houses"),
          "$url/houses",
        ),
        vtService: VTService(VTAPIMock.createVTApiMock(url), url),
      ),
      act: (cubit) => cubit.goToLocationForm(),
      expect: () => [isA<LocationFormState>()],
    );

    blocTest<AddHouseFormCubit, HouseFormState>(
      'emits MapState when goToMap is called',
      build: () => AddHouseFormCubit(
        houseService: HouseService(
          HousesAPIMock.createHousesApiMock("$url/houses"),
          "$url/houses",
        ),
        vtService: VTService(VTAPIMock.createVTApiMock(url), url),
      ),
      act: (cubit) => cubit.goToMap(),
      expect: () => [isA<MapState>()],
    );

    blocTest<AddHouseFormCubit, HouseFormState>(
      'emits PhotosFormState when goToPhotosForm is called',
      build: () => AddHouseFormCubit(
        houseService: HouseService(
          HousesAPIMock.createHousesApiMock("$url/houses"),
          "$url/houses",
        ),
        vtService: VTService(VTAPIMock.createVTApiMock(url), url),
      ),
      act: (cubit) => cubit.goToPhotosForm(),
      expect: () => [isA<PhotosFormState>()],
    );

    blocTest<AddHouseFormCubit, HouseFormState>(
      'emits SendingDataState and SendingFinishedState when sendData is called',
      build: () => AddHouseFormCubit(
        houseService: HouseService(
          HousesAPIMock.createHousesApiMock("$url/houses"),
          "$url/houses",
        ),
        vtService: VTService(VTAPIMock.createVTApiMock(url), url),
      ),
      act: (cubit) => cubit.sendData(),
      expect: () => [isA<SendingDataState>(), isA<SendingFinishedState>()],
    );

    blocTest<AddHouseFormCubit, HouseFormState>(
      'emits ChooseTypeFormState when clear is called',
      build: () => AddHouseFormCubit(
        houseService: HouseService(
          HousesAPIMock.createHousesApiMock("$url/houses"),
          "$url/houses",
        ),
        vtService: VTService(VTAPIMock.createVTApiMock(url), url),
      ),
      act: (cubit) => cubit.clear(),
      expect: () => [isA<ChooseTypeFormState>()],
    );

    blocTest<AddHouseFormCubit, HouseFormState>(
      'emits ChooseTypeFormState when saveBuildingType is called',
      build: () => AddHouseFormCubit(
        houseService: HouseService(
          HousesAPIMock.createHousesApiMock("$url/houses"),
          "$url/houses",
        ),
        vtService: VTService(VTAPIMock.createVTApiMock(url), url),
      ),
      act: (cubit) => cubit.saveBuildingType(BuildingType.apartment),
      expect: () => [isA<ChooseTypeFormState>()],
    );
  });
}
