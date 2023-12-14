import 'package:ccquarters/virtual_tour/service/service.dart';
import 'package:ccquarters/virtual_tour/service/service_response.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ccquarters/virtual_tour/model/tour_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VTListState {}

class VTListLoadingState extends VTListState {}

class VTListLoadedState extends VTListState {
  VTListLoadedState({
    required this.tours,
  });
  List<TourInfo> tours;
}

class VTListErrorState extends VTListState {
  VTListErrorState({
    required this.message,
  });
  String message;
}

class VTTourCreatingState extends VTListLoadedState {
  VTTourCreatingState({required super.tours});
}

class VTListCubit extends Cubit<VTListState> {
  VTListCubit({required VTService vtService, required VTListState state})
      : _service = vtService,
        super(state) {
    if (state is VTListLoadingState) {
      loadTours();
    }
  }

  final VTService _service;
  final List<TourInfo> _tours = [];

  Future loadTours() async {
    var serviceResponse = await _service.getMyTours();
    if (serviceResponse.error != ErrorType.none) {
      emit(VTListErrorState(message: serviceResponse.error.toString()));
    }

    _tours.clear();
    _tours.addAll(serviceResponse.data ?? []);
    emit(VTListLoadedState(tours: serviceResponse.data!));
  }

  Future createTour({required String name}) async {
    emit(VTTourCreatingState(tours: _tours));
    await _service.postTour(name: name);
    await loadTours();
  }

  Future<bool> hasUserSeenShowcase() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getBool("user_seen_vt_list_showcase") ?? false;
  }

  Future setUserSeenShowcase() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setBool("user_seen_vt_list_showcase", true);
  }
}
