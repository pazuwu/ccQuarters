import 'package:ccquarters/services/file_service/file_response.dart';
import 'package:flutter/foundation.dart';

class FileInfo extends FileResponse {
  const FileInfo(this.file, String originalUrl) : super(originalUrl);

  final Uint8List file;
}
