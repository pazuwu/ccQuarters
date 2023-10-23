import 'package:ccquarters/virtual_tour/model/area.dart';
import 'package:ccquarters/virtual_tour/model/scene.dart';
import 'package:ccquarters/virtual_tour/model/virtual_tour.dart';

class VirtualTourMock {
  static VirtualTour from360Url(String url) {
    return VirtualTour(id: "", areas: [
      Area(id: "Salon", scenes: [
        Scene(id: "", name: "Salon 1", photo360Url: url),
        Scene(id: "", name: "Salon 2", photo360Url: url),
        Scene(id: "", name: "Salon 3", photo360Url: url),
        Scene(id: "", name: "Salon 4", photo360Url: url),
        Scene(id: "", name: "Salon 5", photo360Url: url),
      ]),
      Area(id: "Kuchnia", scenes: [
        Scene(id: "", name: "Kuchnia 1", photo360Url: url),
        Scene(id: "", name: "Kuchnia 2", photo360Url: url),
        Scene(id: "", name: "Kuchnia 3", photo360Url: url),
        Scene(id: "", name: "Kuchnia 4", photo360Url: url),
      ]),
    ]);
  }
}
