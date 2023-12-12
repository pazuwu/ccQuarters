import 'package:ccquarters/model/house_details.dart';
import 'package:ccquarters/model/location.dart';
import 'package:ccquarters/model/offer_type.dart';
import 'package:ccquarters/model/photo.dart';

class House {
  House(
    this.location,
    this.details,
    this.photo, {
    required this.id,
    required this.offerType,
    required this.isLiked,
  });

  String id;
  Location location;
  HouseDetails details;
  OfferType offerType;
  bool isLiked;
  Photo photo;
}