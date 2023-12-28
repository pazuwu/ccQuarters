import 'dart:async';

import 'package:ccquarters/virtual_tour/viewer/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ccquarters/virtual_tour/model/geo_point.dart';
import 'package:ccquarters/virtual_tour/model/link.dart';
import 'package:ccquarters/virtual_tour/model/scene.dart';
import 'package:ccquarters/virtual_tour/model/tour.dart';
import 'package:ccquarters/virtual_tour/service/service.dart';

class VTViewerCubit extends Cubit<VTViewerState> {
  final Tour _tour;
  final VTService _service;
  Future? _downloadingFuture;

  VTViewerCubit(this._tour, this._service, {Scene? initialScene})
      : super(VTViewingSceneState(
          changedObject: 0,
          currentScene: initialScene ?? _tour.scenes.first,
          links: _getLinksForParent(
              _tour, initialScene?.id ?? _tour.scenes.first.id ?? ""),
        )) {
    downloadNeighbors(initialScene ?? _tour.scenes.first);
  }

  List<Scene> get scenes => _tour.scenes;

  Future useLink(Link link) async {
    var source =
        _tour.scenes.firstWhere((element) => element.id == link.parentId);

    var destination = _tour.scenes.firstWhere(
      (element) => element.id == link.destinationId,
      orElse: () => Scene(name: "", photo360Url: ""),
    );

    if (_downloadingFuture != null) {
      var plannedLoading = Timer(
        const Duration(milliseconds: 500),
        () {
          emit(VTViewerScenesLoadingState(
              currentScene: source,
              links: _getLinksForParent(_tour, destination.id!),
              changedObject: DateTime.timestamp(),
              message: "Ładowanie kolejnej sceny"));
        },
      );

      await _downloadingFuture;
      plannedLoading.cancel();
      _downloadingFuture = null;
    }

    if (destination.id != null) {
      emit(VTViewingSceneState(
        changedObject: DateTime.timestamp(),
        currentScene: destination,
        links: _getLinksForParent(_tour, destination.id!),
      ));
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
          changedObject: DateTime.timestamp(),
          currentScene: state.currentScene,
          links: _getLinksForParent(_tour, state.currentScene.id!)));
    }
  }

  Future downloadNeighbors(Scene scene) async {
    var futureMap = <String, Future>{};

    for (var link in _tour.links.where(
      (element) => element.parentId == scene.id,
    )) {
      var destination = _tour.scenes
          .firstWhere((element) => element.id == link.destinationId);

      if (destination.photo360 == null &&
          !futureMap.containsKey(destination.id)) {
        futureMap[destination.id!] = _service
            .downloadFile(destination.id!)
            .then((value) => destination.photo360 = value.data);
      }
    }

    _downloadingFuture = Future.wait(futureMap.values);
  }

  static List<Link> _getLinksForParent(Tour tour, String parentId) {
    return tour.links.where((element) => element.parentId == parentId).toList();
  }
}
