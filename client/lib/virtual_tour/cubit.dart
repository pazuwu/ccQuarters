import 'package:flutter_bloc/flutter_bloc.dart';

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
        default:
          emit(VTErrorState(
              text:
                  "Wystąpił błąd podczas próby pobrania spaceru. Spróbuj później."));
      }
    }
  }
}
