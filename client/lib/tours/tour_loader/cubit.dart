import 'package:ccquarters/services/service_response.dart';
import 'package:ccquarters/tours/tour_loader/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ccquarters/model/virtual_tour/tour.dart';
import 'package:ccquarters/services/virtual_tours/service.dart';

class TourLoaderCubit extends Cubit<TourLoadingState> {
  final VTService _service;
  Tour? _tour;

  TourLoaderCubit({
    required TourLoadingState initialState,
    required VTService service,
    required String tourId,
    required bool readOnly,
  })  : _service = service,
        super(initialState) {
    if (readOnly) {
      loadVirtualTourForView(tourId);
    } else {
      loadVirtualTourForEdit(tourId);
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

    emit(TourLoadingProgressState(
      tourId: _tour!.id,
      readOnly: readOnly,
      progress: progress / allTotals,
    ));
  }

  Future loadVirtualTourForView(String tourId) async {
    var serviceResponse = await _service.getTour(tourId);

    if (serviceResponse.error == ErrorType.none &&
        serviceResponse.data != null) {
      _tour = serviceResponse.data;

      await _downloadSceneImages(_tour!, true);

      emit(
        TourLoadedState(
          virtualTour: _tour!,
        ),
      );
    } else {
      _handleServiceError(serviceResponse);
    }
  }

  Future loadVirtualTourForEdit(String tourId) async {
    var serviceResponse = await _service.getTourForEdit(tourId);

    if (serviceResponse.error == ErrorType.none &&
        serviceResponse.data != null) {
      _tour = serviceResponse.data;

      await _downloadSceneImages(_tour!, false);

      emit(
        TourForEditLoadedState(
          virtualTour: serviceResponse.data!,
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
        emit(TourLoadingErrorState(text: "Nie masz uprawnień do tego spaceru"));
      case ErrorType.notFound:
        emit(TourLoadingErrorState(text: "Spacer nie został odnaleziony"));
      case ErrorType.badRequest:
      case ErrorType.unknown:
      default:
        emit(TourLoadingErrorState(
            text: "Wystąpił błąd podczas próby pobrania spaceru.",
            tip: "Spróbuj ponownie później."));
    }
  }
}

class DownloadInfo {
  DownloadInfo({required this.progress, required this.total});

  final int progress;
  final int total;
}
