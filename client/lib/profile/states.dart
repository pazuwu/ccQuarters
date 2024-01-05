import 'package:ccquarters/model/user/user.dart';

class ProfilePageState {}

class ProfilePageInitialState extends ProfilePageState {
  ProfilePageInitialState({required this.user});
  final User user;
}

class EditProfileState extends ProfilePageState {
  EditProfileState({required this.user});
  final User user;
}

class LoadingDataState extends ProfilePageState {}

class SendingDataState extends ProfilePageState {}

class ErrorState extends ProfilePageState {
  ErrorState({
    required this.message,
    this.tip,
  });
  final String message;
  final String? tip;
}