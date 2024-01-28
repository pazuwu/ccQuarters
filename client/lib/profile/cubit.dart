import 'dart:typed_data';

import 'package:ccquarters/profile/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ccquarters/model/houses/house.dart';
import 'package:ccquarters/model/users/user.dart';
import 'package:ccquarters/services/houses/service.dart';
import 'package:ccquarters/services/service_response.dart';
import 'package:ccquarters/services/users/service.dart';

class ProfilePageCubit extends Cubit<ProfilePageState> {
  ProfilePageCubit({
    required this.userService,
    required this.houseService,
    required userId,
  }) : super(LoadingDataState()) {
    setUser(userId);
  }

  UserService userService;
  HouseService houseService;
  late User user;

  Future<void> setUser(String? userId) async {
    final response = userId != null ? await _getUser(userId) : null;
    if (response == null) {
      user = User.empty();
      emit(ErrorState(
          message: "Nie udało się pobrać danych \nTwojego profilu.",
          tip:
              "Sprawdź swoje połączenie z internetem lub \nspróbuj ponownie później."));
      return;
    }

    user = response;
    emit(ProfilePageInitialState(user: user));
  }

  Future<User?> _getUser(String userId) async {
    final response = await userService.getUser(userId);
    if (response.error != ErrorType.none) {
      return null;
    }
    return response.data;
  }

  Future<void> updateUser(User user, Uint8List? image, bool deleteImage) async {
    emit(SendingDataState());

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
