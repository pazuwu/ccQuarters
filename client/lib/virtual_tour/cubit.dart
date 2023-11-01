// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ccquarters/virtual_tour/model/area.dart';
import 'package:ccquarters/virtual_tour/model/geo_point.dart';
import 'package:ccquarters/virtual_tour/model/link.dart';
import 'package:ccquarters/virtual_tour/model/scene.dart';
import 'package:ccquarters/virtual_tour/model/tour.dart';
import 'package:ccquarters/virtual_tour/service/service.dart';
import 'package:ccquarters/virtual_tour/service/service_response.dart';

class VTState {}

class VTLoadingState extends VTState {
  VTLoadingState({
    required this.tourId,
    required this.readOnly,
  });

  final String tourId;
  final bool readOnly;
}

class VTEditingState extends VTState {
  VTEditingState({required this.virtualTour});

  final Tour virtualTour;
}

class VTViewingState extends VTState {
  final Scene currentScene;
  final List<Link> links;

  VTViewingState({
    required this.currentScene,
    required this.links,
  });
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
      loadVirtualTour(initialState.tourId, initialState.readOnly);
    }
  }

  Future loadVirtualTour(String tourId, bool readOnly) async {
    var serviceResponse = await _service.getTour(tourId);

    if (serviceResponse.error == null && serviceResponse.data != null) {
      _tour = serviceResponse.data;

      if (readOnly) {
        var scene = _tour!.scenes.first;

        emit(
          VTViewingState(
            currentScene: scene,
            links: _tour!.links
                .where((element) => element.parentId == scene.id)
                .toList(),
          ),
        );
      } else {
        emit(VTEditingState(virtualTour: serviceResponse.data!));
      }
    } else {
      switch (serviceResponse.error) {
        case ErrorType.unauthorized:
          emit(VTErrorState(text: "Nie masz uprawnień do tego spaceru"));
        case ErrorType.notFound:
          emit(VTErrorState(text: "Spacer nie został odnaleziony"));
        case ErrorType.badRequest:
        case null:
        case ErrorType.unknown:
          emit(VTErrorState(
              text:
                  "Wystąpił błąd podczas próby pobrania spaceru. Spróbuj później."));
      }
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

  void useLink(Link link) {
    var destination =
        _tour?.scenes.firstWhere((element) => element.id == link.destinationId);

    if (_tour != null && destination != null) {
      emit(VTViewingState(
          currentScene: destination,
          links: _tour!.links
              .where((element) => element.parentId == destination.id)
              .toList()));
    }
  }
}
