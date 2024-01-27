import 'package:dio/dio.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:http_status_code/http_status_code.dart';

import 'mock_data.dart';

extension VTAPIMock on Dio {
  static Dio createVTApiMock(String url) {
    Dio dio = Dio();
    final dioAdapter = DioAdapter(dio: dio);
    final areas = [
      mockArea,
      mockArea,
      mockArea,
    ];
    final scenes = [mockScene, mockScene2];
    final links = [mockLink, mockLink];
    final tourMap = <String, dynamic>{
      'name': 'Test tour',
      'ownerId': mockId,
      'id': mockId,
      'areas': areas.map((x) => x.toMap()).toList(),
      'scenes': scenes.map((x) => x.toMap()).toList(),
      'links': links.map((x) => x.toMap()).toList(),
    };
    final photos = [1, 2, 3, 4];

    dioAdapter.onGet("$url/tours/$mockId", (request) {
      request.reply(StatusCode.OK, tourMap);
    }, data: Matchers.any);

    dioAdapter.onPut("$url/tours/$mockId", (request) {
      request.reply(StatusCode.OK, null);
    }, data: Matchers.any);

    dioAdapter.onGet("$url/tours/$mockId/forEdit", (request) {
      request.reply(StatusCode.OK, tourMap);
    }, data: Matchers.any);

    dioAdapter.onPost("$url/tours/$mockId/scenes", (request) {
      request.reply(
        StatusCode.CREATED,
        null,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
          "location": [mockId]
        },
      );
    }, data: Matchers.any);

    dioAdapter.onPut("$url/tours/$mockId/scenes/$mockId", (request) {
      request.reply(StatusCode.OK, null);
    }, data: Matchers.any);

    dioAdapter.onDelete("$url/tours/$mockId/scenes/$mockId", (request) {
      request.reply(StatusCode.OK, null);
    }, data: Matchers.any);

    dioAdapter.onPost("$url/tours/$mockId/links", (request) {
      request.reply(
        StatusCode.CREATED,
        null,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
          "location": [mockId]
        },
      );
    }, data: Matchers.any);

    dioAdapter.onPost("$url/tours/$mockId/areas", (request) {
      request.reply(
        StatusCode.CREATED,
        null,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
          "location": [mockId]
        },
      );
    }, data: Matchers.any);

    dioAdapter.onPost("$url/tours", (request) {
      request.reply(
        StatusCode.CREATED,
        null,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
          "location": [mockId]
        },
      );
    }, data: Matchers.any);

    dioAdapter.onPut("$url/tours/$mockId/links/$mockId", (request) {
      request.reply(StatusCode.OK, null);
    }, data: Matchers.any);

    dioAdapter.onDelete("$url/tours/$mockId/links/$mockId", (request) {
      request.reply(StatusCode.OK, null);
    }, data: Matchers.any);

    dioAdapter.onPost("$url/tours/$mockId/scenes/$mockId/photos", (request) {
      request.reply(
        StatusCode.OK,
        null,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
          "location": [mockId]
        },
      );
    }, data: Matchers.any);

    dioAdapter.onPost("$url/tours/$mockId/areas/$mockId/photos", (request) {
      request.reply(
        StatusCode.OK,
        null,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
          "location": [mockId]
        },
      );
    }, data: Matchers.any);

    dioAdapter.onGet("$url/tours/$mockId/areas/$mockId/photos", (request) {
      request.reply(StatusCode.OK, ["https://picsum.photos/200/300"]);
    }, data: Matchers.any);

    dioAdapter.onGet(url, (request) {
      request.reply(StatusCode.OK, photos);
    }, data: Matchers.any);

    dioAdapter.onPost("$url/tours/$mockId/areas/$mockId/process", (request) {
      request.reply(StatusCode.OK, photos);
    }, data: Matchers.any);

    dioAdapter.onGet("$url/tours/my", (request) {
      request.reply(StatusCode.OK, [tourMap]);
    }, data: Matchers.any);

    return dio;
  }
}
