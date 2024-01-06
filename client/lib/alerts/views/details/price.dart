import 'package:ccquarters/common/widgets/two_parts_rich_text.dart';
import 'package:ccquarters/model/alerts/alert.dart';
import 'package:flutter/material.dart';

class AlertPrice extends StatelessWidget {
  const AlertPrice({super.key, required this.alert});

  final Alert alert;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (alert.minPrice != null || alert.maxPrice != null)
          TwoPartsRichText(
            firstText: "Cena: ",
            secondText: _getPriceString(alert.minPrice, alert.maxPrice),
          ),
        if (alert.minPricePerM2 != null || alert.maxPricePerM2 != null)
          TwoPartsRichText(
            firstText: "Cena za m2: ",
            secondText:
                _getPriceString(alert.minPricePerM2, alert.maxPricePerM2),
          )
      ],
    );
  }

  String _getPriceString(double? minPrice, double? maxPrice) {
    String result = "";

    if (minPrice != null) {
      result += "od $minPrice zł ";
    }
    if (maxPrice != null) {
      result += "do $maxPrice zł";
    }

    return result;
  }
}
