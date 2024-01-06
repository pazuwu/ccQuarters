import 'dart:io';
import 'dart:typed_data';

import 'package:ccquarters/services/file_service/download_progress.dart';
import 'package:ccquarters/services/file_service/file_info.dart';
import 'package:ccquarters/services/service_response.dart';
import 'package:ccquarters/model/virtual_tour/geo_point.dart';
import 'package:ccquarters/model/virtual_tour/tour_for_edit.dart';
import 'package:ccquarters/model/virtual_tour/tour_info.dart';
import 'package:ccquarters/services/file_service/file_service.dart';
import 'package:ccquarters/services/virtual_tours/requests/post_area_request.dart';
import 'package:ccquarters/services/virtual_tours/requests/post_link_request.dart';
import 'package:ccquarters/services/virtual_tours/requests/post_scene_request.dart';
import 'package:ccquarters/services/virtual_tours/requests/post_tour_request.dart';
import 'package:ccquarters/services/virtual_tours/requests/put_link_request.dart';
import 'package:ccquarters/services/virtual_tours/requests/put_tour_request.dart';
import 'package:dio/dio.dart';

import 'package:ccquarters/model/virtual_tour/link.dart';
import 'package:ccquarters/model/virtual_tour/tour.dart';
import 'package:http_status_code/http_status_code.dart';

class VTService {
  static const String _tours = "tours";
  static const String _areas = "areas";
  static const String _scenes = "scenes";
  static const String _links = "links";

  final FileService _fileService;
  final Dio _dio;
  final String _url;

  VTService(Dio dio, FileService cacheManager, String url)
      : _url = url,
        _dio = dio,
        _fileService = cacheManager;

  Future<ServiceResponse<Tour?>> getTour(String tourId) async {
    try {
      var response = await _dio.get(
        "$_url/$_tours/$tourId",
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: ContentType.json.value,
        }),
      );

