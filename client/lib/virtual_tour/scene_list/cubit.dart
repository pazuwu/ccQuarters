import 'dart:io';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ccquarters/virtual_tour/model/area.dart';
import 'package:ccquarters/virtual_tour/model/scene.dart';
import 'package:ccquarters/virtual_tour/model/tour.dart';
import 'package:ccquarters/virtual_tour/service/service.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class VTScenesState extends Equatable {
  @override
  List<Object?> get props => [];
}

class VTScenesUploadingState extends VTScenesState {
  VTScenesUploadingState({required this.progress});

  final double progress;

  @override
  List<Object?> get props => [progress];
}

class VTScenesCubit extends Cubit<VTScenesState> {
  VTScenesCubit(
    this._service,
    this._tour,
  ) : super(VTScenesState());

  final VTService _service;
  final Tour _tour;

  Future createNewSceneFromPhoto(String path, {required String name}) async {
    var serviceResponse =
        await _service.postScene(tourId: _tour.id, parentId: "", name: name);

    if (serviceResponse.data != null) {
      var result = await FlutterImageCompress.compressWithFile(
        path,
        minHeight: 1920,
        minWidth: 1080,
        quality: 98,
        format: CompressFormat.png,
      );

      var url = await _uploadScenePhoto(serviceResponse.data!, result!);

      var newScene =
          Scene(name: name, photo360Url: url, id: serviceResponse.data!);
      _tour.scenes.add(newScene);

      emit(VTScenesState());
    }
  }

  Future<Area?> createNewAreaFromPhotos(List<String?> paths,
      {required String name}) async {
    var response = await _service.postArea(_tour.id, name: name);

    if (response.data != null) {
      var index = 0;
      for (var path in paths) {
        if (path != null) {
          var file = await File(path).readAsBytes();

          await _uploadAreaPhoto(response.data!, file,
              progressCallback: (count, total) {
            emit(VTScenesUploadingState(
              progress:
                  count * 1 / paths.length / total + index * 1 / paths.length,
            ));
          });

          index++;
        }
      }

      await _service.postOperation(_tour.id, response.data!);
      emit(VTScenesState());
    }

    return Area(
      id: response.data!,
    );
  }

  Future _uploadScenePhoto(String sceneId, Uint8List photoBytes) async {
    await _service.uploadScenePhoto(_tour.id, sceneId, photoBytes);
  }

  Future _uploadAreaPhoto(String areaId, Uint8List photoBytes,
      {void Function(int count, int total)? progressCallback}) async {
    await _service.uploadAreaPhoto(
      _tour.id,
      areaId,
      photoBytes,
      progressCallback: progressCallback,
    );
  }
}
