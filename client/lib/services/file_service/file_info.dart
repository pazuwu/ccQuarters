import 'dart:io';

import 'package:ccquarters/services/file_service/file_response.dart';

class FileInfo extends FileResponse {
  const FileInfo(this.file, String originalUrl) : super(originalUrl);

  final File file;
}
