import 'package:bloc_test/bloc_test.dart';
import 'package:ccquarters/login_register/cubit.dart';
import 'package:ccquarters/login_register/states.dart';
import 'package:ccquarters/services/alerts/service.dart';
import 'package:ccquarters/services/houses/service.dart';
import 'package:ccquarters/services/users/service.dart';
import 'package:ccquarters/virtual_tour/service/service.dart';
import 'package:test/test.dart';

import 'mocks/alerts_api_mock.dart';
import 'mocks/auth_service_mock.dart';
import 'mocks/houses_api_mock.dart';
import 'mocks/users_api_mock.dart';
import 'mocks/vt_api_mock.dart';

const url = "http://ccquarters.com";

void main() {
  authCubit();
}

void authCubit() {
  group('AuthCubit', () {
    blocTest<AuthCubit, AuthState>(
      'emits SigningInState and SignedInState when skipRegisterAndLogin is called',
      build: () => AuthCubit(
        authService: AuthServiceMock(isSignedIn: false),
        houseService: HouseService(
          HousesAPIMock.createHousesApiMock("$url/houses"),
          "$url/houses",
        ),
        vtService: VTService(VTAPIMock.createVTApiMock(url), url),
        userService: UserService(
          UsersAPIMock.createUsersApiMock("$url/users"),
          "$url/users",
        ),
        alertService: AlertService(
          AlertsAPIMock.createAlertsApiMock("$url/alerts"),
          "$url/alerts",
        ),
      ),
      act: (cubit) => cubit.skipRegisterAndLogin(),
      expect: () => [
        isA<SigningInState>(),
        isA<SignedInState>(),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'emits SigningInState and SignedInState when register is called',
      build: () => AuthCubit(
        authService: AuthServiceMock(isSignedIn: false),
        houseService: HouseService(
          HousesAPIMock.createHousesApiMock("$url/houses"),
          "$url/houses",
        ),
        vtService: VTService(VTAPIMock.createVTApiMock(url), url),
        userService: UserService(
          UsersAPIMock.createUsersApiMock("$url/users"),
          "$url/users",
        ),
        alertService: AlertService(
          AlertsAPIMock.createAlertsApiMock("$url/alerts"),
          "$url/alerts",
        ),
      ),
      act: (cubit) => cubit.register(password: "password"),
      expect: () => [
        isA<SigningInState>(),
        isA<SignedInState>(),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'emits SigningInState and SignedInState when signIn is called',
      build: () => AuthCubit(
        authService: AuthServiceMock(isSignedIn: false),
        houseService: HouseService(
          HousesAPIMock.createHousesApiMock("$url/houses"),
          "$url/houses",
        ),
        vtService: VTService(VTAPIMock.createVTApiMock(url), url),
        userService: UserService(
          UsersAPIMock.createUsersApiMock("$url/users"),
          "$url/users",
        ),
        alertService: AlertService(
          AlertsAPIMock.createAlertsApiMock("$url/alerts"),
          "$url/alerts",
        ),
      ),
      act: (cubit) => cubit.signIn(password: "password"),
      expect: () => [
        isA<SigningInState>(),
        isA<SignedInState>(),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'emits NeedsSigningInState when signOut is called',
      build: () => AuthCubit(
        authService: AuthServiceMock(isSignedIn: true),
        houseService: HouseService(
          HousesAPIMock.createHousesApiMock("$url/houses"),
          "$url/houses",
        ),
        vtService: VTService(VTAPIMock.createVTApiMock(url), url),
        userService: UserService(
          UsersAPIMock.createUsersApiMock("$url/users"),
          "$url/users",
        ),
        alertService: AlertService(
          AlertsAPIMock.createAlertsApiMock("$url/alerts"),
          "$url/alerts",
        ),
      ),
      act: (cubit) => cubit.signOut(),
      expect: () => [
        isA<NeedsSigningInState>(),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'emits LoginState when goToLoginPage is called',
      build: () => AuthCubit(
        authService: AuthServiceMock(isSignedIn: false),
        houseService: HouseService(
          HousesAPIMock.createHousesApiMock("$url/houses"),
          "$url/houses",
        ),
        vtService: VTService(VTAPIMock.createVTApiMock(url), url),
        userService: UserService(
          UsersAPIMock.createUsersApiMock("$url/users"),
          "$url/users",
        ),
        alertService: AlertService(
          AlertsAPIMock.createAlertsApiMock("$url/alerts"),
          "$url/alerts",
        ),
      ),
      act: (cubit) => cubit.goToLoginPage(),
      expect: () => [
        isA<LoginState>(),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'emits PersonalInfoRegisterState when goToPersonalInfoRegisterPage is called',
      build: () => AuthCubit(
        authService: AuthServiceMock(isSignedIn: false),
        houseService: HouseService(
          HousesAPIMock.createHousesApiMock("$url/houses"),
          "$url/houses",
        ),
        vtService: VTService(VTAPIMock.createVTApiMock(url), url),
        userService: UserService(
          UsersAPIMock.createUsersApiMock("$url/users"),
          "$url/users",
        ),
        alertService: AlertService(
          AlertsAPIMock.createAlertsApiMock("$url/alerts"),
          "$url/alerts",
        ),
      ),
      act: (cubit) => cubit.goToPersonalInfoRegisterPage(),
      expect: () => [
        isA<PersonalInfoRegisterState>(),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'emits RegisterState when goToEmailAndPasswordRegisterPage is called',
      build: () => AuthCubit(
        authService: AuthServiceMock(isSignedIn: false),
        houseService: HouseService(
          HousesAPIMock.createHousesApiMock("$url/houses"),
          "$url/houses",
        ),
        vtService: VTService(VTAPIMock.createVTApiMock(url), url),
        userService: UserService(
          UsersAPIMock.createUsersApiMock("$url/users"),
          "$url/users",
        ),
        alertService: AlertService(
          AlertsAPIMock.createAlertsApiMock("$url/alerts"),
          "$url/alerts",
        ),
      ),
      act: (cubit) => cubit.goToEmailAndPasswordRegisterPage(),
      expect: () => [
        isA<RegisterState>(),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'emits NeedsSigningInState when goToStartPage is called',
      build: () => AuthCubit(
        authService: AuthServiceMock(isSignedIn: false),
        houseService: HouseService(
          HousesAPIMock.createHousesApiMock("$url/houses"),
          "$url/houses",
        ),
        vtService: VTService(VTAPIMock.createVTApiMock(url), url),
        userService: UserService(
          UsersAPIMock.createUsersApiMock("$url/users"),
          "$url/users",
        ),
        alertService: AlertService(
          AlertsAPIMock.createAlertsApiMock("$url/alerts"),
          "$url/alerts",
        ),
      ),
      act: (cubit) => cubit.goToStartPage(),
      expect: () => [
        isA<NeedsSigningInState>(),
      ],
    );
  });
}
