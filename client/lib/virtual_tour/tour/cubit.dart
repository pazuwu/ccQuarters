import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ccquarters/virtual_tour/model/scene.dart';
import 'package:ccquarters/virtual_tour/model/tour.dart';
import 'package:ccquarters/virtual_tour/service/service.dart';
import 'package:ccquarters/virtual_tour/service/service_response.dart';

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
  VTEditingState({required this.virtualTour, this.uploadProgress = 0.0});

  final Tour virtualTour;
  final double uploadProgress;
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
    var serviceResponse = await _service.getTour(tourId);

    if (serviceResponse.error == ErrorType.none &&
        serviceResponse.data != null) {
      _tour = serviceResponse.data;

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
        case ErrorType.unknown:
        default:
          emit(VTErrorState(
              text:
                  "Wystąpił błąd podczas próby pobrania spaceru. Spróbuj później."));
      }
    }
  }
}

class DownloadInfo {
  DownloadInfo({required this.progress, required this.total});

  final int progress;
  final int total;
}
