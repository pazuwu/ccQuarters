import 'package:ccquarters/virtual_tour/model/geo_point.dart';

class Link {
  Link(
      {required this.id,
      required this.destinationId,
      required this.position,
      this.nextOrientation,
      required this.text});

  final String id;
  final String destinationId;
  final GeoPoint position;
  final GeoPoint? nextOrientation;
  final String text;
}
