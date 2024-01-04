import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class MapReadOnly extends StatelessWidget {
  const MapReadOnly(
      {super.key, required this.latitude, required this.longitude});

  final double latitude;
  final double longitude;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          options: MapOptions(
            initialCenter: LatLng(latitude, longitude),
            initialZoom: 18,
            minZoom: 3,
            maxZoom: 20,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.app',
            ),
            MarkerLayer(markers: [
              Marker(
                point: LatLng(latitude, longitude),
                child: const MarkerIcon(
                  icon: Icon(
                    Icons.location_on,
                    color: Colors.red,
                    size: 56,
                  ),
                ),
              )
            ]),
            RichAttributionWidget(
              attributions: [
                TextSourceAttribution(
                  'OpenStreetMap contributors',
                  onTap: () => launchUrl(
                      Uri.parse('https://openstreetmap.org/copyright')),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
