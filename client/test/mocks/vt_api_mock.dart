import 'package:ccquarters/model/virtual_tours/area.dart';
import 'package:ccquarters/model/virtual_tours/geo_point.dart';
import 'package:ccquarters/model/virtual_tours/link.dart';
import 'package:ccquarters/model/virtual_tours/scene.dart';
import 'package:dio/dio.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:http_status_code/http_status_code.dart';

extension VTAPIMock on Dio {
  static Dio createVTApiMock(String url) {
    Dio dio = Dio();
    final dioAdapter = DioAdapter(dio: dio);
    const id = "cb849fa2-1033-4d6b-7c88-08db36d6f10f";
    final areas = [
      Area(name: "area1"),
      Area(name: "area2"),
      Area(name: "area3")
    ];
    final scenes = [
      Scene(
        id: "1",
        name: "scene1",
        photo360Url: "https://picsum.photos/200/300",
      ),
      Scene(
        id: "2",
        name: "scene2",
        photo360Url: "https://picsum.photos/200/300",
      ),
      Scene(
        id: "3",
        name: "scene3",
        photo360Url: "https://picsum.photos/200/300",
      ),
    ];
    final links = [
      Link(
        id: "1",
        destinationId: "cb849fa2-1033-4d6b-7c88-08db36d6f10f",
        position: GeoPoint(latitude: 10, longitude: 10),
        text: "Korytarz",
      ),
      Link(
        id: "2",
        destinationId: "cb849fa2-1033-4d6b-7c88-08db36d6f10f",
        position: GeoPoint(latitude: 10, longitude: 10),
        text: "Pokój",
      ),
    ];
    final tourMap = <String, dynamic>{
      'name': 'Test tour',
      'ownerId': 'cb849fa2-1033-4d6b-7c88-08db36d6f10f',
      'id': id,
      'areas': areas.map((x) => x.toMap()).toList(),
      'scenes': scenes.map((x) => x.toMap()).toList(),
      'links': links.map((x) => x.toMap()).toList(),
    };
    final photos = [1, 2, 3, 4];

    dioAdapter.onGet("$url/tours/$id", (request) {
      request.reply(StatusCode.OK, tourMap);
    }, data: Matchers.any);

    dioAdapter.onGet("$url/tours/$id/forEdit", (request) {
      request.reply(StatusCode.OK, tourMap);
    }, data: Matchers.any);

    dioAdapter.onPost("$url/tours/$id/scenes", (request) {
      request.reply(
        StatusCode.CREATED,
        null,
        headers: const {
          Headers.contentTypeHeader: [Headers.jsonContentType],
          "location": [id]
        },
      );
    }, data: Matchers.any);

    dioAdapter.onPost("$url/tours/$id/links", (request) {
      request.reply(
        StatusCode.CREATED,
        null,
        headers: const {
          Headers.contentTypeHeader: [Headers.jsonContentType],
          "location": [id]
        },
      );
    }, data: Matchers.any);

    dioAdapter.onPost("$url/tours/$id/areas", (request) {
      request.reply(
        StatusCode.CREATED,
        null,
        headers: const {
          Headers.contentTypeHeader: [Headers.jsonContentType],
          "location": [id]
        },
      );
    }, data: Matchers.any);

    dioAdapter.onPost("$url/tours", (request) {
      request.reply(
        StatusCode.CREATED,
        null,
        headers: const {
          Headers.contentTypeHeader: [Headers.jsonContentType],
          "location": [id]
        },
      );
    }, data: Matchers.any);

    dioAdapter.onPut("$url/tours/$id/links/$id", (request) {
      request.reply(StatusCode.OK, null);
    }, data: Matchers.any);

    dioAdapter.onDelete("$url/tours/$id/links/$id", (request) {
      request.reply(StatusCode.OK, null);
    }, data: Matchers.any);

    dioAdapter.onPost("$url/tours/$id/scenes/$id/photos", (request) {
      request.reply(
        StatusCode.OK,
        null,
        headers: const {
          Headers.contentTypeHeader: [Headers.jsonContentType],
          "location": [id]
        },
      );
    }, data: Matchers.any);

    dioAdapter.onPost("$url/tours/$id/areas/$id/photos", (request) {
      request.reply(
        StatusCode.OK,
        null,
        headers: const {
          Headers.contentTypeHeader: [Headers.jsonContentType],
          "location": [id]
        },
      );
    }, data: Matchers.any);

    dioAdapter.onGet(url, (request) {
      request.reply(StatusCode.OK, photos);
    }, data: Matchers.any);

    dioAdapter.onPost("$url/tours/$id/areas/$id/process", (request) {
      request.reply(StatusCode.OK, photos);
    }, data: Matchers.any);

    return dio;
  }
}
