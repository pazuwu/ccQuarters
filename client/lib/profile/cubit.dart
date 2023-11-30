import 'package:ccquarters/model/house.dart';
import 'package:ccquarters/model/user.dart';
import 'package:ccquarters/services/alerts/service.dart';
import 'package:ccquarters/services/houses/service.dart';
import 'package:ccquarters/services/service_response.dart';
import 'package:ccquarters/services/users/service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePageState {}

class ProfilePageInitialState extends ProfilePageState {}

class LoadingState extends ProfilePageState {}

class DataState extends ProfilePageState {
  DataState({
    required this.myHouses,
    required this.likedHouses,
  });
  List<House> myHouses;
  List<House> likedHouses;
}

class ProfilePageCubit extends Cubit<ProfilePageState> {
  ProfilePageCubit({
    required this.userService,
    required this.alertService,
    required this.houseService,
  }) : super(ProfilePageInitialState());

  UserService userService;
  AlertService alertService;
  HouseService houseService;

  int _myHousesCurrentPage = 1;
  int _likedHousesCurrentPage = 1;
  List<House> _myHouses = [];
  List<House> _likedHouses = [];

  void goBack() {
    emit(ProfilePageInitialState());
  }

  Future<void> loadData() async {
    emit(LoadingState());
    await Future.wait([
      getMyHouses(),
      getLikedHouses(),
    ]);

    emit(DataState(
      myHouses: _myHouses,
      likedHouses: _likedHouses,
    ));
  }

  Future<User?> getUser(String userId) async {
    final response = await userService.getUser(userId);
    if (response.error != ErrorType.none) {
      return null;
    }
    return response.data;
  }

  Future getMyHouses() async {
    final response = await houseService.getMyHouses();
    if (response.error != ErrorType.none) {
      return [];
    }

    _myHouses = response.data;
    _myHousesCurrentPage = 1;
  }

  Future getLikedHouses() async {
    final response = await houseService.getLikedHouses();
    if (response.error != ErrorType.none) {
      return [];
    }

    _likedHouses = response.data;
    _likedHousesCurrentPage = 1;
  }

  Future getMyHousesNextPage() async {
    _myHousesCurrentPage++;
    final response = await houseService.getMyHouses(
      pageNumber: _myHousesCurrentPage,
    );

    if (response.error != ErrorType.none) {
      _myHouses += response.data;
      emit(DataState(myHouses: _myHouses, likedHouses: _likedHouses));
    }
  }

  Future getLikedHousesNextPage() async {
    _likedHousesCurrentPage++;
    final response = await houseService.getLikedHouses(
      pageNumber: _likedHousesCurrentPage,
    );

    if (response.error != ErrorType.none) {
      _likedHouses += response.data;
      emit(DataState(myHouses: _myHouses, likedHouses: _likedHouses));
    }
  }

  Future refresh() async {
    getMyHouses();
    getLikedHouses();
  }
}
