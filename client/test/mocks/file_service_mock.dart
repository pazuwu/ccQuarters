import 'dart:async';

import 'package:ccquarters/services/file_service/file_info.dart';
import 'package:ccquarters/services/file_service/file_response.dart';
import 'package:ccquarters/services/file_service/file_service.dart';
import 'package:flutter/foundation.dart';

class FileServiceMock implements FileService {
  @override
  Stream<FileResponse> getImageFile(
    String url, {
    String? key,
    Map<String, String>? headers,
    bool withProgress = false,
    int? maxHeight,
    int? maxWidth,
  }) async* {
    var streamController = StreamController<FileResponse>.broadcast();
    streamController.add(FileInfo(Uint8List.fromList([]), url));
    await streamController.close();
    yield* streamController.stream;
  }
}
