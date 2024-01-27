import 'package:bloc_test/bloc_test.dart';
import 'package:ccquarters/profile/cubit.dart';
import 'package:ccquarters/profile/states.dart';
import 'package:ccquarters/services/houses/service.dart';
import 'package:ccquarters/services/users/service.dart';
import 'package:test/test.dart';

import 'mocks/houses_api_mock.dart';
import 'mocks/mock_data.dart';
import 'mocks/users_api_mock.dart';

const url = "http://ccquarters.com";

void main() {
  profileCubit();
}

void profileCubit() {
  group('ProfileCubit', () {
    blocTest<ProfilePageCubit, ProfilePageState>(
      'emits ProfilePageInitialState when setUser is called',
      build: () => ProfilePageCubit(
        houseService: HouseService(
          HousesAPIMock.createHousesApiMock("$url/houses"),
          "$url/houses",
        ),
        userService: UserService(
          UsersAPIMock.createUsersApiMock("$url/users"),
          "$url/users",
        ),
        userId: null,
      ),
      act: (cubit) => cubit.setUser(mockId),
      expect: () => [isA<ProfilePageInitialState>()],
    );

    blocTest<ProfilePageCubit, ProfilePageState>(
      'emits SendingDataState and ProfilePageInitialState when updateUser is called',
      build: () => ProfilePageCubit(
        houseService: HouseService(
          HousesAPIMock.createHousesApiMock("$url/houses"),
          "$url/houses",
        ),
        userService: UserService(
          UsersAPIMock.createUsersApiMock("$url/users"),
          "$url/users",
        ),
        userId: null,
      ),
      act: (cubit) => cubit.updateUser(mockUser, null, false),
      expect: () => [isA<SendingDataState>(), isA<ProfilePageInitialState>()],
    );

    blocTest<ProfilePageCubit, ProfilePageState>(
      'emits EditProfileState when goToEditUserPage is called',
      build: () => ProfilePageCubit(
        houseService: HouseService(
          HousesAPIMock.createHousesApiMock("$url/houses"),
          "$url/houses",
        ),
        userService: UserService(
          UsersAPIMock.createUsersApiMock("$url/users"),
          "$url/users",
        ),
        userId: null,
      ),
      act: (cubit) => cubit.goToEditUserPage(),
      expect: () => [isA<EditProfileState>()],
    );

    blocTest<ProfilePageCubit, ProfilePageState>(
      'emits ProfilePageInitialState when goToProfilePage is called',
      build: () => ProfilePageCubit(
        houseService: HouseService(
          HousesAPIMock.createHousesApiMock("$url/houses"),
          "$url/houses",
        ),
        userService: UserService(
          UsersAPIMock.createUsersApiMock("$url/users"),
          "$url/users",
        ),
        userId: null,
      ),
      act: (cubit) => cubit.goToProfilePage(),
      expect: () => [isA<ProfilePageInitialState>()],
    );
  });
}
