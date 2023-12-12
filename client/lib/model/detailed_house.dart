import 'package:ccquarters/model/house_details.dart';
import 'package:ccquarters/model/location.dart';
import 'package:ccquarters/model/offer_type.dart';
import 'package:ccquarters/model/photo.dart';
import 'package:ccquarters/model/user.dart';

class DetailedHouse {
  DetailedHouse(
    this.location,
    this.details,
    this.user,
    this.photos, {
    required this.id,
    required this.offerType,
    required this.isLiked,
  });

  String id;
  Location location;
  HouseDetails details;
  OfferType offerType;
  User user;
  bool isLiked;
  List<Photo> photos;
}
