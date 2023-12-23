import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import 'package:ccquarters/virtual_tour/model/area.dart';
import 'package:ccquarters/virtual_tour/model/scene.dart';
import 'package:ccquarters/virtual_tour/model/tour.dart';
import 'package:ccquarters/virtual_tour/service/service.dart';

class VTScenesState extends Equatable {
  final Tour tour;
  const VTScenesState({required this.tour});

  @override
  List<Object?> get props => [tour.scenes.length];
}

class VTScenesLoadingState extends VTScenesState {
  const VTScenesLoadingState({
    required super.tour,
    required this.message,
  });

  final String message;

  @override
  List<Object?> get props => super.props + [message];
}

class VTScenesSuccessState extends VTScenesState {
  const VTScenesSuccessState({
    required super.tour,
    required this.message,
    required this.changedObject,
  });

  final String message;
  final Object changedObject;

  @override
  List<Object?> get props => super.props + [message, changedObject];
}

class VTScenesUploadingState extends VTScenesState {
  const VTScenesUploadingState({required this.progress, required super.tour});

  final double progress;

  @override
  List<Object?> get props => [progress];
}

class VTScenesCubit extends Cubit<VTScenesState> {
  VTScenesCubit(
    this._service,
    this._tour,
  ) : super(VTScenesState(tour: _tour));

  final VTService _service;
  final Tour _tour;

  Future createNewSceneFromPhoto(Uint8List photo,
      {required String name}) async {
    emit(VTScenesLoadingState(tour: _tour, message: "Tworzenie nowej sceny"));
    var serviceResponse =
        await _service.postScene(tourId: _tour.id, parentId: "", name: name);

    if (serviceResponse.data != null) {
      var result = await FlutterImageCompress.compressWithList(
        photo,
        minHeight: 1920,
        minWidth: 1080,
        quality: 98,
        format: CompressFormat.png,
      );

      var url = await _uploadScenePhoto(serviceResponse.data!, result);

      var newScene = Scene(
          name: name,
          photo360Url: url,
          id: serviceResponse.data!,
          photo360: result);
      _tour.scenes.add(newScene);

      emit(
        VTScenesSuccessState(
            tour: _tour,
            message: "Scena została dodana",
            changedObject: newScene),
      );
    }
  }

  Future<Area?> createNewAreaFromPhotos(List<String?> paths,
      {required String name}) async {
    var response = await _service.postArea(_tour.id, name: name);

    if (response.data != null) {
      var index = 0;
      for (var path in paths) {
        if (path != null) {
          var file = await File(path).readAsBytes();

          await _uploadAreaPhoto(response.data!, file,
              progressCallback: (count, total) {
            emit(VTScenesUploadingState(
              tour: _tour,
              progress:
                  count * 1 / paths.length / total + index * 1 / paths.length,
            ));
          });

          index++;
        }
      }

      await _service.postOperation(_tour.id, response.data!);
      emit(VTScenesState(tour: _tour));
    }

    return Area(
      id: response.data!,
    );
  }

  Future _uploadScenePhoto(String sceneId, Uint8List photoBytes) async {
    await _service.uploadScenePhoto(_tour.id, sceneId, photoBytes);
  }

  Future _uploadAreaPhoto(String areaId, Uint8List photoBytes,
      {void Function(int count, int total)? progressCallback}) async {
    await _service.uploadAreaPhoto(
      _tour.id,
      areaId,
      photoBytes,
      progressCallback: progressCallback,
    );
  }

  Future setAsPrimaryScene(String sceneId) async {
    var plannedLoading = Timer(const Duration(milliseconds: 500), () {
      emit(VTScenesLoadingState(tour: _tour, message: "Zmiana sceny głównej"));
    });

    var result = await _service.updateTour(_tour.id, primarySceneId: sceneId);
    plannedLoading.cancel();

    if (result.data ?? false) {
      _tour.primarySceneId = sceneId;
      emit(
        VTScenesSuccessState(
          tour: _tour,
          message: "Scena główna zmieniona",
          changedObject: sceneId,
        ),
      );
    }
  }

  Future deleteScene(String sceneId) async {
    var plannedLoading = Timer(const Duration(milliseconds: 500), () {
      emit(VTScenesLoadingState(tour: _tour, message: "Usuwanie sceny"));
    });

    var result = await _service.deleteScene(_tour.id, sceneId);
    plannedLoading.cancel();

    if (result.data ?? false) {
      _tour.scenes.removeWhere((element) => element.id == sceneId);
      emit(
        VTScenesSuccessState(
            tour: _tour, message: "Scena usunięta", changedObject: sceneId),
      );
    }
  }
}