      if (response.statusCode == StatusCode.OK) {
        return ServiceResponse(
          data: Tour.fromMap(response.data),
        );
      } else {
        return ServiceResponse(
          data: null,
          error: ErrorType.unknown,
        );
      }
    } on DioException catch (e) {
      return _catchCommonErrors(e, null);
    }
  }

  Future<ServiceResponse<TourForEdit?>> getTourForEdit(String tourId) async {
    try {
      var response = await _dio.get(
        "$_url/$_tours/$tourId/forEdit",
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: ContentType.json.value,
        }),
      );

      if (response.statusCode == StatusCode.OK) {
        return ServiceResponse(
          data: TourForEdit.fromMap(response.data),
        );
      } else {
        return ServiceResponse(
          data: null,
          error: ErrorType.unknown,
        );
      }
    } on DioException catch (e) {
      return _catchCommonErrors(e, null);
    }
  }

  Future<ServiceResponse<List<TourInfo>?>> getMyTours() async {
    try {
      var response = await _dio.get(
        "$_url/$_tours/my",
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: ContentType.json.value,
        }),
      );

      if (response.statusCode == StatusCode.OK) {
        return ServiceResponse(
          data: (response.data as List)
              .map<TourInfo>((e) => TourInfo.fromMap(e))
              .toList(),
        );
      } else {
        return ServiceResponse(
          data: null,
          error: ErrorType.unknown,
        );
      }
    } on DioException catch (e) {
      return _catchCommonErrors(e, null);
    }
  }

  Future<ServiceResponse<String?>> postScene(
      {required String tourId,
      required String parentId,
      required String name}) async {
    try {
      var response = await _dio.fetch(
        RequestOptions(
          method: "POST",
          headers: {
            HttpHeaders.contentTypeHeader: ContentType.json.value,
          },
          baseUrl: _url,
          path: "/$_tours/$tourId/$_scenes",
          data: PostSceneRequest(
            parentId: parentId,
            name: name,
          ).toJson(),
        ),
      );

      var id = response.headers.value("location");

      if ((response.statusCode == StatusCode.OK ||
              response.statusCode == StatusCode.CREATED) &&
          id != null) {
        return ServiceResponse(data: id);
      } else {
        return ServiceResponse(
          data: null,
          error: ErrorType.unknown,
        );
      }
    } on DioException catch (e) {
      return _catchCommonErrors(e, null);
    }
  }

  Future<ServiceResponse<bool>> deleteScene(
      String tourId, String sceneId) async {
    try {
      var response = await _dio.delete(
        "$_url/$_tours/$tourId/$_scenes/$sceneId",
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: ContentType.json.value,
        }),
      );

      if (response.statusCode == StatusCode.OK) {
        return ServiceResponse(data: true);
      } else {
        return ServiceResponse(data: false, error: ErrorType.unknown);
      }
    } on DioException catch (e) {
      return _catchCommonErrors(e, false);
    }
  }

  Future<ServiceResponse<String?>> uploadScenePhoto(
      String tourId, String sceneId, Uint8List photo) {
    return _uploadPhoto(
        "$_url/$_tours/$tourId/$_scenes/$sceneId/photo", sceneId, photo);
  }

  Future<ServiceResponse<String?>> postLink(String tourId, Link link) async {
    try {
      var response = await _dio.post(
        "$_url/$_tours/$tourId/links",
        data: PostLinkRequest(
          parentId: link.parentId,
          destinationId: link.destinationId,
          position: link.position,
          nextOrientation: link.nextOrientation,
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
        return ServiceResponse(data: id);
      } else {
        return ServiceResponse(
          data: null,
          error: ErrorType.unknown,
        );
      }
    } on DioException catch (e) {
      return _catchCommonErrors(e, null);
    }
  }

  Future<ServiceResponse<bool>> updateLink(String tourId, String linkId,
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

      return ServiceResponse(data: response.statusCode == StatusCode.OK);
    } on DioException catch (e) {
      return _catchCommonErrors(e, false);
    }
  }

  Future<ServiceResponse<bool>> deleteLink(String tourId, String linkId) async {
    try {
      var response = await _dio.delete(
        "$_url/$_tours/$tourId/$_links/$linkId",
        options: Options(headers: {}),
      );

      return ServiceResponse(data: response.statusCode == StatusCode.OK);
    } on DioException catch (e) {
      return _catchCommonErrors(e, false);
    }
  }

  Future<ServiceResponse<String?>> postArea(String tourId,
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
        return ServiceResponse(data: id);
      } else {
        return ServiceResponse(
          data: null,
          error: ErrorType.unknown,
        );
      }
    } on DioException catch (e) {
      return _catchCommonErrors(e, null);
    }
  }

  Future<ServiceResponse<List<String>?>> getAreaPhotos(
      String tourId, String areaId) async {
    try {
      var response = await _dio.get(
        "$_url/$_tours/$tourId/$_areas/$areaId/photos",
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: ContentType.json.value,
        }),
      );

      if (response.statusCode == StatusCode.OK) {
        return ServiceResponse(
          data: ((response.data as List?)?.map((e) => e as String).toList() ??
              []),
        );
      } else {
        return ServiceResponse(
          data: null,
          error: ErrorType.unknown,
        );
      }
    } on DioException catch (e) {
      return _catchCommonErrors(e, null);
    }
  }

  Future<ServiceResponse<String?>> uploadAreaPhoto(
      String tourId, String areaId, Uint8List photo,
      {void Function(int count, int total)? progressCallback}) {
    return _uploadPhoto(
        "$_url/$_tours/$tourId/$_areas/$areaId/photos", areaId, photo,
        progressCallback: progressCallback);
  }

  Future<ServiceResponse<String?>> _uploadPhoto(
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

      if (response.statusCode == StatusCode.CREATED) {
        return ServiceResponse(data: response.headers.value("location"));
      } else {
        return ServiceResponse(data: null, error: ErrorType.unknown);
      }
    } on DioException catch (e) {
      return _catchCommonErrors(e, null);
    }
  }

  Future<ServiceResponse<Uint8List?>> downloadFile(String url,
      {void Function(int count, int total)? progressCallback}) async {
    var fileStream = _fileService.getImageFile(url, withProgress: true);
    Uint8List? downloadedFile;

    var subscription = fileStream.listen((event) {
      if (event is DownloadProgress) {
        progressCallback?.call(event.downloaded, event.totalSize!);
      } else if (event is FileInfo) {
        downloadedFile = event.file;
      }
    });

    await subscription.asFuture();

    return ServiceResponse(data: downloadedFile);
  }

  Future<ServiceResponse<String?>> postOperation(
      String tourId, String areaId) async {
    try {
      final response = await _dio.post<String>(
        "$_url/$_tours/$tourId/$_areas/$areaId/process",
      );

      return ServiceResponse(data: response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == StatusCode.CONFLICT) {
        return ServiceResponse(
          data: null,
          error: ErrorType.alreadyExists,
        );
      }

      return _catchCommonErrors(e, null);
    }
  }

  Future<ServiceResponse<String?>> postTour({required String name}) async {
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
        return ServiceResponse(data: id);
      } else {
        return ServiceResponse(
          data: null,
          error: ErrorType.unknown,
        );
      }
    } on DioException catch (e) {
      return _catchCommonErrors(e, null);
    }
  }

  Future<ServiceResponse<bool>> deleteTours({required List<String> ids}) async {
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
        return ServiceResponse(data: true);
      } else {
        return ServiceResponse(
          data: false,
          error: ErrorType.unknown,
        );
      }
    } on DioException catch (e) {
      return _catchCommonErrors(e, false);
    }
  }

  Future<ServiceResponse<bool>> updateTour(String tourId,
      {String? name, String? primarySceneId}) async {
    try {
      var response = await _dio.put(
        "$_url/$_tours/$tourId",
        data: PutTourRequest(
          name: name,
          primarySceneId: primarySceneId,
        ).toJson(),
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: ContentType.json.value,
        }),
      );

      if ((response.statusCode == StatusCode.OK ||
          response.statusCode == StatusCode.CREATED)) {
        return ServiceResponse(data: true);
      } else {
        return ServiceResponse(
          data: false,
          error: ErrorType.unknown,
        );
      }
    } on DioException catch (e) {
      return _catchCommonErrors(e, false);
    }
  }

  ServiceResponse<T> _catchCommonErrors<T>(DioException e, T value) {
    var response = ServiceResponse(data: value);

    switch (e.response?.statusCode) {
      case StatusCode.UNAUTHORIZED:
        response.error = ErrorType.unauthorized;
        break;
      case StatusCode.BAD_REQUEST:
        response.error = ErrorType.badRequest;
        break;
      case StatusCode.NOT_FOUND:
        response.error = ErrorType.notFound;
        break;
      case StatusCode.GATEWAY_TIMEOUT:
        response.error = ErrorType.noInternet;
        break;
      default:
        response.error = ErrorType.unknown;
        break;
    }

    return response;
  }
}
