import 'dart:async';

import 'package:ccquarters/services/file_service/download_progress.dart';
import 'package:ccquarters/services/file_service/file_info.dart';
import 'package:ccquarters/services/file_service/file_response.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart' as cm;

abstract class FileService {
  Stream<FileResponse> getImageFile(
    String url, {
    String? key,
    Map<String, String>? headers,
    bool withProgress = false,
    int? maxHeight,
    int? maxWidth,
  });
}

class CacheManagerFileService extends FileService {
  final cm.ImageCacheManager _cacheManager = cm.DefaultCacheManager();

  @override
  Stream<FileResponse> getImageFile(
    String url, {
    String? key,
    Map<String, String>? headers,
    bool withProgress = false,
    int? maxHeight,
    int? maxWidth,
  }) async* {
    var streamSubscription = _cacheManager.getImageFile(url,
        key: key,
        headers: headers,
        withProgress: withProgress,
        maxHeight: maxHeight,
        maxWidth: maxWidth);

    var streamController = StreamController<FileResponse>.broadcast();

    streamSubscription.listen((event) async {
      if (event is cm.DownloadProgress) {
        streamController.add(DownloadProgress(
            event.originalUrl, event.totalSize, event.downloaded));
      } else if (event is cm.FileInfo) {
        var fileBytes = await event.file.readAsBytes();
        streamController.add(FileInfo(fileBytes, event.originalUrl));
        streamController.close();
      }
    });

    yield* streamController.stream;
  }
}
