import 'dart:io';

import 'package:ccquarters/virtual_tour/model/area.dart';
import 'package:ccquarters/virtual_tour/model/geo_point.dart';
import 'package:ccquarters/virtual_tour/model/scene.dart';
import 'package:ccquarters/virtual_tour/service/service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ccquarters/virtual_tour/model/link.dart';
import 'package:ccquarters/virtual_tour/model/tour.dart';

class VTState {}

class VTLoadingState extends VTState {
  VTLoadingState({
    required this.houseId,
  });

  String houseId;
}

class VTLoadedState extends VTState {
  VTLoadedState({required this.virtualTour});

  final Tour virtualTour;
}

class VTErrorState extends VTState {
  VTErrorState({required this.text});

  final String text;
}

class VirtualTourCubit extends Cubit<VTState> {
  final VTService _service;
  Tour? _tour;

  VirtualTourCubit({required VTState initialState, required VTService service})
      : _service = service,
        super(initialState) {
    if (initialState is VTLoadingState) {
      loadVirtualTour(initialState.houseId);
    }
  }

  Future loadVirtualTour(String tourId) async {
    var serviceResponse = await _service.getTour(tourId);

    if (serviceResponse.error == null && serviceResponse.data != null) {
      _tour = serviceResponse.data;
      emit(VTLoadedState(virtualTour: serviceResponse.data!));
    }
  }

  Future<Link?> addNewLink(Link link) async {
    if (_tour != null) {
      var serviceResponse = await _service.postLink(_tour!.id, link);

      if (serviceResponse.data != null) {
        return link.copyWith(id: serviceResponse.data!);
      }
    }

    return null;
  }

  Future removeLink(Link link) async {
    if (_tour != null && link.id != null) {
      await _service.deleteLink(_tour!.id, link.id!);
    }
  }

  Future<Link> updateLinkPosition(Link link, GeoPoint position) async {
    if (_tour != null && link.id != null) {
      var serviceResponse =
          await _service.updateLink(_tour!.id, link.id!, position: position);
      if (serviceResponse.data == true) {
        return link.copyWith(position: position);
      }
    }

    return link;
  }

  Future uploadScenePhoto(Scene scene, String path) async {
    if (_tour != null && scene.id != null) {
      var photoFile = File(path);
      var photoBytes = await photoFile.readAsBytes();
      await _service.uploadScenePhoto(_tour!.id, scene.id!, photoBytes);
    }
  }

  Future uploadAreaPhoto(Area area, String path) async {
    if (_tour != null && area.id != null) {
      var photoFile = File(path);
      var photoBytes = await photoFile.readAsBytes();
      await _service.uploadAreaPhoto(_tour!.id, area.id!, photoBytes);
    }
  }
}
