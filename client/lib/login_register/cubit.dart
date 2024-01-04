import 'package:ccquarters/model/user/user.dart';
import 'package:ccquarters/services/auth/reset_password_result.dart';
import 'package:ccquarters/services/auth/service.dart';
import 'package:ccquarters/services/auth/sign_in_result.dart';
import 'package:ccquarters/services/auth/sign_up_result.dart';
import 'package:ccquarters/services/service_response.dart';
import 'package:ccquarters/services/users/service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'states.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required this.authService,
    required this.userService,
  }) : super(kIsWeb || authService.isSignedIn
            ? LoadingState()
            : NeedsSigningInState()) {
    if (authService.isSignedIn) {
      setUser();
    } else {
      if (kIsWeb) {
        skipRegisterAndLogin();
      } else {
        user = User.empty();
      }
    }
  }

  BaseAuthService authService;
  UserService userService;

  User? user;
  bool isBusinessAccount = false;

  Future<void> skipRegisterAndLogin() async {
    emit(LoadingState());
    user = null;
    await authService.signInAnnonymously();
    emit(SignedInState());
  }

  Future<void> register({
    required String password,
  }) async {
    emit(LoadingState());
    if (user == null) {
      user = User.empty();
      emit(InputDataState(user: user!));
      return;
    }
    final registerState = RegisterState(user: user, password: password);
    if (!kIsWeb && !await InternetConnectionChecker().hasConnection) {
      emit(registerState..error = "Brak Internetu!");
      return;
    }

    try {
      final result = await authService.signUp(user!.email, password);

      switch (result) {
        case SignUpResult.success:
          await userService.updateUser(authService.currentUserId!, user!);
          emit(SignedInState());
          break;
        default:
          emit(registerState..error = result.toString());
          break;
      }
    } catch (e) {
      emit(registerState
        ..error = 'Wystąpił niespodziewany błąd. Spróbuj ponownie później');
    }
  }

  Future<void> signIn({
    required String password,
  }) async {
    emit(LoadingState());
    if (user == null) {
      user = User.empty();
      emit(InputDataState(user: user!));
      return;
    }
    final loginState = LoginState(user: user, password: password);
    if (!kIsWeb && !await InternetConnectionChecker().hasConnection) {
      emit(loginState..error = "Brak Internetu!");
      return;
    }

    try {
      final result = await authService.signInWithEmail(user!.email, password);
      switch (result) {
        case SignInResult.success:
          await setUser();
          break;
        default:
          emit(loginState..error = result.toString());
          break;
      }
    } catch (e) {
      emit(loginState..error = 'Nieoczekiwany błąd');
    }
  }

  Future<void> resetPassword(String email) async {
    emit(LoadingState());
    email = email.trim();
    if (!kIsWeb && !await InternetConnectionChecker().hasConnection) {
      emit(ForgotPasswordState(email: email, error: "Brak Internetu!"));
      return;
    }

    saveEmail(email);
    var result = await authService.sendPasswordResetEmail(email);
    if (result == ResetPasswordResult.success) {
      emit(ForgotPasswordSuccessState());
    } else {
      emit(ForgotPasswordState(email: email, error: result.toString()));
    }
  }

  Future<void> setUser() async {
    user = await getUser(authService.currentUserId!);
    emit(SignedInState());
  }

  Future<User?> getUser(String userId) async {
    final response = await userService.getUser(userId);
    if (response.error != ErrorType.none) {
      return null;
    }
    return response.data;
  }

  void savePersonalInfo(
      String company, String name, String surname, String phoneNumber) {
    user ??= User.empty();
    user!.company = company;
    user!.name = name;
    user!.surname = surname;
    user!.phoneNumber = phoneNumber;
  }

  void saveEmail(String email) {
    user ??= User.empty();
    email = email.trim();
    user!.email = email;
  }

  Future<void> signOut() async {
    await authService.signOut();

    user = User.empty();
    emit(NeedsSigningInState());
  }

  Future<void> goToLoginPage() async {
    emit(LoginState(user: user));
  }

  Future<void> goToPersonalInfoRegisterPage() async {
    emit(PersonalInfoRegisterState(user: user));
  }

  Future<void> goToEmailAndPasswordRegisterPage() async {
    emit(RegisterState(user: user));
  }

  Future<void> goToStartPage() async {
    emit(NeedsSigningInState());
  }

  Future<void> goToForgotPasswordPage(String email) async {
    emit(ForgotPasswordState(email: email));
  }
}
