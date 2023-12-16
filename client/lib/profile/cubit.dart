// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ccquarters/model/house.dart';
import 'package:ccquarters/model/user.dart';
import 'package:ccquarters/services/alerts/service.dart';
import 'package:ccquarters/services/houses/service.dart';
import 'package:ccquarters/services/service_response.dart';
import 'package:ccquarters/services/users/service.dart';

class ProfilePageState {}

class ProfilePageInitialState extends ProfilePageState {
  ProfilePageInitialState({required this.user});
  final User user;
}

class EditProfileState extends ProfilePageState {
  EditProfileState({required this.user});
  final User user;
}

class LoadingOrSendingDataState extends ProfilePageState {}

class ErrorState extends ProfilePageState {
  ErrorState({
    required this.message,
    this.tip,
  });
  final String message;
  final String? tip;
}

class ProfilePageCubit extends Cubit<ProfilePageState> {
  ProfilePageCubit({
    required this.userService,
    required this.alertService,
    required this.houseService,
    required userId,
  }) : super(LoadingOrSendingDataState()) {
    setUser(userId);
  }

  UserService userService;
  AlertService alertService;
  HouseService houseService;
  late User user;

  Future<void> setUser(String userId) async {
    final response = await getUser(userId);
    if (response == null) {
      emit(ErrorState(
          message: "Nie udało się pobrać danych twojego profilu.",
          tip:
              "Sprawdź swoje połączenie z internetem lub spróbuj ponownie później."));
      return;
    }

    user = response;
    emit(ProfilePageInitialState(user: user));
  }

  Future<User?> getUser(String userId) async {
    final response = await userService.getUser(userId);
    if (response.error != ErrorType.none) {
      return null;
    }
    return response.data;
  }

  Future<void> updateUser(User user, Uint8List? image, bool deleteImage) async {
    emit(LoadingOrSendingDataState());

    this.user = user;
    var response = await userService.updateUser(user.id, user);
    if (response.error != ErrorType.none) {
      emit(ErrorState(
          message:
              "Nie udało się zaktualizować danych. Spróbuj ponownie później."));
      return;
    }

    if (image != null) {
      response = await userService.changePhoto(user.id, image);
      if (response.error != ErrorType.none) {
        emit(ErrorState(
            message:
                "Nie udało się zaktualizować zdjęcia. Spróbuj ponownie później."));
        return;
      }
      await setUser(user.id);
    } else if (deleteImage) {
      response = await userService.deletePhoto(user.id);
      if (response.error != ErrorType.none) {
        emit(ErrorState(
            message:
                "Nie udało się usunąć zdjęcia. Spróbuj ponownie później."));
        return;
      }
      this.user.photoUrl = null;
    }

    emit(ProfilePageInitialState(user: this.user));
  }

  Future<List<House>> getMyHouses(int pageNumber, int pageCount) async {
    final response = await houseService.getMyHouses(
      pageNumber: pageNumber,
      pageCount: pageCount,
    );

    if (response.error != ErrorType.none) {
      return [];
    }

    return response.data;
  }

  Future<List<House>> getLikedHouses(int pageNumber, int pageCount) async {
    final response = await houseService.getLikedHouses(
      pageNumber: pageNumber,
      pageCount: pageCount,
    );

    if (response.error != ErrorType.none) {
      return [];
    }

    return response.data;
  }

  Future<void> goToEditUserPage() async {
    emit(EditProfileState(user: user));
  }

  Future<void> goToProfilePage() async {
    emit(ProfilePageInitialState(user: user));
  }
}
