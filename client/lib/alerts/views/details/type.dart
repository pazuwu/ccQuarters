import 'package:ccquarters/model/houses/building_type.dart';
import 'package:ccquarters/model/houses/offer_type.dart';
import 'package:flutter/material.dart';

class AlertType extends StatelessWidget {
  const AlertType({super.key, this.offerType, this.buildingType});

  final OfferType? offerType;
  final BuildingType? buildingType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (offerType != null)
              Text("${offerType!.toString()} ${_getBuildingTypeString()}",
                  style: const TextStyle(fontWeight: FontWeight.w500)),
            if (offerType != null)
              const SizedBox(
                width: 8.0,
              ),
            if (buildingType != null)
              Icon(
                buildingType!.icon,
                size: 32.0,
              ),
          ],
        ),
      ],
    );
  }

  _getBuildingTypeString() {
    switch (buildingType) {
      case BuildingType.apartment:
        return "mieszkania";
      case BuildingType.house:
        return "domu";
      case BuildingType.room:
        return "pokoju";
      case null:
        return "";
    }
  }
}
