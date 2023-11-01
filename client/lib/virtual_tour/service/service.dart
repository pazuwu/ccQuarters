import 'dart:io';
import 'dart:typed_data';

import 'package:ccquarters/virtual_tour/model/geo_point.dart';
import 'package:ccquarters/virtual_tour/service/requests/post_area_request.dart';
import 'package:ccquarters/virtual_tour/service/requests/post_link_request.dart';
import 'package:ccquarters/virtual_tour/service/requests/post_scene_request.dart';
import 'package:ccquarters/virtual_tour/service/requests/put_link_request.dart';
import 'package:ccquarters/virtual_tour/service/service_response.dart';
import 'package:dio/dio.dart';

import 'package:ccquarters/virtual_tour/model/area.dart';
import 'package:ccquarters/virtual_tour/model/link.dart';
import 'package:ccquarters/virtual_tour/model/tour.dart';
import 'package:http_status_code/http_status_code.dart';

class VTService {
  static const String _tours = "tours";
  static const String _areas = "areas";
  static const String _scenes = "scenes";
  static const String _links = "links";

  final Dio _dio;
  final String _url;
  String _token = "Bearer ";

  VTService({
    required dio,
    required url,
  })  : _url = url,
        _dio = dio;

  void setToken(String token) {
    _token = "Bearer $token";
  }

  Future<VTServiceResponse<Tour>> getTour(String tourId) async {
    try {
      var response = await _dio.get(
        "$_url/$_tours/$tourId",
        options: Options(headers: {
          HttpHeaders.authorizationHeader: _token,
          HttpHeaders.contentTypeHeader: ContentType.json.value,
        }),
      );

      if (response.statusCode == StatusCode.OK) {
        return VTServiceResponse(data: Tour.fromMap(response.data));
      } else {
        return VTServiceResponse(error: ErrorType.unknown);
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == StatusCode.UNAUTHORIZED) {
        return VTServiceResponse(error: ErrorType.unauthorized);
      } else if (e.response?.statusCode == StatusCode.NOT_FOUND) {
        return VTServiceResponse(error: ErrorType.notFound);
      }

      return VTServiceResponse(error: ErrorType.unknown);
    }
  }

  Future<VTServiceResponse<String?>> postScene(
      String tourId, String parentId) async {
    try {
      var response = await _dio.post(
        "$_url/$_tours/$tourId/$_scenes",
        data: PostSceneRequest(
          parentId: parentId,
        ).toJson(),
        options: Options(headers: {
          HttpHeaders.authorizationHeader: _token,
          HttpHeaders.contentTypeHeader: ContentType.json,
        }),
      );

      var id = response.headers.value("location");

      if ((response.statusCode == StatusCode.OK ||
              response.statusCode == StatusCode.CREATED) &&
          id != null) {
        return VTServiceResponse(data: id);
      } else {
        return VTServiceResponse(error: ErrorType.unknown);
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == StatusCode.UNAUTHORIZED) {
        return VTServiceResponse(error: ErrorType.unauthorized);
      } else if (e.response?.statusCode == StatusCode.BAD_REQUEST) {
        return VTServiceResponse(error: ErrorType.badRequest);
      }

      return VTServiceResponse(error: ErrorType.unknown);
    }
  }

  Future<VTServiceResponse<bool>> uploadScenePhoto(
      String tourId, String sceneId, Uint8List photo) async {
    return _uploadPhoto(
        "$_url/$_tours/$tourId/$_scenes/$sceneId/photo", sceneId, photo);
  }

  Future<VTServiceResponse<String?>> postLink(String tourId, Link link) async {
    try {
      var response = await _dio.post(
        "$_url/$_tours/$tourId/links",
        data: PostLinkRequest(
          parentId: link.parentId,
          destinationId: link.destinationId,
          nextOrientation: link.nextOrientation,
          position: link.position,
          text: link.text,
        ).toJson(),
        options: Options(headers: {
          HttpHeaders.authorizationHeader: _token,
          HttpHeaders.contentTypeHeader: ContentType.json,
        }),
      );

      var id = response.headers.value("location");

      if ((response.statusCode == StatusCode.OK ||
              response.statusCode == StatusCode.CREATED) &&
          id != null) {
        return VTServiceResponse(data: id);
      } else {
        return VTServiceResponse(error: ErrorType.unknown);
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == StatusCode.UNAUTHORIZED) {
        return VTServiceResponse(error: ErrorType.unauthorized);
      } else if (e.response?.statusCode == StatusCode.BAD_REQUEST) {
        return VTServiceResponse(error: ErrorType.badRequest);
      }

      return VTServiceResponse(error: ErrorType.unknown);
    }
  }

