import 'package:ccquarters/model/houses/house_details.dart';
import 'package:ccquarters/model/houses/location.dart';
import 'package:ccquarters/model/houses/offer_type.dart';
import 'package:ccquarters/model/houses/photo.dart';
import 'package:ccquarters/model/users/user.dart';

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
