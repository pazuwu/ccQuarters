import 'package:ccquarters/model/user.dart';
import 'package:ccquarters/services/auth/service.dart';
import 'package:ccquarters/services/auth/sign_in_result.dart';
import 'package:ccquarters/services/auth/sign_up_result.dart';
import 'package:ccquarters/services/users/service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({required this.authService, required this.userService})
      : super(kIsWeb ? SignedInState() : NeedsSigningInState()) {
    if (kIsWeb) {
      user = null;
      authService.signInAnnonymously();
      setTokens();
    } else {
      user = User();
    }
  }

  AuthService authService;
  UserService userService;
  User? user;

  void startLoggingIn() {
    if (state is NeedsSigningInState) emit(InputDataState(user: user!));
  }

  void startRegister() {
    emit(PersonalInfoRegisterState(user: user));
  }

  void skipRegisterAndLogin() {
    user = null;
    authService.signInAnnonymously();
    setTokens();
    emit(SignedInState());
  }

  Future<void> register({
    required String password,
  }) async {
    emit(SigningInState());
    if (user == null) {
      user = User();
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
          await setTokens();
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
    emit(SigningInState());
    if (user == null) {
      user = User();
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
          emit(SignedInState());
          break;
        default:
          emit(loginState..error = result.toString());
          break;
      }
    } catch (e) {
      emit(loginState..error = 'Nieoczekiwany błąd');
    }
  }

  void savePersonalInfo(
      String company, String name, String surname, String phoneNumber) {
    user ??= User();
    user!.company = company;
    user!.name = name;
    user!.surname = surname;
    user!.phoneNumber = phoneNumber;
  }

  void saveEmail(String email) {
    user ??= User();
    user!.email = email;
  }

  Future<void> signOut() async {
    await authService.signOut();
    user = User();
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

  setTokens() async {
    var token = await authService.getToken();
    if (token != null) {
      userService.setToken(token);
    }
  }
}
