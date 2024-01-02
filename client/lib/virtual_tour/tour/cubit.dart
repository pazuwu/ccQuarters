import 'package:ccquarters/services/service_response.dart';
import 'package:ccquarters/virtual_tour/tour/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ccquarters/virtual_tour/model/tour.dart';
import 'package:ccquarters/services/virtual_tours/service.dart';

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

  void _updateProgress(Map<String, DownloadInfo> progressMap, bool readOnly) {
    if (_tour!.scenes.length != progressMap.length) {
      return;
    }

    var progress = 0.0;
    var allTotals = 0.0;
    for (var item in progressMap.values) {
      progress += item.progress;
      allTotals += item.total;
    }

    emit(VTLoadingState(
      tourId: _tour!.id,
      readOnly: readOnly,
      progress: progress / allTotals,
    ));
  }

  Future loadVirtualTour(String tourId, bool readOnly) async {
    if (readOnly) {
      return _loadVirtualTourForView(tourId);
    } else {
      return _loadVirtualTourForEdit(tourId);
    }
  }

  Future _loadVirtualTourForEdit(String tourId) async {
    var serviceResponse = await _service.getTourForEdit(tourId);

    if (serviceResponse.error == ErrorType.none &&
        serviceResponse.data != null) {
      _tour = serviceResponse.data;

      await _downloadSceneImages(_tour!, false);

      emit(
        VTEditingState(
          virtualTour: serviceResponse.data!,
        ),
      );
    } else {
      _handleServiceError(serviceResponse);
    }
  }

  Future _loadVirtualTourForView(String tourId) async {
    var serviceResponse = await _service.getTour(tourId);

    if (serviceResponse.error == ErrorType.none &&
        serviceResponse.data != null) {
      _tour = serviceResponse.data;

      await _downloadSceneImages(_tour!, true);

      var scene = _tour!.scenes.first;
      emit(
        VTViewingState(
          currentScene: scene,
          virtualTour: _tour!,
        ),
      );
    } else {
      _handleServiceError(serviceResponse);
    }
  }

  Future _downloadSceneImages(Tour tour, bool readOnly) async {
    List<Future> tasks = [];
    var progressMap = <String, DownloadInfo>{};

    for (var scene in _tour!.scenes) {
      if (scene.photo360Url != null) {
        tasks.add(_service.downloadFile(scene.photo360Url!,
            progressCallback: (progress, total) {
          progressMap[scene.id!] =
              DownloadInfo(progress: progress, total: total);
          _updateProgress(progressMap, readOnly);
        }).then((responce) {
          scene.photo360 = responce.data;
        }));
      }
    }

    await Future.wait(tasks);
  }

  void _handleServiceError<T>(ServiceResponse<T> serviceResponse) {
    switch (serviceResponse.error) {
      case ErrorType.unauthorized:
        emit(VTErrorState(text: "Nie masz uprawnień do tego spaceru"));
      case ErrorType.notFound:
        emit(VTErrorState(text: "Spacer nie został odnaleziony"));
      case ErrorType.badRequest:
      case ErrorType.unknown:
      default:
        emit(VTErrorState(
            text:
                "Wystąpił błąd podczas próby pobrania spaceru. Spróbuj później."));
    }
  }
}

class DownloadInfo {
  DownloadInfo({required this.progress, required this.total});

  final int progress;
  final int total;
}
