import 'dart:typed_data';

import 'package:ccquarters/model/alerts/alert.dart';
import 'package:ccquarters/model/alerts/new_alert.dart';
import 'package:ccquarters/model/houses/building_type.dart';
import 'package:ccquarters/model/houses/detailed_house.dart';
import 'package:ccquarters/model/houses/filter.dart';
import 'package:ccquarters/model/houses/house_details.dart';
import 'package:ccquarters/model/houses/location.dart';
import 'package:ccquarters/model/houses/offer_type.dart';
import 'package:ccquarters/model/users/user.dart';
import 'package:ccquarters/model/virtual_tours/area.dart';
import 'package:ccquarters/model/virtual_tours/geo_point.dart';
import 'package:ccquarters/model/virtual_tours/link.dart';
import 'package:ccquarters/model/virtual_tours/scene.dart';
import 'package:ccquarters/model/virtual_tours/tour.dart';
import 'package:ccquarters/model/virtual_tours/tour_for_edit.dart';
import 'package:ccquarters/services/houses/data/simple_house.dart';
import 'package:file_picker/file_picker.dart';

String mockId = "cb849fa2-1033-4d6b-7c88-08db36d6f10f";
String mockEmail = "jan.kowalski@gmail.com";

DetailedHouse mockDetailedHouse = DetailedHouse(
  Location(
      city: "Warszawa",
      voivodeship: "Mazowieckie",
      zipCode: "00-000",
      streetNumber: "10"),
  HouseDetails(
    title: "Tytuł",
    buildingType: BuildingType.house,
    area: 100,
    floor: 1,
    description: "Opis",
    price: 1000,
  ),
  mockUser,
  [],
  id: mockId,
  isLiked: false,
  offerType: OfferType.rent,
);

SimpleHouse mockSimpleHouse = SimpleHouse(
  mockId,
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
  "photoUrl",
);

Alert mockAlert = Alert(
  id: mockId,
  cities: ["Warszawa"],
  maxPrice: 1000000,
);

Alert mockEmptyAlert = Alert(id: mockId);

NewAlert mockNewAlert = NewAlert.fromHouseFilter(
  HouseFilter(
    buildingType: BuildingType.apartment,
  ),
);

NewAlert mockEmptyNewAlert = NewAlert();

User mockUser = User(
  mockId,
  "Jan",
  "Kowalski",
  null,
  "j.kowalski@gmail.com",
  "123456789",
  null,
  DateTime.now(),
);

Scene mockScene = Scene(
  id: mockId,
  name: "scene1",
  photo360Url: "https://picsum.photos/200/300",
);
Scene mockScene2 = Scene(
  id: mockId,
  name: "scene2",
  photo360Url: "https://picsum.photos/200/300",
);

Area mockArea = Area(name: "area1", id: mockId);

Link mockLink = Link(
  id: mockId,
  destinationId: mockId,
  position: GeoPoint(latitude: 10, longitude: 10),
  text: "Korytarz",
);

Tour mockTour = Tour(
  id: mockId,
  ownerId: mockId,
  name: "Tour",
  scenes: [mockScene, mockScene2],
  links: [mockLink],
);

TourForEdit mockTourForEdit = TourForEdit(
  id: mockId,
  ownerId: mockId,
  name: "Tour",
  scenes: [mockScene, mockScene2],
  links: [mockLink],
  areas: [mockArea],
);

PlatformFile mockPhoto = PlatformFile(
  name: "photo",
  bytes: Uint8List.fromList([1, 2, 3, 4, 5]),
  size: 100,
  path: "path",
  readStream: null,
);
