import 'package:bloc_test/bloc_test.dart';
import 'package:ccquarters/login_register/cubit.dart';
import 'package:ccquarters/login_register/states.dart';
import 'package:ccquarters/services/users/service.dart';
import 'package:test/test.dart';

import 'mocks/auth_service_mock.dart';
import 'mocks/users_api_mock.dart';

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
        userService: UserService(
          UsersAPIMock.createUsersApiMock("$url/users"),
          "$url/users",
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
        userService: UserService(
          UsersAPIMock.createUsersApiMock("$url/users"),
          "$url/users",
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
        userService: UserService(
          UsersAPIMock.createUsersApiMock("$url/users"),
          "$url/users",
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
        userService: UserService(
          UsersAPIMock.createUsersApiMock("$url/users"),
          "$url/users",
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
        userService: UserService(
          UsersAPIMock.createUsersApiMock("$url/users"),
          "$url/users",
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
        userService: UserService(
          UsersAPIMock.createUsersApiMock("$url/users"),
          "$url/users",
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
        userService: UserService(
          UsersAPIMock.createUsersApiMock("$url/users"),
          "$url/users",
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
        userService: UserService(
          UsersAPIMock.createUsersApiMock("$url/users"),
          "$url/users",
        ),
      ),
      act: (cubit) => cubit.goToStartPage(),
      expect: () => [
        isA<NeedsSigningInState>(),
      ],
    );
  });
}
