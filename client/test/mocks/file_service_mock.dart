import 'dart:async';
import 'dart:io';

import 'package:ccquarters/services/file_service/file_info.dart';
import 'package:ccquarters/services/file_service/file_response.dart';
import 'package:ccquarters/services/file_service/file_service.dart';

class FileServiceMock extends FileService {
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
    streamController.add(FileInfo(File(""), url));
    await streamController.close();
    yield* streamController.stream;
  }
}
