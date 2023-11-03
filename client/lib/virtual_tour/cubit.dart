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
import 'package:flutter_image_compress/flutter_image_compress.dart';

class VTState {}

class VTLoadingState extends VTState {
  VTLoadingState({
    required this.tourId,
    required this.readOnly,
    this.progress = 0.0,
  });

  final String tourId;
  final bool readOnly;
  final double progress;
}

class VTEditingState extends VTState {
  VTEditingState({required this.virtualTour});

  final Tour virtualTour;
}

class VTViewingState extends VTState {
  final Scene currentScene;
  final Tour virtualTour;

  VTViewingState({
    required this.currentScene,
    required this.virtualTour,
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

      var currentSceneIndx = 0;
      for (var scene in _tour!.scenes) {
        if (scene.photo360Url != null) {
          var response = await _service.downloadFile(scene.photo360Url!,
              progressCallback: (progress, total) {
            emit(VTLoadingState(
              tourId: tourId,
              readOnly: readOnly,
              progress: progress * 1 / _tour!.scenes.length / total +
                  currentSceneIndx * 1 / _tour!.scenes.length,
            ));
          });

          if (response.data != null) {
            var result = await FlutterImageCompress.compressWithList(
              response.data!,
              minHeight: 1920,
              minWidth: 1080,
              quality: 98,
              format: CompressFormat.png,
            );
            scene.photo360 = result;
          }
        }

        currentSceneIndx++;
      }

      if (readOnly) {
        var scene = _tour!.scenes.first;
        emit(
          VTViewingState(
            currentScene: scene,
            virtualTour: _tour!,
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

  Future addLink(
      {String? text,
      required String destinationId,
      required double longitude,
      required double latitude}) async {
    if (_tour == null) return;

    var link = Link(
        destinationId: destinationId,
        text: text,
        position: GeoPoint(longitude: longitude, latitude: latitude));

    var response = await _service.postLink(_tour!.id, link);

    if (response.data != null) {
      link.copyWith(id: response.data!);
      _tour?.links.add(link);
    }
  }

  Future createNewSceneFromPhoto(String path) async {
    if (_tour == null) return Future.value();

    var serviceResponse = await _service.postScene(
        tourId: _tour!.id, parentId: "", name: "new scene");

    if (serviceResponse.data != null) {
      var url = await _uploadScenePhoto(serviceResponse.data!, path);

      var newScene =
          Scene(name: "", photo360Url: url, id: serviceResponse.data!);
      _tour!.scenes.add(newScene);
    }
  }

  Future _uploadScenePhoto(String sceneId, String path) async {
    if (_tour != null) {
      var photoFile = File(path);
      var photoBytes = await photoFile.readAsBytes();
      await _service.uploadScenePhoto(_tour!.id, sceneId, photoBytes);
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
