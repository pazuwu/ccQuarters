import 'package:bloc_test/bloc_test.dart';
import 'package:ccquarters/add_house/cubit.dart';
import 'package:ccquarters/add_house/states.dart';
import 'package:ccquarters/model/houses/building_type.dart';
import 'package:ccquarters/model/houses/new_house.dart';
import 'package:ccquarters/services/houses/service.dart';
import 'package:ccquarters/services/virtual_tours/service.dart';
import 'package:test/test.dart';

import 'mocks/file_service_mock.dart';
import 'mocks/houses_api_mock.dart';
import 'mocks/mock_data.dart';
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
          FileServiceMock(),
          url,
        ),
      ),
      act: (cubit) => cubit.goToChooseTypeForm(),
      expect: () => [isA<ChooseTypeFormState>()],
    );

    blocTest<AddHouseFormCubit, HouseFormState>(
      'emits PortraitDetailsFormState when goToDetailsForm is called',
      build: () => AddHouseFormCubit(
        houseService: HouseService(
          HousesAPIMock.createHousesApiMock("$url/houses"),
          "$url/houses",
        ),
        vtService: VTService(
          VTAPIMock.createVTApiMock(url),
          FileServiceMock(),
          url,
        ),
      ),
      act: (cubit) => cubit.goToDetailsForm(),
      expect: () => [isA<PortraitDetailsFormState>()],
    );

    blocTest<AddHouseFormCubit, HouseFormState>(
      'emits LocationFormState when goToLocationForm is called',
      build: () => AddHouseFormCubit(
        houseService: HouseService(
          HousesAPIMock.createHousesApiMock("$url/houses"),
          "$url/houses",
        ),
        vtService: VTService(
          VTAPIMock.createVTApiMock(url),
          FileServiceMock(),
          url,
        ),
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
        vtService: VTService(
          VTAPIMock.createVTApiMock(url),
          FileServiceMock(),
          url,
        ),
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
        vtService: VTService(
          VTAPIMock.createVTApiMock(url),
          FileServiceMock(),
          url,
        ),
      ),
      act: (cubit) => cubit.goToPhotosForm(),
      expect: () => [isA<PhotosFormState>()],
    );

    blocTest<AddHouseFormCubit, HouseFormState>(
      'emits VirtualTourFormState when goToVirtualTourForm is called',
      build: () => AddHouseFormCubit(
        houseService: HouseService(
          HousesAPIMock.createHousesApiMock("$url/houses"),
          "$url/houses",
        ),
        vtService: VTService(
          VTAPIMock.createVTApiMock(url),
          FileServiceMock(),
          url,
        ),
      ),
      act: (cubit) => cubit.goToVirtualTourForm(),
      expect: () => [isA<VirtualTourFormState>()],
    );

    blocTest<AddHouseFormCubit, HouseFormState>(
      'emits SendingDataState and SendingFinishedState when sendData is called',
      build: () => AddHouseFormCubit(
        houseService: HouseService(
          HousesAPIMock.createHousesApiMock("$url/houses"),
          "$url/houses",
        ),
        vtService: VTService(
          VTAPIMock.createVTApiMock(url),
          FileServiceMock(),
          url,
        ),
      ),
      act: (cubit) => cubit.sendData(),
      expect: () => [isA<SendingDataState>(), isA<SendingFinishedState>()],
    );

    blocTest<AddHouseFormCubit, HouseFormState>(
      'emits SendingDataState and SendingFinishedState when updateHouse is called',
      build: () => AddHouseFormCubit(
        houseService: HouseService(
          HousesAPIMock.createHousesApiMock("$url/houses"),
          "$url/houses",
        ),
        vtService: VTService(
          VTAPIMock.createVTApiMock(url),
          FileServiceMock(),
          url,
        ),
        house: NewHouse.fromDetailedHouse(mockDetailedHouse),
      ),
      act: (cubit) => cubit.updateHouse(),
      expect: () => [isA<SendingDataState>(), isA<SendingFinishedState>()],
    );

    blocTest<AddHouseFormCubit, HouseFormState>(
      'emits ChooseTypeFormState when clear is called',
      build: () => AddHouseFormCubit(
        houseService: HouseService(
          HousesAPIMock.createHousesApiMock("$url/houses"),
          "$url/houses",
        ),
        vtService: VTService(
          VTAPIMock.createVTApiMock(url),
          FileServiceMock(),
          url,
        ),
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
        vtService: VTService(
          VTAPIMock.createVTApiMock(url),
          FileServiceMock(),
          url,
        ),
      ),
      act: (cubit) => cubit.saveBuildingType(BuildingType.apartment),
      expect: () => [isA<ChooseTypeFormState>()],
    );
  });
}
