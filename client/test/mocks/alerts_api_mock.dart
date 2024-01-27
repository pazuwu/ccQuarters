import 'package:ccquarters/services/alerts/responses/get_alerts_response.dart';
import 'package:dio/dio.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:http_status_code/http_status_code.dart';

import 'mock_data.dart';

extension AlertsAPIMock on Dio {
  static Dio createAlertsApiMock(String url) {
    Dio dio = Dio();
    final dioAdapter = DioAdapter(dio: dio);

    dioAdapter.onGet("$url/$mockId", (request) {
      var res = GetAlertsResponse(
        data: [mockAlert, mockAlert, mockAlert],
        pageNumber: 1,
        pageSize: 10,
      );
      request.reply(StatusCode.OK, res.toJson());
    }, data: Matchers.any);

    dioAdapter.onPost(url, (request) {
      request.reply(StatusCode.CREATED, null);
    }, data: Matchers.any);

    dioAdapter.onPut("$url/$mockId", (request) {
      request.reply(StatusCode.OK, null);
    }, data: Matchers.any);

    dioAdapter.onDelete("$url/$mockId", (request) {
      request.reply(StatusCode.OK, null);
    }, data: Matchers.any);

    return dio;
  }
}
