import 'dart:io';
import 'dart:typed_data';

import 'package:ccquarters/virtual_tour/model/geo_point.dart';
import 'package:ccquarters/virtual_tour/model/tour_info.dart';
import 'package:ccquarters/virtual_tour/service/requests/post_area_request.dart';
import 'package:ccquarters/virtual_tour/service/requests/post_link_request.dart';
import 'package:ccquarters/virtual_tour/service/requests/post_scene_request.dart';
import 'package:ccquarters/virtual_tour/service/requests/post_tour_request.dart';
import 'package:ccquarters/virtual_tour/service/requests/put_link_request.dart';
import 'package:ccquarters/virtual_tour/service/service_response.dart';
import 'package:dio/dio.dart';

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

  VTService(Dio dio, String url)
      : _url = url,
        _dio = dio;

  Future<VTServiceResponse<Tour>> getTour(String tourId) async {
    try {
      var response = await _dio.get(
        "$_url/$_tours/$tourId",
        options: Options(headers: {
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

  Future<VTServiceResponse<List<TourInfo>>> getMyTours() async {
    try {
      var response = await _dio.get(
        "$_url/$_tours/my",
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: ContentType.json.value,
        }),
      );

      if (response.statusCode == StatusCode.OK) {
        return VTServiceResponse(
            data: (response.data as List)
                .map<TourInfo>((e) => TourInfo.fromMap(e))
                .toList());
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
        options: Options(headers: {}),
      );

      return VTServiceResponse(data: response.statusCode == StatusCode.OK);
    } on DioException catch (e) {
      return _catchCommonErrors(e);
    }
  }

  Future<VTServiceResponse<String?>> postArea(String tourId,
      {String name = ""}) async {
    try {
      var response = await _dio.post(
        "$_url/$_tours/$tourId/$_areas",
        data: PostAreaRequest(
          name: name,
        ).toJson(),
        options: Options(headers: {
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
      String tourId, String areaId, Uint8List photo,
      {void Function(int count, int total)? progressCallback}) async {
    return _uploadPhoto(
        "$_url/$_tours/$tourId/$_areas/$areaId/photos", areaId, photo,
        progressCallback: progressCallback);
  }

  Future<VTServiceResponse<String?>> _uploadPhoto(
      String url, String filename, Uint8List photo,
      {void Function(int count, int total)? progressCallback}) async {
    try {
      FormData formData = FormData.fromMap({
        "file": MultipartFile.fromBytes(photo, filename: filename),
      });

      var response = await _dio.post(
        url,
        data: formData,
        onSendProgress: (int sent, int total) {
          progressCallback?.call(sent, total);
        },
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

  Future postOperation(String tourId, String areaId) async {
    try {
      final response = await _dio.post(
        "$_url/$_tours/$tourId/$_areas/$areaId/process",
      );

      return VTServiceResponse(
          data: Uint8List.fromList(response.data as List<int>));
    } on DioException catch (e) {
      if (e.response?.statusCode == StatusCode.CONFLICT) {
        return VTServiceResponse(error: ErrorType.alreadyExists);
      }

      return _catchCommonErrors(e);
    }
  }

  Future<VTServiceResponse<String>> postTour({required String name}) async {
    try {
      var request = PostTourRequest(name: name);

      var response = await _dio.post(
        "$_url/$_tours",
        data: request.toJson(),
        options: Options(headers: {
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

  Future<VTServiceResponse<bool>> deleteTours(
      {required List<String> ids}) async {
    try {
      var response = await _dio.delete(
        "$_url/$_tours",
        data: ids,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: ContentType.json.value,
        }),
      );

      if ((response.statusCode == StatusCode.OK ||
          response.statusCode == StatusCode.CREATED)) {
        return VTServiceResponse(data: true);
      } else {
        return VTServiceResponse(error: ErrorType.unknown);
      }
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
