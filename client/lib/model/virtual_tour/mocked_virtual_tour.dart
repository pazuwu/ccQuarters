import 'package:ccquarters/model/virtual_tour/area.dart';
import 'package:ccquarters/model/virtual_tour/geo_point.dart';
import 'package:ccquarters/model/virtual_tour/link.dart';
import 'package:ccquarters/model/virtual_tour/scene.dart';
import 'package:ccquarters/model/virtual_tour/tour.dart';
import 'package:ccquarters/model/virtual_tour/tour_for_edit.dart';

class VirtualTourMock {
  static Tour from360Url(String url) {
    return TourForEdit(
      name: "Test tour",
      id: "",
      ownerId: "",
      areas: [
        Area(id: "salon", name: "Salon"),
        Area(id: "kuchnia", name: "Kuchnia"),
      ],
      scenes: [
        Scene(
          id: "salon0",
          name: "Salon 1",
          photo360Url: url,
          parentId: "salon",
        ),
        Scene(
          id: "salon1",
          name: "Salon 2",
          photo360Url: url,
          parentId: "salon",
        ),
        Scene(
          id: "salon2",
          name: "Salon 3",
          photo360Url: url,
          parentId: "salon",
        ),
        Scene(
          id: "kuchnia3",
          name: "Salon 4",
          photo360Url: url,
          parentId: "kuchnia",
        ),
        Scene(
          id: "kuchnia4",
          name: "Salon 5",
          photo360Url: url,
          parentId: "kuchnia",
        ),
      ],
      links: [
        Link(
          id: "0",
          destinationId: "salon1",
          position: GeoPoint(latitude: 50, longitude: 30),
          text: "Salon 0 -> Salon 1",
          parentId: "salon0",
        ),
      ],
    );
  }
}
