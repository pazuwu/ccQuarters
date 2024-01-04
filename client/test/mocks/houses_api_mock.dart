import 'package:ccquarters/model/house/building_type.dart';
import 'package:ccquarters/model/house/offer_type.dart';
import 'package:ccquarters/model/house/photo.dart';
import 'package:ccquarters/services/houses/data/detailed_house.dart';
import 'package:ccquarters/services/houses/data/simple_house.dart';
import 'package:ccquarters/services/houses/responses/get_house_response.dart';
import 'package:ccquarters/services/houses/responses/get_houses_response.dart';
import 'package:dio/dio.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:http_status_code/http_status_code.dart';

extension HousesAPIMock on Dio {
  static Dio createHousesApiMock(String url) {
    Dio dio = Dio();
    final dioAdapter = DioAdapter(dio: dio);
    final simpleHouse = SimpleHouse(
        "1",
        "title",
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
        OfferType.rent,
        BuildingType.apartment,
        false,
        "photoUrl");
    const id = "cb849fa2-1033-4d6b-7c88-08db36d6f10f";

    dioAdapter.onGet(url, (request) {
      request.reply(
          StatusCode.OK,
          GetHousesResponse(0, 10, [simpleHouse, simpleHouse, simpleHouse])
              .toJson());
    }, data: Matchers.any);

    dioAdapter.onGet("$url/liked", (request) {
      request.reply(
          StatusCode.OK,
          GetHousesResponse(0, 10, [simpleHouse, simpleHouse, simpleHouse])
              .toJson());
    }, data: Matchers.any);

    dioAdapter.onGet("$url/my", (request) {
      request.reply(
          StatusCode.OK,
          GetHousesResponse(0, 10, [simpleHouse, simpleHouse, simpleHouse])
              .toJson());
    }, data: Matchers.any);

    dioAdapter.onGet("$url/$id", (request) {
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
        id,
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
        headers: const {
          Headers.contentTypeHeader: [Headers.jsonContentType],
          "location": [id]
        },
      );
    }, data: Matchers.any);

    dioAdapter.onPut("$url/$id/photo", (request) {
      request.reply(StatusCode.OK, null);
    }, data: Matchers.any);

    dioAdapter.onPut("$url/$id/delete", (request) {
      request.reply(StatusCode.OK, null);
    }, data: Matchers.any);

    dioAdapter.onPut("$url/$id/like", (request) {
      request.reply(StatusCode.OK, null);
    }, data: Matchers.any);

    dioAdapter.onPut("$url/$id/unlike", (request) {
      request.reply(StatusCode.OK, null);
    }, data: Matchers.any);

    dioAdapter.onPost("$url/$id/photo", (request) {
      request.reply(StatusCode.OK, null);
    }, data: Matchers.any);

    return dio;
  }
}
