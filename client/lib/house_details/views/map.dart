import 'package:ccquarters/map/map_readonly.dart';
import 'package:ccquarters/common/consts.dart';
import 'package:flutter/material.dart';

class MapCard extends StatelessWidget {
  const MapCard({
    super.key,
    required this.geoX,
    required this.geoY,
  });

  final double geoX;
  final double geoY;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(
            largePaddingSize,
            0,
            largePaddingSize,
            largePaddingSize,
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Lokalizacja",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.5,
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              largePaddingSize,
              0,
              largePaddingSize,
              largePaddingSize,
            ),
            child: MapReadOnly(
              latitude: geoY,
              longitude: geoX,
            ),
          ),
        ),
      ],
    );
  }
}
