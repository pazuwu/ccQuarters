import 'dart:io';

import 'package:ccquarters/model/filter.dart';
import 'package:ccquarters/model/house.dart';
import 'package:ccquarters/services/houses/data/houses_filter.dart';
import 'package:ccquarters/services/houses/responses/get_house_response.dart';
import 'package:ccquarters/services/service_response.dart';
import 'package:dio/dio.dart';
import 'package:http_status_code/http_status_code.dart';

import 'requests/get_houses_request_body.dart';
import 'responses/get_houses_response.dart';

class HouseService {
  HouseService(this._dio, this._url);

  final Dio _dio;
  final String _url;
  String _token = "Bearer ";

  void setToken(String token) {
    _token = "Bearer $token";
  }

  Future<ServiceResponse<List<House>>> getHouses(
      {int pageNumber = 0, int pageCount = 10, HouseFilter? filter}) async {
    try {
      var response = await _dio.put(
        _url,
        options: Options(headers: {
          HttpHeaders.authorizationHeader: _token,
          HttpHeaders.contentTypeHeader: ContentType.json.value,
        }),
        data: GetHousesRequestBody(filter?.sortBy,
                filter != null ? HousesFilter.fromHouseFilter(filter) : null)
            .toJson(),
        queryParameters: {
          "pageNumber": pageNumber,
          "pageCount": pageCount,
        },
      );

      return response.statusCode == StatusCode.OK
          ? ServiceResponse(
              data: GetHousesResponse.fromJson(response.data)
                  .houses
                  .map((x) => x.toHouse())
                  .toList())
          : ServiceResponse(data: [], error: ErrorType.unknown);
    } on DioException catch (e) {
      if (e.response?.statusCode == StatusCode.UNAUTHORIZED) {
        return ServiceResponse(data: [], error: ErrorType.unauthorized);
      }

      return ServiceResponse(data: [], error: ErrorType.unknown);
    }
  }

  Future<ServiceResponse<List<House>>> getLikedHouses(
      {int pageNumber = 0, int pageCount = 10}) async {
    try {
      var response = await _dio.put(
        "$_url/liked",
        options: Options(headers: {
          HttpHeaders.authorizationHeader: _token,
          HttpHeaders.contentTypeHeader: ContentType.json.value,
        }),
        queryParameters: {
          "pageNumber": pageNumber,
          "pageCount": pageCount,
        },
      );

      return response.statusCode == StatusCode.OK
          ? ServiceResponse(
              data: GetHousesResponse.fromJson(response.data)
                  .houses
                  .map((x) => x.toHouse())
                  .toList())
          : ServiceResponse(data: [], error: ErrorType.unknown);
    } on DioException catch (e) {
      if (e.response?.statusCode == StatusCode.UNAUTHORIZED) {
        return ServiceResponse(data: [], error: ErrorType.unauthorized);
      }

      return ServiceResponse(data: [], error: ErrorType.unknown);
    }
  }

  Future<ServiceResponse<List<House>>> getMyHouses(
      {int pageNumber = 0, int pageCount = 10}) async {
    try {
      var response = await _dio.put(
        "$_url/my",
        options: Options(headers: {
          HttpHeaders.authorizationHeader: _token,
          HttpHeaders.contentTypeHeader: ContentType.json.value,
        }),
        queryParameters: {
          "pageNumber": pageNumber,
          "pageCount": pageCount,
        },
      );

      return response.statusCode == StatusCode.OK
          ? ServiceResponse(
              data: GetHousesResponse.fromJson(response.data)
                  .houses
                  .map((x) => x.toHouse())
                  .toList())
          : ServiceResponse(data: [], error: ErrorType.unknown);
    } on DioException catch (e) {
      if (e.response?.statusCode == StatusCode.UNAUTHORIZED) {
        return ServiceResponse(data: [], error: ErrorType.unauthorized);
      }

      return ServiceResponse(data: [], error: ErrorType.unknown);
    }
  }

  Future<ServiceResponse<House?>> getHouse(String houseId) async {
    try {
      var response = await _dio.put(
        "$_url/$houseId",
        options: Options(headers: {
          HttpHeaders.authorizationHeader: _token,
          HttpHeaders.contentTypeHeader: ContentType.json.value,
        }),
      );

      if (response.statusCode == StatusCode.OK) {
        var data = GetHouseResponse.fromJson(response.data);
        return ServiceResponse(data: data.house.toHouse(data.photoUrls));
      }
      return ServiceResponse(data: null, error: ErrorType.unknown);
    } on DioException catch (e) {
      if (e.response?.statusCode == StatusCode.UNAUTHORIZED) {
        return ServiceResponse(data: null, error: ErrorType.unauthorized);
      }

      return ServiceResponse(data: null, error: ErrorType.unknown);
    }
  }
}
