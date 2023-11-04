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
  String _token =
      "Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6ImQ0OWU0N2ZiZGQ0ZWUyNDE0Nzk2ZDhlMDhjZWY2YjU1ZDA3MDRlNGQiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL3NlY3VyZXRva2VuLmdvb2dsZS5jb20vY2NxdWFydGVyc21pbmkiLCJhdWQiOiJjY3F1YXJ0ZXJzbWluaSIsImF1dGhfdGltZSI6MTY5ODk2Nzk1MCwidXNlcl9pZCI6IjI0RXNmWEJYc0hjc2pMOHJCcHhlS2dQOFRNWjIiLCJzdWIiOiIyNEVzZlhCWHNIY3NqTDhyQnB4ZUtnUDhUTVoyIiwiaWF0IjoxNjk4OTY3OTUwLCJleHAiOjE2OTg5NzE1NTAsImVtYWlsIjoidnRAdGVzdC5wbCIsImVtYWlsX3ZlcmlmaWVkIjpmYWxzZSwiZmlyZWJhc2UiOnsiaWRlbnRpdGllcyI6eyJlbWFpbCI6WyJ2dEB0ZXN0LnBsIl19LCJzaWduX2luX3Byb3ZpZGVyIjoicGFzc3dvcmQifX0.feaOfDnbp9hAoBhsRU8aKu0cuejvpWL8Lq8zc7fjSdpRcskNlUJKEVE-TpN0C4yLImhT89YSUdTuKB8lmafBe5fLYTd3jm4WGt-qCtmI8AMjO8aGupHPKmXgpf2xLgu19ZE7_w25K8N2JsApG9u2hWol_PDT-_lcTdllm5kiQqNCNjch4O08XHpiS3ChXwuzsNvifRwWf_Hkvoz7egK8kQSjeyKgEQJ1PbTatGl_2f87kIRR3osf8OBo0H93R7S9XRDqLPPkEYpar2kuEhsKP4Q8sDU9riNTR7oLKUHXu0UwGGPD0pixGUGIC63Aobn_xR8KubFb5pllax8sOAN78g";
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
      return _catchCommonErrors(e);
    }
  }

  Future<VTServiceResponse<String?>> postScene(
      {required String tourId,
      required String parentId,
      required String name}) async {
    try {
      var response = await _dio.post(
        "$_url/$_tours/$tourId/$_scenes",
        data: PostSceneRequest(
          parentId: parentId,
        ).toJson(),
        options: Options(headers: {
          HttpHeaders.authorizationHeader: _token,
          HttpHeaders.contentTypeHeader: ContentType.json.value,
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
      return _catchCommonErrors(e);
    }
  }

  Future<VTServiceResponse<String?>> uploadScenePhoto(
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
          longitude: link.position.longitude,
          latitude: link.position.latitude,
          text: link.text,
        ).toJson(),
        options: Options(headers: {
          HttpHeaders.authorizationHeader: _token,
          HttpHeaders.contentTypeHeader: ContentType.json.value,
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
      return _catchCommonErrors(e);
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
          HttpHeaders.contentTypeHeader: ContentType.json.value,
        }),
      );

      return VTServiceResponse(data: response.statusCode == StatusCode.OK);
    } on DioException catch (e) {
      return _catchCommonErrors(e);
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
      return _catchCommonErrors(e);
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
          HttpHeaders.contentTypeHeader: ContentType.json.value,
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
      return _catchCommonErrors(e);
    }
  }

  Future<VTServiceResponse<String?>> uploadAreaPhoto(
      String tourId, String areaId, Uint8List photo) async {
    return _uploadPhoto(
        "$_url/$_tours/$tourId/$_areas/$areaId/photo", areaId, photo);
  }

  Future<VTServiceResponse<String?>> _uploadPhoto(
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

      var createdUrl = response.headers.value("location");

      return VTServiceResponse(data: createdUrl);
    } on DioException catch (e) {
      return _catchCommonErrors(e);
    }
  }

  Future<VTServiceResponse<Uint8List>> downloadFile(String url,
      {void Function(int count, int total)? progressCallback}) async {
    try {
      final response =
          await _dio.get(url, onReceiveProgress: (received, total) {
        progressCallback?.call(received, total);
      }, options: Options(responseType: ResponseType.bytes));

      return VTServiceResponse(
          data: Uint8List.fromList(response.data as List<int>));
    } on DioException catch (e) {
      return _catchCommonErrors(e);
    }
  }

  VTServiceResponse<T> _catchCommonErrors<T>(DioException e) {
    if (e.response?.statusCode == StatusCode.UNAUTHORIZED) {
      return VTServiceResponse(error: ErrorType.unauthorized);
    } else if (e.response?.statusCode == StatusCode.BAD_REQUEST) {
      return VTServiceResponse(error: ErrorType.badRequest);
    } else if (e.response?.statusCode == StatusCode.NOT_FOUND) {
      return VTServiceResponse(error: ErrorType.notFound);
    }

    return VTServiceResponse(error: ErrorType.unknown);
  }
}
