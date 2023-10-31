import 'package:ccquarters/virtual_tour/model/area.dart';
import 'package:ccquarters/virtual_tour/model/link.dart';
import 'package:ccquarters/virtual_tour/model/scene.dart';

class Tour {
  Tour({
    required this.id,
    this.areas = const [],
    this.scenes = const [],
    this.links = const [],
  });

  final String id;
  final List<Area> areas;
  final List<Scene> scenes;
  final List<Link> links;
}
