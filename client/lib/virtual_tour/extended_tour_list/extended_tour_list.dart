import 'package:ccquarters/virtual_tour/model/tour_info.dart';
import 'package:ccquarters/virtual_tour/tour/gate.dart';
import 'package:ccquarters/virtual_tour/tour_list/gate.dart';
import 'package:flutter/material.dart';

class TourListExtendedGate extends StatefulWidget {
  const TourListExtendedGate({super.key});

  @override
  State<TourListExtendedGate> createState() => _TourListExtendedGateState();
}

class _TourListExtendedGateState extends State<TourListExtendedGate> {
  TourInfo? _selectedTour;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: VTListGate(
              selectionChanged: (tourInfo) => setState(() {
                _selectedTour = tourInfo;
              }),
            ),
          ),
        ),
        VerticalDivider(
          indent: 16,
          endIndent: 16,
          width: 1,
          thickness: 2.0,
          color: Colors.blueGrey.shade50,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: _selectedTour == null
                ? Container()
                : VirtualTourGate(
                    tourId: _selectedTour!.id,
                    readOnly: false,
                  ),
          ),
        ),
      ],
    );
  }
}
