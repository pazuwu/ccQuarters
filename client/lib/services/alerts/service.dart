import 'dart:io';

import 'package:ccquarters/model/alert.dart';
import 'package:ccquarters/services/alerts/responses/get_alerts_response.dart';
import 'package:ccquarters/services/service_response.dart';
import 'package:dio/dio.dart';
import 'package:http_status_code/http_status_code.dart';

class AlertService {
  AlertService(this._dio, this._url);

  final Dio _dio;
  final String _url;
  String _token = "Bearer ";

  void setToken(String token) {
    _token = "Bearer $token";
  }

  Future<ServiceResponse<List<Alert>>> getAlerts() async {
    try {
      var response = await _dio.get(
        "$_url/alerts",
        options: Options(headers: {
          HttpHeaders.authorizationHeader: _token,
          HttpHeaders.contentTypeHeader: ContentType.json.value,
        }),
      );

      return response.statusCode == StatusCode.OK
          ? ServiceResponse(
              data: GetAlertsResponse.fromJson(response.data).alerts)
          : ServiceResponse(data: [], error: ErrorType.unknown);
    } on DioException catch (e) {
      if (e.response?.statusCode == StatusCode.UNAUTHORIZED) {
        return ServiceResponse(data: [], error: ErrorType.unauthorized);
      }

      return ServiceResponse(data: [], error: ErrorType.unknown);
    }
  }

  Future<ServiceResponse<bool>> createAlert(Alert alert) async {
    try {
      var response = await _dio.post(
        "$_url/alerts",
        data: alert.toJson(),
        options: Options(headers: {
          HttpHeaders.authorizationHeader: _token,
          HttpHeaders.contentTypeHeader: ContentType.json.value,
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

  Future<ServiceResponse<bool>> updateAlert(Alert alert) async {
    try {
      var response = await _dio.put(
        "$_url/alerts/${alert.id}",
        data: alert.toJson(),
        options: Options(headers: {
          HttpHeaders.authorizationHeader: _token,
          HttpHeaders.contentTypeHeader: ContentType.json.value,
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

  Future<ServiceResponse<bool>> deleteAlert(String alertId) async {
    try {
      var response = await _dio.delete(
        "$_url/alerts/$alertId",
        options: Options(headers: {
          HttpHeaders.authorizationHeader: _token,
          HttpHeaders.contentTypeHeader: ContentType.json.value,
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
