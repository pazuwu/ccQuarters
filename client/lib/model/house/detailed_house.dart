import 'package:ccquarters/model/house/house_details.dart';
import 'package:ccquarters/model/house/location.dart';
import 'package:ccquarters/model/house/offer_type.dart';
import 'package:ccquarters/model/house/photo.dart';
import 'package:ccquarters/model/user/user.dart';

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
