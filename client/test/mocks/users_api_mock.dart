import 'package:ccquarters/model/users/user.dart';
import 'package:dio/dio.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:http_status_code/http_status_code.dart';

extension UsersAPIMock on Dio {
  static Dio createUsersApiMock(String url) {
    Dio dio = Dio();
    final dioAdapter = DioAdapter(dio: dio);
    const id = "cb849fa2-1033-4d6b-7c88-08db36d6f10f";

    dioAdapter.onGet("$url/$id", (request) {
      var res = User(id, "Jan", "Kowalski", null, "j.kowalski@gmail.com",
          "123456789", null, DateTime.now());

      request.reply(StatusCode.OK, res.toJson());
    }, data: Matchers.any);

    dioAdapter.onPut("$url/$id", (request) {
      request.reply(StatusCode.OK, null);
    }, data: Matchers.any);

    dioAdapter.onPut("$url/$id/delete", (request) {
      request.reply(StatusCode.OK, null);
    }, data: Matchers.any);

    dioAdapter.onPut("$url/$id/photo", (request) {
      request.reply(StatusCode.OK, null);
    }, data: Matchers.any);

    return dio;
  }
}
