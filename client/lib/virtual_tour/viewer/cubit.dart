// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ccquarters/virtual_tour/model/geo_point.dart';
import 'package:ccquarters/virtual_tour/model/link.dart';
import 'package:ccquarters/virtual_tour/model/scene.dart';
import 'package:ccquarters/virtual_tour/model/tour.dart';
import 'package:ccquarters/virtual_tour/service/service.dart';

abstract class VTViewerState extends Equatable {
  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [];
}

class VTViewingSceneState extends VTViewerState {
  final Scene currentScene;
  final List<Link> links;
  final int index;

  VTViewingSceneState({
    required this.currentScene,
    required this.links,
    required this.index,
  });

  @override
  List<Object?> get props => [index];
}

class VTViewerInitial extends VTViewerState {}

class VTViewerCubit extends Cubit<VTViewerState> {
  final Tour _tour;
  final VTService _service;
  int index = 1;

  VTViewerCubit(this._tour, this._service, {Scene? initialScene})
      : super(VTViewingSceneState(
            index: 0,
            currentScene: initialScene ?? _tour.scenes.first,
            links: _getLinksForParent(
                _tour, initialScene?.id ?? _tour.scenes.first.id ?? "")));

  List<Scene> get scenes => _tour.scenes;

  void useLink(Link link) {
    var destination = _tour.scenes.firstWhere(
        (element) => element.id == link.destinationId,
        orElse: () => Scene(name: "", photo360Url: ""));

    if (destination.id != null) {
      emit(VTViewingSceneState(
          index: index++,
          currentScene: destination,
          links: _getLinksForParent(_tour, destination.id!)));
    }
  }

  Future addLink(
      {String? text,
      required String parentId,
      required String destinationId,
      required double longitude,
      required double latitude}) async {
    var link = Link(
        parentId: parentId,
        destinationId: destinationId,
        text: text,
        position: GeoPoint(longitude: longitude, latitude: latitude));

    var response = await _service.postLink(_tour.id, link);

    if (response.data != null) {
      _tour.links.add(link.copyWith(id: response.data!));
      _refresh();
    }
  }

  Future removeLink(Link link) async {
    if (link.id != null) {
      await _service.deleteLink(_tour.id, link.id!);
      _tour.links.remove(link);
      _refresh();
    }
  }

  Future<Link> updateLink(Link link,
      {String? destinationId,
      GeoPoint? nextOrientation,
      GeoPoint? position,
      String? text}) async {
    if (link.id != null) {
      var serviceResponse = await _service.updateLink(_tour.id, link.id!,
          position: position,
          destinationId: destinationId,
          nextOrientation: nextOrientation,
          text: text);
      if (serviceResponse.data == true) {
        _tour.links.remove(link);
        _tour.links.add(link.copyWith(
          position: position,
          text: text,
          destinationId: destinationId,
          nextOrientation: nextOrientation,
        ));
      }
    }

    _refresh();

    return link;
  }

  void _refresh() {
    if (state is VTViewingSceneState) {
      var state = this.state as VTViewingSceneState;

      emit(VTViewingSceneState(
          index: index++,
          currentScene: state.currentScene,
          links: _getLinksForParent(_tour, state.currentScene.id!)));
    }
  }

  static List<Link> _getLinksForParent(Tour tour, String parentId) {
    return tour.links.where((element) => element.parentId == parentId).toList();
  }
}
