import 'dart:io';

import 'package:ccquarters/model/users/user.dart';
import 'package:ccquarters/services/service_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:http_status_code/http_status_code.dart';

import 'requests/update_user_request.dart';

class UserService {
  UserService(this._dio, this._url);

  final Dio _dio;
  final String _url;

  Future<ServiceResponse<User>> getUser(String userId) async {
    try {
      var response = await _dio.get(
        "$_url/$userId",
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: ContentType.json.value,
        }),
      );

      return response.statusCode == StatusCode.OK
          ? ServiceResponse(data: User.fromJson(response.data))
          : ServiceResponse(data: User.empty(), error: ErrorType.unknown);
    } on DioException catch (e) {
      if (e.response?.statusCode == StatusCode.UNAUTHORIZED) {
        return ServiceResponse(
            data: User.empty(), error: ErrorType.unauthorized);
      }

      return ServiceResponse(data: User.empty(), error: ErrorType.unknown);
    }
  }

  Future<ServiceResponse<bool>> updateUser(String userId, User user,
      {String? token}) async {
    try {
      var response = await _dio.put(
        "$_url/$userId",
        data: UpdateUserRequest.fromUser(user).toJson(),
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

  Future<ServiceResponse<bool>> deleteUser(String userId) async {
    try {
      var response = await _dio.put(
        "$_url/$userId/delete",
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

  Future<ServiceResponse<bool>> changePhoto(
      String userId, Uint8List photo) async {
    try {
      FormData photoData = FormData.fromMap({
        "file": MultipartFile.fromBytes(photo, filename: userId),
      });

      var response = await _dio.post(
        "$_url/$userId/photo",
        data: photoData,
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

  Future<ServiceResponse<bool>> deletePhoto(String userId) async {
    try {
      var response = await _dio.put(
        "$_url/$userId/photo/delete",
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
