import 'dart:io';

import 'package:ccquarters/model/alert.dart';
import 'package:ccquarters/model/new_alert.dart';
import 'package:ccquarters/services/alerts/responses/get_alerts_response.dart';
import 'package:ccquarters/services/service_response.dart';
import 'package:dio/dio.dart';
import 'package:http_status_code/http_status_code.dart';

class AlertService {
  AlertService(this._dio, this._url);

  final Dio _dio;
  final String _url;

  Future<ServiceResponse<List<Alert>>> getAlerts(
      {int pageNumber = 0, int pageCount = 10}) async {
    try {
      var response = await _dio.get(
        _url,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: ContentType.json.value,
        }),
        queryParameters: {
          "pageNumber": pageNumber,
          "pageSize": pageCount,
        },
      );

      return response.statusCode == StatusCode.OK
          ? ServiceResponse(
              data: GetAlertsResponse.fromJson(response.data).data)
          : ServiceResponse(data: [], error: ErrorType.unknown);
    } on DioException catch (e) {
      if (e.response?.statusCode == StatusCode.UNAUTHORIZED) {
        return ServiceResponse(data: [], error: ErrorType.unauthorized);
      }

      return ServiceResponse(data: [], error: ErrorType.unknown);
    }
  }

  Future<ServiceResponse<bool>> createAlert(NewAlert alert) async {
    try {
      var alertJson = alert.toJson();
      var response = await _dio.post(
        _url,
        data: alertJson,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: ContentType.json.value,
        }),
      );

      return response.statusCode == StatusCode.CREATED
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
        "$_url/${alert.id}",
        data: alert.toJson(),
        options: Options(headers: {
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
        "$_url/$alertId",
        options: Options(headers: {
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
