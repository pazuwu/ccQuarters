import 'package:ccquarters/model/users/user.dart';
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
        _user = User.empty();
      }
    }
  }

  BaseAuthService authService;
  UserService userService;
  User? _user;
  bool isBusinessAccount = false;

  bool get isUserLoggedIn => authService.isSignedIn;
  String get currentUserId => authService.currentUserId!;

  Future<void> skipRegisterAndLogin() async {
    emit(LoadingState());
    _user = null;
    await authService.signInAnnonymously();
    emit(SignedInState());
  }

  Future<void> register({required String password}) async {
    emit(LoadingState());
    if (_user == null) {
      _user = User.empty();
      emit(InputDataState(user: _user!));
      return;
    }

    final registerState = RegisterState(user: _user, password: password);
    if (!kIsWeb && !await InternetConnectionChecker().hasConnection) {
      emit(registerState..error = "Brak Internetu!");
      return;
    }

    if (!isBusinessAccount) {
      _user!.company = null;
    }

    try {
      final result = await authService.signUp(_user!.email, password);

      switch (result) {
        case SignUpResult.success:
          await updateUser();
          break;
        default:
          emit(registerState..error = result.toString());
          break;
      }
    } catch (e) {
      emit(registerState
        ..error = 'Wystąpił niespodziewany błąd.\n Spróbuj ponownie później');
    }
  }

  Future<void> signIn({required String password}) async {
    emit(LoadingState());
    if (_user == null) {
      _user = User.empty();
      emit(InputDataState(user: _user!));
      return;
    }

    final loginState = LoginState(user: _user, password: password);
    if (!kIsWeb && !await InternetConnectionChecker().hasConnection) {
      emit(loginState..error = "Brak Internetu!");
      return;
    }

    try {
      final result = await authService.signInWithEmail(_user!.email, password);
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

  Future<void> reEnterUserData(User user, Uint8List? photo) async {
    emit(LoadingState());
    if (!kIsWeb && !await InternetConnectionChecker().hasConnection) {
      emit(ReEnterUserDataState(
        user: user,
        image: photo,
        error: "Brak Internetu!",
      ));
      return;
    }

    if ((!await _updateUser(user)) ||
        (photo != null && !await _sendPhoto(photo))) {
      emit(ReEnterUserDataState(
        user: user,
        image: photo,
        error: "Nie udało się wysłać danych.\n Spróbuj ponownie później!",
      ));
      return;
    }

    setUser();
  }

  Future<void> updateUser() async {
    if (await _updateUser(_user!)) {
      _user!.id = authService.currentUserId!;
      emit(SignedInState());
    } else {
      emit(ErrorStateWhenUpdatingUser(
          message: "Nie udało się wysłać danych.\n Spróbuj ponownie później!"));
    }
  }

  Future<bool> _updateUser(User user) async {
    var response =
        await userService.updateUser(authService.currentUserId!, user);
    if (response.error != ErrorType.none) {
      return false;
    }

    return true;
  }

  Future<bool> _sendPhoto(Uint8List photo) async {
    var response =
        await userService.changePhoto(authService.currentUserId!, photo);
    if (response.error != ErrorType.none) {
      return false;
    }

    return true;
  }

  Future<void> setUser() async {
    _user = await _getUser(authService.currentUserId!);
    if (_user != null) {
      emit(SignedInState());
    }
  }

  Future<User?> _getUser(String userId) async {
    final response = await userService.getUser(userId);
    if (response.error != ErrorType.none) {
      if (response.error == ErrorType.notFound) {
        emit(UserNotFoundState());
      } else {
        emit(ErrorStateWhenGettingUser(
            message: "Nie udało się połączyć z usługą.\n"
                "Sprawdź połączenie z internetem\n i spróbuj ponownie później!"));
      }
      return null;
    }
    return response.data;
  }

  void savePersonalInfo(
      String company, String name, String surname, String phoneNumber) {
    _user ??= User.empty();
    _user!.company = company;
    _user!.name = name;
    _user!.surname = surname;
    _user!.phoneNumber = phoneNumber;
  }

  void saveEmail(String email) {
    _user ??= User.empty();
    email = email.trim();
    _user!.email = email;
  }

  Future<void> signOut() async {
    await authService.signOut();

    _user = User.empty();
    emit(NeedsSigningInState());
  }

  Future<void> goToLoginPage() async {
    emit(LoginState(user: _user));
  }

  Future<void> goToPersonalInfoRegisterPage() async {
    emit(PersonalInfoRegisterState(user: _user));
  }

  Future<void> goToEmailAndPasswordRegisterPage() async {
    emit(RegisterState(user: _user));
  }

  Future<void> goToStartPage() async {
    emit(NeedsSigningInState());
  }

  Future<void> goToForgotPasswordPage(String email) async {
    emit(ForgotPasswordState(email: email));
  }

  Future<void> goToReEnterUserDataPage() async {
    emit(ReEnterUserDataState(user: User.empty()));
  }
}
