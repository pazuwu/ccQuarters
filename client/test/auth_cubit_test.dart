import 'package:bloc_test/bloc_test.dart';
import 'package:ccquarters/login_register/cubit.dart';
import 'package:ccquarters/login_register/states.dart';
import 'package:ccquarters/model/users/user.dart';
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
      'emits LoadingState and SignedInState when skipRegisterAndLogin is called',
      build: () => AuthCubit(
        authService: AuthServiceMock(isSignedIn: false),
        userService: UserService(
          UsersAPIMock.createUsersApiMock("$url/users"),
          "$url/users",
        ),
      ),
      act: (cubit) => cubit.skipRegisterAndLogin(),
      expect: () => [
        isA<LoadingState>(),
        isA<SignedInState>(),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'emits LoadingState and SignedInState when register is called',
      build: () => AuthCubit(
        authService: AuthServiceMock(isSignedIn: false),
        userService: UserService(
          UsersAPIMock.createUsersApiMock("$url/users"),
          "$url/users",
        ),
      ),
      act: (cubit) => cubit.register(password: "password"),
      expect: () => [
        isA<LoadingState>(),
        isA<SignedInState>(),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'emits LoadingState and SignedInState when signIn is called',
      build: () => AuthCubit(
        authService: AuthServiceMock(isSignedIn: false),
        userService: UserService(
          UsersAPIMock.createUsersApiMock("$url/users"),
          "$url/users",
        ),
      ),
      act: (cubit) => cubit.signIn(password: "password"),
      expect: () => [
        isA<LoadingState>(),
        isA<SignedInState>(),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'emits LoadingState and ForgotPasswordSuccessState when resetPassword is called',
      build: () => AuthCubit(
        authService: AuthServiceMock(isSignedIn: false),
        userService: UserService(
          UsersAPIMock.createUsersApiMock("$url/users"),
          "$url/users",
        ),
      ),
      act: (cubit) => cubit.resetPassword("jan.kowalski@gmail.com"),
      expect: () => [
        isA<LoadingState>(),
        isA<ForgotPasswordSuccessState>(),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'emits LoadingState when reEnterUserData is called',
      build: () => AuthCubit(
        authService: AuthServiceMock(isSignedIn: false),
        userService: UserService(
          UsersAPIMock.createUsersApiMock("$url/users"),
          "$url/users",
        ),
      ),
      act: (cubit) => cubit.reEnterUserData(User.empty(), null),
      expect: () => [
        isA<LoadingState>(),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'emits SignedInState when udpateUser is called',
      build: () => AuthCubit(
        authService: AuthServiceMock(isSignedIn: false),
        userService: UserService(
          UsersAPIMock.createUsersApiMock("$url/users"),
          "$url/users",
        ),
      ),
      act: (cubit) => cubit.updateUser(),
      expect: () => [
        isA<SignedInState>(),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'emits SignedInState when setUser is called',
      build: () => AuthCubit(
        authService: AuthServiceMock(isSignedIn: false),
        userService: UserService(
          UsersAPIMock.createUsersApiMock("$url/users"),
          "$url/users",
        ),
      ),
      act: (cubit) => cubit.setUser(),
      expect: () => [
        isA<SignedInState>(),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'emits ReEnterUserDataState when clearMessageForReEnterUserDataState is called',
      build: () => AuthCubit(
        authService: AuthServiceMock(isSignedIn: false),
        userService: UserService(
          UsersAPIMock.createUsersApiMock("$url/users"),
          "$url/users",
        ),
      ),
      act: (cubit) =>
          cubit.clearMessageForReEnterUserDataState(User.empty(), null),
      expect: () => [
        isA<ReEnterUserDataState>(),
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

    blocTest<AuthCubit, AuthState>(
      'emits ForgotPasswordState when goToForgotPasswordPage is called',
      build: () => AuthCubit(
        authService: AuthServiceMock(isSignedIn: false),
        userService: UserService(
          UsersAPIMock.createUsersApiMock("$url/users"),
          "$url/users",
        ),
      ),
      act: (cubit) => cubit.goToForgotPasswordPage("jan.kowalski@gmail.com"),
      expect: () => [
        isA<ForgotPasswordState>(),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'emits ReEnterUserDataState when goToReEnterUserDataPage is called',
      build: () => AuthCubit(
        authService: AuthServiceMock(isSignedIn: false),
        userService: UserService(
          UsersAPIMock.createUsersApiMock("$url/users"),
          "$url/users",
        ),
      ),
      act: (cubit) => cubit.goToReEnterUserDataPage(),
      expect: () => [
        isA<ReEnterUserDataState>(),
      ],
    );
  });
}
