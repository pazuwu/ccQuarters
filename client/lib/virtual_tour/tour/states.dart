import 'package:ccquarters/virtual_tour/model/scene.dart';
import 'package:ccquarters/virtual_tour/model/tour.dart';
import 'package:ccquarters/virtual_tour/model/tour_for_edit.dart';

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

  final TourForEdit virtualTour;
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
