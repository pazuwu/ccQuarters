import 'package:flutter_bloc/flutter_bloc.dart';

class MainPageState {}

class MainPageInitialState extends MainPageState {}

class SearchState extends MainPageState {}

class MainPageCubit extends Cubit<MainPageState> {
  MainPageCubit() : super(MainPageInitialState());

  void search() {
    emit(SearchState());
  }

  void goBack() {
    emit(MainPageInitialState());
  }
}
