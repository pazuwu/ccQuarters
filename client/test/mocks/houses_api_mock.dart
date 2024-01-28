import 'package:ccquarters/model/houses/building_type.dart';
import 'package:ccquarters/model/houses/offer_type.dart';
import 'package:ccquarters/model/houses/photo.dart';
import 'package:ccquarters/services/houses/data/detailed_house.dart';
import 'package:ccquarters/services/houses/responses/get_house_response.dart';
import 'package:ccquarters/services/houses/responses/get_houses_response.dart';
import 'package:dio/dio.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:http_status_code/http_status_code.dart';

import 'mock_data.dart';

extension HousesAPIMock on Dio {
  static Dio createHousesApiMock(String url) {
    Dio dio = Dio();
    final dioAdapter = DioAdapter(dio: dio);

    dioAdapter.onGet(url, (request) {
      request.reply(
          StatusCode.OK,
          GetHousesResponse(
                  0, 10, [mockSimpleHouse, mockSimpleHouse, mockSimpleHouse])
              .toJson());
    }, data: Matchers.any);

    dioAdapter.onGet("$url/liked", (request) {
      request.reply(
          StatusCode.OK,
          GetHousesResponse(
                  0, 10, [mockSimpleHouse, mockSimpleHouse, mockSimpleHouse])
              .toJson());
    }, data: Matchers.any);

    dioAdapter.onGet("$url/my", (request) {
      request.reply(
          StatusCode.OK,
          GetHousesResponse(
                  0, 10, [mockSimpleHouse, mockSimpleHouse, mockSimpleHouse])
              .toJson());
    }, data: Matchers.any);

    dioAdapter.onGet("$url/$mockId", (request) {
      var res = HouseWithDetails(
        "title",
        "description",
        <String, dynamic>{},
        10000,
        3,
        50,
        3,
        "Warszawa",
        "Mazowieckie",
        "02-656",
        "Mokotów",
        "Puławska",
        "10",
        "15",
        null,
        null,
        OfferType.rent,
        BuildingType.apartment,
        true,
        mockId,
        "Jan",
        "Kowalski",
        null,
        "j.kowalski@gmail.com",
        "123456789",
        null,
        null,
      );
      var photo = Photo(
          filename: "photo", url: "https://picsum.photos/200/300", order: 0);

      request.reply(
          StatusCode.OK, GetHouseResponse(res, [photo, photo, photo]).toJson());
    }, data: Matchers.any);

    dioAdapter.onPost(url, (request) {
      request.reply(
        StatusCode.CREATED,
        null,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
          "location": [mockId]
        },
      );
    }, data: Matchers.any);

    dioAdapter.onPut("$url/$mockId", (request) {
      request.reply(StatusCode.OK, null);
    }, data: Matchers.any);

    dioAdapter.onPut("$url/$mockId/photo", (request) {
      request.reply(StatusCode.OK, null);
    }, data: Matchers.any);

    dioAdapter.onPut("$url/$mockId/delete", (request) {
      request.reply(StatusCode.OK, null);
    }, data: Matchers.any);

    dioAdapter.onPut("$url/$mockId/like", (request) {
      request.reply(StatusCode.OK, null);
    }, data: Matchers.any);

    dioAdapter.onPut("$url/$mockId/unlike", (request) {
      request.reply(StatusCode.OK, null);
    }, data: Matchers.any);

    dioAdapter.onPost("$url/$mockId/photo", (request) {
      request.reply(StatusCode.OK, null);
    }, data: Matchers.any);

    return dio;
  }
}
