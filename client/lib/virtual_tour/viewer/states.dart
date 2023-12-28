import 'package:ccquarters/virtual_tour/model/link.dart';
import 'package:ccquarters/virtual_tour/model/scene.dart';
import 'package:equatable/equatable.dart';

abstract class VTViewerState extends Equatable {
  @override
  List<Object?> get props => [];
}

class VTViewingSceneState extends VTViewerState {
  final Scene currentScene;
  final List<Link> links;
  final Object changedObject;

  VTViewingSceneState({
    required this.currentScene,
    required this.links,
    required this.changedObject,
  });

  @override
  List<Object?> get props => [changedObject];
}

class VTViewerInitial extends VTViewerState {}

class VTViewerScenesLoadingState extends VTViewingSceneState {
  final String message;

  VTViewerScenesLoadingState({
    required super.currentScene,
    required super.links,
    required super.changedObject,
    required this.message,
  });
}
