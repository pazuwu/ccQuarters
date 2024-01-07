import 'package:ccquarters/alerts/views/details/house_details.dart';
import 'package:ccquarters/alerts/views/details/location.dart';
import 'package:ccquarters/alerts/views/details/price.dart';
import 'package:ccquarters/alerts/views/details/type.dart';
import 'package:ccquarters/common/functions.dart';
import 'package:ccquarters/model/alerts/alert.dart';
import 'package:flutter/material.dart';

class AlertDetails extends StatelessWidget {
  const AlertDetails({super.key, required this.alert});

  final Alert alert;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: buildWidgetsWithDivider([
          if (_canBuildType())
            AlertType(
              offerType: alert.offerType,
              buildingType: alert.buildingType,
            ),
          if (_canBuildLocation())
            AlertLocation(
              alert: alert,
            ),
          if (_canBuildPrice())
            AlertPrice(
              alert: alert,
            ),
          if (_canBuildDetails())
            AlertHouseDetails(
              alert: alert,
            ),
        ]),
      ),
    );
  }

  bool _canBuildType() => alert.offerType != null || alert.buildingType != null;

  bool _canBuildLocation() =>
      alert.voivodeship != null ||
      (alert.cities != null && alert.cities!.isNotEmpty) ||
      (alert.districts != null && alert.districts!.isNotEmpty);

  bool _canBuildPrice() =>
      alert.minPrice != null ||
      alert.maxPrice != null ||
      alert.minPricePerM2 != null ||
      alert.maxPricePerM2 != null;

  bool _canBuildDetails() =>
      alert.minArea != null ||
      alert.maxArea != null ||
      alert.minRoomCount != null ||
      alert.maxRoomCount != null ||
      alert.minFloor != null ||
      (alert.floors != null && alert.floors!.isNotEmpty);
}
