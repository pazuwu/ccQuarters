import 'package:ccquarters/services/file_service/file_response.dart';

class DownloadProgress extends FileResponse {
  const DownloadProgress(String originalUrl, this.totalSize, this.downloaded)
      : super(originalUrl);

  final int? totalSize;
  final int downloaded;
}
