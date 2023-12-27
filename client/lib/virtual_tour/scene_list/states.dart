// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:typed_data';

import 'package:ccquarters/virtual_tour/model/area.dart';
import 'package:equatable/equatable.dart';

import 'package:ccquarters/virtual_tour/model/tour.dart';

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

class VTScenesUploadFailedState extends VTScenesState {
  const VTScenesUploadFailedState({
    required super.tour,
    required this.areaId,
    required this.failedImages,
  });

  final String areaId;
  final List<Uint8List> failedImages;
  @override
  List<Object?> get props => [failedImages];
}

class VTScenesCreateOperationFailedState extends VTScenesState {
  const VTScenesCreateOperationFailedState({
    required super.tour,
    required this.areaId,
    this.attempt = 0,
  });

  final String areaId;
  final int attempt;
  @override
  List<Object?> get props => [areaId, attempt];
}

class ShowAreaPhotosState extends VTScenesState {
  const ShowAreaPhotosState({
    required super.tour,
    required this.area,
    required this.photoUrls,
  });

  final List<String> photoUrls;
  final Area area;

  @override
  List<Object?> get props => [photoUrls];
}

class VTScenesErrorState extends VTScenesState {
  VTScenesErrorState({
    required super.tour,
    required this.message,
  });

  final String message;
  final DateTime sendTime = DateTime.timestamp();

  @override
  List<Object?> get props => [message, sendTime];
}
