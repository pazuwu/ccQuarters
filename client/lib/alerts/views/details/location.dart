import 'package:ccquarters/common/functions.dart';
import 'package:ccquarters/common/widgets/two_parts_rich_text.dart';
import 'package:ccquarters/model/alerts/alert.dart';
import 'package:flutter/material.dart';

class AlertLocation extends StatelessWidget {
  const AlertLocation({super.key, required this.alert});

  final Alert alert;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (alert.voivodeship != null)
          TwoPartsRichText(
            firstText: "Województwo: ",
            secondText: alert.voivodeship!,
          ),
        if (alert.cities != null && alert.cities!.isNotEmpty)
          if (alert.cities!.length == 1)
            TwoPartsRichText(
              firstText: "Miasto: ",
              secondText: alert.cities!.first,
            )
          else
            TwoPartsRichText(
              firstText: "Miasta: ",
              secondText: getStringOfListWithCommaDivider(alert.cities!),
            ),
        if (alert.districts != null && alert.districts!.isNotEmpty)
          if (alert.districts!.length == 1)
            TwoPartsRichText(
              firstText: "Dzielnica: ",
              secondText: alert.districts!.first,
            )
          else
            TwoPartsRichText(
              firstText: "Dzielnice: ",
              secondText: getStringOfListWithCommaDivider(alert.districts!),
            )
      ],
    );
  }
}
