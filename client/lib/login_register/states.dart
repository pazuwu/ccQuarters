import 'dart:typed_data';

import 'package:ccquarters/model/users/user.dart';

abstract class AuthState {}

class NeedsSigningInState extends AuthState {}

class SignedInState extends AuthState {}

class LoadingState extends AuthState {}

class ErrorState extends AuthState {
  ErrorState({required this.message});

  final String message;
}

class ErrorStateWhenUpdatingUser extends ErrorState {
  ErrorStateWhenUpdatingUser({required super.message});
}

class ErrorStateWhenGettingUser extends ErrorState {
  ErrorStateWhenGettingUser({required super.message});
}

class UserNotFoundState extends AuthState {}

class ReEnterUserDataState extends AuthState {
  ReEnterUserDataState({required this.user, this.image, this.error});

  final User user;
  final Uint8List? image;
  final String? error;
}

class InputDataState extends AuthState {
  InputDataState({required this.user, this.password = "", this.error});

  String? error;
  final User user;
  final String password;
}

class LoginState extends InputDataState {
  LoginState({required user, password = "", error})
      : super(user: user, password: password, error: error);
}

class PersonalInfoRegisterState extends InputDataState {
  PersonalInfoRegisterState({required user, password = "", error})
      : super(user: user, password: password, error: error);
}

class RegisterState extends InputDataState {
  RegisterState({required user, password = "", error})
      : super(user: user, password: password, error: error);
}

class ForgotPasswordState extends AuthState {
  ForgotPasswordState({this.email = "", this.error});

  String? error;
  final String email;
}

class ForgotPasswordSuccessState extends AuthState {}
