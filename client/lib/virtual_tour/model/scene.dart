import 'package:ccquarters/virtual_tour/model/link.dart';

class Scene {
  Scene({
    required this.id,
    required this.name,
    required this.photo360Url,
    this.links = const [],
  });

  final String id;
  final String name;
  final String photo360Url;
  final List<Link> links;

  @override
  String toString() {
    return name;
  }
}
