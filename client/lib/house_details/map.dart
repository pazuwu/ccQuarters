import 'package:ccquarters/map/location_picker.dart';
import 'package:ccquarters/model/house.dart';
import 'package:ccquarters/utils/consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class MapCard extends StatelessWidget {
  const MapCard({super.key, required this.location});

  final Location location;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(paddingSize),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Lokalizacja",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Container(
          constraints: const BoxConstraints(maxHeight: 500),
          child: Padding(
            padding: const EdgeInsets.all(paddingSize),
            child: LocationPicker(
              initPosition: SearchInfo(
                point: GeoPoint(
                  longitude: location.geoX!,
                  latitude: location.geoY!,
                ),
              ),
              isReadOnly: true,
            ),
          ),
        ),
      ],
    );
  }
}
