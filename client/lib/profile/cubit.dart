import 'package:ccquarters/model/house.dart';
import 'package:ccquarters/model/user.dart';
import 'package:ccquarters/services/alerts/service.dart';
import 'package:ccquarters/services/houses/service.dart';
import 'package:ccquarters/services/service_response.dart';
import 'package:ccquarters/services/users/service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePageState {}

class ProfilePageInitialState extends ProfilePageState {}

class ProfilePageCubit extends Cubit<ProfilePageState> {
  ProfilePageCubit({
    required this.userService,
    required this.alertService,
    required this.houseService,
  }) : super(ProfilePageInitialState());

  UserService userService;
  AlertService alertService;
  HouseService houseService;

  Future<User?> getUser(String userId) async {
    final response = await userService.getUser(userId);
    if (response.error != ErrorType.none) {
      return null;
    }
    return response.data;
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
}
