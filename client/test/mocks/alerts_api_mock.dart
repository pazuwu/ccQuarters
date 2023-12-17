import 'package:ccquarters/model/alert.dart';
import 'package:ccquarters/services/alerts/responses/get_alerts_response.dart';
import 'package:dio/dio.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:http_status_code/http_status_code.dart';

extension AlertsAPIMock on Dio {
  static Dio createAlertsApiMock(String url) {
    Dio dio = Dio();
    final dioAdapter = DioAdapter(dio: dio);
    const id = "cb849fa2-1033-4d6b-7c88-08db36d6f10f";
    Alert alert = Alert(
      id: id,
      cities: ["Warszawa"],
      maxPrice: 1000000,
    );

    dioAdapter.onGet("$url/$id", (request) {
      var res = GetAlertsResponse(
        data: [alert, alert, alert],
        pageNumber: 1,
        pageSize: 10,
      );
      request.reply(StatusCode.OK, res.toJson());
    }, data: Matchers.any);

    dioAdapter.onPost(url, (request) {
      request.reply(StatusCode.OK, null);
    }, data: Matchers.any);

    dioAdapter.onPut("$url/$id", (request) {
      request.reply(StatusCode.OK, null);
    }, data: Matchers.any);

    dioAdapter.onDelete("$url/$id", (request) {
      request.reply(StatusCode.OK, null);
    }, data: Matchers.any);

    return dio;
  }
}
