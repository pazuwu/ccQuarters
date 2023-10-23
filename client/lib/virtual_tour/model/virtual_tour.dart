import 'package:ccquarters/virtual_tour/model/area.dart';

class VirtualTour {
  VirtualTour({
    required this.id,
    required this.areas,
  });

  final String id;
  final List<Area> areas;
}
