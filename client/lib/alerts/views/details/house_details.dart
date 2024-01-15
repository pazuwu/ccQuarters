import 'package:ccquarters/common/functions.dart';
import 'package:ccquarters/common/widgets/two_parts_rich_text.dart';
import 'package:ccquarters/model/alerts/alert.dart';
import 'package:flutter/material.dart';

class AlertHouseDetails extends StatelessWidget {
  const AlertHouseDetails({super.key, required this.alert});

  final Alert alert;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (alert.minArea != null || alert.maxArea != null)
          TwoPartsRichText(
            firstText: "Powierzchnia: ",
            secondText: _getAreaString(),
          ),
        if (alert.minRoomCount != null || alert.maxRoomCount != null)
          TwoPartsRichText(
            firstText: "Liczba pokoi: ",
            secondText: _getRoomString(),
          ),
        if (alert.minFloor != null ||
            (alert.floors != null && alert.floors!.isNotEmpty))
          TwoPartsRichText(
            firstText: "Piętro: ",
            secondText: _getFloorString(),
          ),
      ],
    );
  }

  String _getAreaString() {
    String result = "";
    if (alert.minArea != null) {
      result += "od ${alert.minArea} ";
    }
    if (alert.maxArea != null) {
      result += "do ${alert.maxArea} ";
    }
    result += "m\u00B2";
    return result;
  }

  String _getRoomString() {
    String result = "";
    if (alert.minRoomCount != null) {
      result += "od ${alert.minRoomCount} ";
    }
    if (alert.maxRoomCount != null) {
      result += "do ${alert.maxRoomCount}";
    }
    return result;
  }

  String _getFloorString() {
    String result = "";
    var floors = alert.floors?.map((e) => e.toString()).toList() ?? [];
    if (alert.minFloor != null) {
      floors.add("powyżej ${alert.minFloor! - 1}");
    }
    result += "${getStringOfListWithCommaDivider(floors)} ";
    return result;
  }
}