  Future<VTServiceResponse<bool>> updateLink(String tourId, String linkId,
      {String? destinationId,
      GeoPoint? nextOrientation,
      GeoPoint? position,
      String? text}) async {
    try {
      var response = await _dio.put(
        "$_url/$_tours/$tourId/$_links/$linkId",
        data: PutLinkRequest(
          destinationId: destinationId,
          nextOrientation: nextOrientation,
          position: position,
          text: text,
        ).toJson(),
        options: Options(headers: {
          HttpHeaders.authorizationHeader: _token,
          HttpHeaders.contentTypeHeader: ContentType.json,
        }),
      );

      return VTServiceResponse(data: response.statusCode == StatusCode.OK);
    } on DioException catch (e) {
      {
        if (e.response?.statusCode == StatusCode.UNAUTHORIZED) {
          return VTServiceResponse(data: false, error: ErrorType.unauthorized);
        } else if (e.response?.statusCode == StatusCode.BAD_REQUEST) {
          return VTServiceResponse(data: false, error: ErrorType.badRequest);
        }

        return VTServiceResponse(data: false, error: ErrorType.unknown);
      }
    }
  }

  Future<VTServiceResponse<bool>> deleteLink(
      String tourId, String linkId) async {
    try {
      var response = await _dio.delete(
        "$_url/$_tours/$tourId/$_links/$linkId",
        options: Options(headers: {
          HttpHeaders.authorizationHeader: _token,
        }),
      );

      return VTServiceResponse(data: response.statusCode == StatusCode.OK);
    } on DioException catch (e) {
      {
        if (e.response?.statusCode == StatusCode.UNAUTHORIZED) {
          return VTServiceResponse(data: false, error: ErrorType.unauthorized);
        } else if (e.response?.statusCode == StatusCode.BAD_REQUEST) {
          return VTServiceResponse(data: false, error: ErrorType.badRequest);
        }

        return VTServiceResponse(data: false, error: ErrorType.unknown);
      }
    }
  }

  Future<VTServiceResponse<String?>> postArea(String tourId, Area area) async {
    try {
      var response = await _dio.post(
        "$_url/$_tours/$tourId/$_areas",
        data: PostAreaRequest(
          name: area.name,
        ).toJson(),
        options: Options(headers: {
          HttpHeaders.authorizationHeader: _token,
          HttpHeaders.contentTypeHeader: ContentType.json,
        }),
      );

      var id = response.headers.value("location");

      if ((response.statusCode == StatusCode.OK ||
              response.statusCode == StatusCode.CREATED) &&
          id != null) {
        return VTServiceResponse(data: id);
      } else {
        return VTServiceResponse(error: ErrorType.unknown);
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == StatusCode.UNAUTHORIZED) {
        return VTServiceResponse(error: ErrorType.unauthorized);
      } else if (e.response?.statusCode == StatusCode.BAD_REQUEST) {
        return VTServiceResponse(error: ErrorType.badRequest);
      }

      return VTServiceResponse(error: ErrorType.unknown);
    }
  }

  Future<VTServiceResponse<bool>> uploadAreaPhoto(
      String tourId, String areaId, Uint8List photo) async {
    return _uploadPhoto(
        "$_url/$_tours/$tourId/$_areas/$areaId/photo", areaId, photo);
  }

  Future<VTServiceResponse<bool>> _uploadPhoto(
      String url, String filename, Uint8List photo) async {
    try {
      FormData formData = FormData.fromMap({
        "file": MultipartFile.fromBytes(photo, filename: filename),
      });

      var response = await _dio.post(
        url,
        data: formData,
        options: Options(headers: {
          HttpHeaders.authorizationHeader: _token,
        }),
      );

      return VTServiceResponse(data: response.statusCode == StatusCode.OK);
    } on DioException catch (e) {
      if (e.response?.statusCode == StatusCode.UNAUTHORIZED) {
        return VTServiceResponse(data: false, error: ErrorType.unauthorized);
      }

      return VTServiceResponse(data: false, error: ErrorType.unknown);
    }
  }
}
