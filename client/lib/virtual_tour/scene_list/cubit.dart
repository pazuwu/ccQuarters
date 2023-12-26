import 'dart:async';

import 'package:ccquarters/virtual_tour/scene_list/states.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import 'package:ccquarters/virtual_tour/model/area.dart';
import 'package:ccquarters/virtual_tour/model/scene.dart';
import 'package:ccquarters/virtual_tour/model/tour.dart';
import 'package:ccquarters/virtual_tour/service/service.dart';

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
      var result = kIsWeb
          ? photo
          : await FlutterImageCompress.compressWithList(
              photo,
              minHeight: 1920,
              minWidth: 1080,
              format: CompressFormat.jpeg,
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
            tour: _tour, message: "Dodano nową scenę", changedObject: newScene),
      );
    }
  }

  Future<Area?> createNewAreaFromPhotos(List<Uint8List?> files,
      {required String name}) async {
    var response = await _service.postArea(_tour.id, name: name);

    if (response.data != null) {
      emit(
        VTScenesLoadingState(tour: _tour, message: "Przeysyłanie zdjęć..."),
      );

      var futures = <Future>[];

      for (var file in files) {
        if (file != null) {
          futures.add(_uploadAreaPhoto(response.data!, file));
        }
      }

      await Future.wait(futures);

      await _service.postOperation(_tour.id, response.data!);
      emit(VTScenesSuccessState(
          tour: _tour,
          message: "Zaplanowano utworzenie sceny $name",
          changedObject: response.data!));
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
          message: "Scena główna została zmieniona",
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
            tour: _tour, message: "Usunięto scenę", changedObject: sceneId),
      );
    }
  }
}
