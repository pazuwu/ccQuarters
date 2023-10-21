import 'package:ccquarters/model/house.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainPageState {}

class MainPageInitialState extends MainPageState {}

class SearchState extends MainPageState {}

class DetailsState extends MainPageState {
  DetailsState(this.house);

  final House house;
}

class MainPageCubit extends Cubit<MainPageState> {
  MainPageCubit() : super(MainPageInitialState());

  void search() {
    emit(SearchState());
  }

  void goBack() {
    emit(MainPageInitialState());
  }

  void goToDetails(House house) {
    emit(DetailsState(house));
  }
}
