import 'package:ccquarters/model/user.dart';

abstract class AuthState {}

class NeedsSigningInState extends AuthState {}

class SignedInState extends AuthState {
  SignedInState();
}

class SigningInState extends AuthState {}

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