import 'package:ccquarters/model/user.dart';
import 'package:ccquarters/services/service_response.dart';
import 'package:dio/dio.dart';
import 'package:http_status_code/http_status_code.dart';

import 'requests/update_user_request.dart';

class UserService {
  UserService(this._dio, this._url);

  final Dio _dio;
  final String _url;
  String _token = "Bearer ";

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
