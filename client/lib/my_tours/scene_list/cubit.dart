import 'dart:async';

import 'package:ccquarters/services/service_response.dart';
import 'package:ccquarters/model/virtual_tours/area.dart';
import 'package:ccquarters/model/virtual_tours/tour_for_edit.dart';
import 'package:ccquarters/my_tours/scene_list/states.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import 'package:ccquarters/model/virtual_tours/scene.dart';
import 'package:ccquarters/services/virtual_tours/service.dart';

class TourEditCubit extends Cubit<TourEditState> {
  TourEditCubit(this._service, this._tour) : super(TourEditState(tour: _tour));

  final VTService _service;
  final TourForEdit _tour;

  Future createNewSceneFromPhoto(Uint8List photo,
      {required String name}) async {
    emit(TourEditModifyingState(tour: _tour, message: "Tworzenie nowej sceny"));
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
        TourEditSuccessState(
            tour: _tour, message: "Dodano nową scenę", changedObject: newScene),
      );
    }
  }

  Future<bool> addPhotosToArea(String areaId, List<Uint8List?> files,
      {bool createOperationFlag = true}) async {
    var futures = <Future<bool>>[];
    var failedImages = <Uint8List>[];

    emit(
      TourEditModifyingState(tour: _tour, message: "Przesyłanie zdjęć..."),
    );

    for (var file in files) {
      if (file != null) {
        futures.add(
          _uploadAreaPhoto(areaId, file).then(
            (result) {
              if (result == false) {
                failedImages.add(file);
              }

              return result;
            },
          ),
        );
      }
    }

    await Future.wait(futures);

    if (failedImages.isNotEmpty) {
      emit(
        TourEditUploadingFailedState(
          tour: _tour,
          failedImages: failedImages,
          areaId: areaId,
        ),
      );
      return false;
    }

    emit(TourEditSuccessState(
      tour: _tour,
      message: "Zdjęcia zostały dodane",
      changedObject: areaId,
    ));

    return createOperationFlag ? await createOperation(areaId) : true;
  }

  Future<bool> createNewArea({
    required List<Uint8List?> images,
    required String name,
    bool createOperation = true,
  }) async {
    var response = await _service.postArea(_tour.id, name: name);

    if (response.data != null) {
      _tour.areas.add(Area(
        id: response.data,
        name: name,
      ));

      return addPhotosToArea(
        response.data!,
        images,
        createOperationFlag: createOperation,
      );
    }

    return false;
  }

  Future<bool> createOperation(String areaId, [int attempt = 0]) async {
    var plannedLoading = Timer(const Duration(milliseconds: 500), () {
      emit(TourEditModifyingState(
          tour: _tour, message: "Planowanie przetwarzania"));
    });
    var serviceResponse = await _service.postOperation(_tour.id, areaId);

    plannedLoading.cancel();

    if (serviceResponse.error != ErrorType.none) {
      emit(TourEditCreateOperationFailedState(
          tour: _tour, areaId: areaId, attempt: ++attempt));
      return false;
    }
    _tour.areas.firstWhere((element) => element.id == areaId).operationId =
        serviceResponse.data;

    emit(TourEditSuccessState(
        tour: _tour,
        message: "Zaplanowano utworzenie sceny",
        changedObject: areaId));

    return true;
  }

  Future _uploadScenePhoto(String sceneId, Uint8List photoBytes) async {
    await _service.uploadScenePhoto(_tour.id, sceneId, photoBytes);
  }

  Future<bool> _uploadAreaPhoto(String areaId, Uint8List photoBytes,
      {void Function(int count, int total)? progressCallback}) async {
    var serviceResponse = await _service.uploadAreaPhoto(
      _tour.id,
      areaId,
      photoBytes,
      progressCallback: progressCallback,
    );

    return serviceResponse.data?.isNotEmpty ?? false;
  }

  Future setAsPrimaryScene(String sceneId) async {
    var plannedLoading = Timer(const Duration(milliseconds: 500), () {
      emit(
          TourEditModifyingState(tour: _tour, message: "Zmiana sceny głównej"));
    });

    var result = await _service.updateTour(_tour.id, primarySceneId: sceneId);
    plannedLoading.cancel();

    if (result.data) {
      _tour.primarySceneId = sceneId;
      emit(
        TourEditSuccessState(
          tour: _tour,
          message: "Scena główna została zmieniona",
          changedObject: sceneId,
        ),
      );
    }
  }

  Future deleteScene(String sceneId) async {
    var plannedLoading = Timer(const Duration(milliseconds: 500), () {
      emit(TourEditModifyingState(tour: _tour, message: "Usuwanie sceny"));
    });

    var result = await _service.deleteScene(_tour.id, sceneId);
    plannedLoading.cancel();

    if (result.data) {
      _tour.scenes.removeWhere((element) => element.id == sceneId);
      emit(
        TourEditSuccessState(
            tour: _tour, message: "Usunięto scenę", changedObject: sceneId),
      );
    }
  }

  Future showAreaPhotos(Area area) async {
    var plannedLoading = Timer(const Duration(milliseconds: 500), () {
      emit(TourEditModifyingState(tour: _tour, message: "Pobieranie zdjęć"));
    });
    var serviceResponse = await _service.getAreaPhotos(_tour.id, area.id!);
    plannedLoading.cancel();

    if (serviceResponse.error == ErrorType.none) {
      emit(TourEditShowAreaPhotosState(
        tour: _tour,
        photoUrls: serviceResponse.data!,
        area: area,
      ));
      return;
    }

    emit(TourEditErrorState(
      tour: _tour,
      message:
          "Wystąpił błąd podczas próby pobrania zdjęć. Sprawdź swoje połączenie z Internetem",
    ));
  }

  void closeAreaPhotos() {
    emit(TourEditState(tour: _tour));
  }
}
