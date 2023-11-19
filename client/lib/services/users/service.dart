import 'package:ccquarters/model/user.dart';
import 'package:ccquarters/services/service_response.dart';
import 'package:dio/dio.dart';
import 'package:http_status_code/http_status_code.dart';

import 'requests/update_user_request.dart';

class UserService {
  UserService(this._dio, this._url);

  final Dio _dio;
  final String _url;
  String _token =
      "Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6IjQ0ZmJkZTdhZGY0ZTU3YWYxZWE4MzAzNmJmZjdkMzUxNTk3ZTMzNWEiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL3NlY3VyZXRva2VuLmdvb2dsZS5jb20vY2NxdWFydGVyc21pbmkiLCJhdWQiOiJjY3F1YXJ0ZXJzbWluaSIsImF1dGhfdGltZSI6MTcwMDA3MTU2MCwidXNlcl9pZCI6IjI0RXNmWEJYc0hjc2pMOHJCcHhlS2dQOFRNWjIiLCJzdWIiOiIyNEVzZlhCWHNIY3NqTDhyQnB4ZUtnUDhUTVoyIiwiaWF0IjoxNzAwMDcxNTYwLCJleHAiOjE3MDAwNzUxNjAsImVtYWlsIjoidnRAdGVzdC5wbCIsImVtYWlsX3ZlcmlmaWVkIjpmYWxzZSwiZmlyZWJhc2UiOnsiaWRlbnRpdGllcyI6eyJlbWFpbCI6WyJ2dEB0ZXN0LnBsIl19LCJzaWduX2luX3Byb3ZpZGVyIjoicGFzc3dvcmQifX0.DItlRbdcrJez09LuitJTeKig24U62Xw_yJhyYXLvWK7NDKiTeDUURJPfy7dZtscCa4mG53MSms4XaP_YQYDxCtut0e45qmrtr8_x69HcMFK6w2zSzd9lCXsjgYImTD6AEx_Flj0m--zVm44vpAD5IBYKPNvWnauAYbGVfJzfRtdTOtrnajrK2IirkoOHb0r5c18cvrX8Y-hPx6r2c2MXoCEs_AaOXW7VitbxqTLQ9orgbDPINpFiagTu0XGHwcshjmJxlit4jpWzUNdLcKcDwEGmKyQWIiONHK5xan3yOqFfqMQUNLK-k8yjDueXi2d_juTEoTcD-HhIonKfsKw0WA";

  void setToken(String token) {
    _token = "Bearer $token";
  }

  Future<ServiceResponse<bool>> updateUser(String userId, User user) async {
    try {
      var response = await _dio.put(
        "$_url/users/$userId",
        data: UpdateUserRequest(
          name: user.name,
          surname: user.surname,
          company: user.company,
          email: user.email,
          phoneNumber: user.phoneNumber,
        ).toJson(),
        options: Options(headers: {
          "Authorization": _token,
          "HttpHeaders.contentTypeHeader": "application/json",
        }),
      );

      return response.statusCode == StatusCode.OK
          ? ServiceResponse(data: true)
          : ServiceResponse(data: false, error: ErrorType.unknown);
    } on DioException catch (e) {
      if (e.response?.statusCode == StatusCode.UNAUTHORIZED) {
        return ServiceResponse(data: false, error: ErrorType.unauthorized);
      }

      return ServiceResponse(data: false, error: ErrorType.unknown);
    }
  }
}
