import 'package:dio/dio.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:http_status_code/http_status_code.dart';

import 'mock_data.dart';

extension UsersAPIMock on Dio {
  static Dio createUsersApiMock(String url) {
    Dio dio = Dio();
    final dioAdapter = DioAdapter(dio: dio);

    dioAdapter.onGet("$url/$mockId", (request) {
      request.reply(StatusCode.OK, mockUser.toJson());
    }, data: Matchers.any);

    dioAdapter.onPut("$url/$mockId", (request) {
      request.reply(StatusCode.OK, null);
    }, data: Matchers.any);

    dioAdapter.onPut("$url/$mockId/delete", (request) {
      request.reply(StatusCode.OK, null);
    }, data: Matchers.any);

    dioAdapter.onPut("$url/$mockId/photo", (request) {
      request.reply(StatusCode.OK, null);
    }, data: Matchers.any);

    return dio;
  }
}
