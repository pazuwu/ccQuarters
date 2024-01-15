import 'package:ccquarters/model/virtual_tours/tour.dart';
import 'package:ccquarters/model/virtual_tours/tour_for_edit.dart';

class TourLoadingState {}

class TourLoadingProgressState extends TourLoadingState {
  TourLoadingProgressState({
    required this.tourId,
    required this.readOnly,
    this.progress = 0.0,
  });

  final String tourId;
  final bool readOnly;
  final double progress;
}

class TourLoadedState extends TourLoadingState {
  TourLoadedState({
    required this.virtualTour,
  });

  final Tour virtualTour;
}

class TourForEditLoadedState extends TourLoadingState {
  TourForEditLoadedState({
    required this.virtualTour,
  });

  final TourForEdit virtualTour;
}

class TourLoadingErrorState extends TourLoadingState {
  TourLoadingErrorState({
    required this.text,
    this.tip,
  });

  final String text;
  final String? tip;
}
