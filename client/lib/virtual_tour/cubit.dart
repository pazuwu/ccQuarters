import 'package:ccquarters/virtual_tour/model/mocked_virtual_tour.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ccquarters/virtual_tour/model/link.dart';
import 'package:ccquarters/virtual_tour/model/scene.dart';
import 'package:ccquarters/virtual_tour/model/virtual_tour.dart';

class VTState {}

class VTLoadingState extends VTState {
  VTLoadingState({
    required this.houseId,
  });

  String houseId;
}

class VTLoadedState extends VTState {
  VTLoadedState({required this.virtualTour});

  final VirtualTour virtualTour;
}

class VTErrorState extends VTState {
  VTErrorState({required this.text});

  final String text;
}

class VirtualTourCubit extends Cubit<VTState> {
  VirtualTourCubit(VTState initialState) : super(initialState) {
    if (initialState is VTLoadingState) {
      loadVirtualTour(initialState.houseId);
    }
  }

  Future loadVirtualTour(String houseId) {
    emit(VTLoadedState(virtualTour: VirtualTourMock.from360Url("")));
    return Future.value();
  }

  Future<Link> addNewLinkToScene(Scene parent, Link link) {
    return Future.value(link);
  }

  Future removeLinkFromScene(Scene parent, Link link) {
    throw UnimplementedError();
  }

  Future updateLinkOrientation() {
    throw UnimplementedError();
  }

  Future upload360Photo() {
    throw UnimplementedError();
  }

  Future uploadAreaPhoto() {
    throw UnimplementedError();
  }
}
