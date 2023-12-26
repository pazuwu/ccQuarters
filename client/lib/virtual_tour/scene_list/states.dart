import 'package:ccquarters/virtual_tour/model/tour.dart';
import 'package:equatable/equatable.dart';

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
