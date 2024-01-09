import 'package:ccquarters/model/virtual_tours/area.dart';
import 'package:ccquarters/model/virtual_tours/tour_for_edit.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';

class TourEditState extends Equatable {
  final TourForEdit tour;

  const TourEditState({required this.tour});

  @override
  List<Object?> get props => [tour.scenes.length];
}

class TourEditModifyingState extends TourEditState {
  const TourEditModifyingState({
    required super.tour,
    required this.message,
  });

  final String message;

  @override
  List<Object?> get props => super.props + [message];
}

class TourEditSuccessState extends TourEditState {
  const TourEditSuccessState({
    required super.tour,
    required this.message,
    required this.changedObject,
  });

  final String message;
  final Object changedObject;

  @override
  List<Object?> get props => super.props + [message, changedObject];
}

class TourEditUploadingState extends TourEditState {
  const TourEditUploadingState({required this.progress, required super.tour});

  final double progress;

  @override
  List<Object?> get props => [progress];
}

class TourEditUploadingFailedState extends TourEditState {
  const TourEditUploadingFailedState({
    required super.tour,
    required this.areaId,
    required this.failedImages,
  });

  final String areaId;
  final List<PlatformFile> failedImages;
  @override
  List<Object?> get props => [failedImages];
}

class TourEditCreateOperationFailedState extends TourEditState {
  const TourEditCreateOperationFailedState({
    required super.tour,
    required this.areaId,
    this.attempt = 0,
  });

  final String areaId;
  final int attempt;
  @override
  List<Object?> get props => [areaId, attempt];
}

class TourEditShowAreaPhotosState extends TourEditState {
  const TourEditShowAreaPhotosState({
    required super.tour,
    required this.area,
    required this.photoUrls,
  });

  final List<String> photoUrls;
  final Area area;

  @override
  List<Object?> get props => [photoUrls];
}

class TourEditErrorState extends TourEditState {
  TourEditErrorState({
    required super.tour,
    required this.message,
  });

  final String message;
  final DateTime sendTime = DateTime.timestamp();

  @override
  List<Object?> get props => [message, sendTime];
}
