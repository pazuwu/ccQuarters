import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import 'package:ccquarters/map/geo_autocomplete.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart' as osm;
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class LocationPickerController implements Listenable {
  final List<VoidCallback> _listeners = [];

  late MapController _mapController;
  late GeoAutocompleteController _autocompleteController;

  LatLng? _latLng;
  LatLng? get latLng => _latLng;

  @override
  void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }

  Future setLocation(osm.SearchInfo location) async {
    if (location.point != null) {
      return _setLocationInner(location);
    }

    if (location.address == null) return;

    var suggestions = await osm.addressSuggestion(location.address!.toString(),
        limitInformation: 1);

    if (suggestions.isNotEmpty && suggestions.first.point != null) {
      location = osm.SearchInfo(
          address: location.address, point: suggestions.first.point);
      _setLocationInner(location);
    }
  }

  Future _setLocationInner(osm.SearchInfo location,
      {bool updateAutocomplete = true, bool goToLocation = true}) async {
    if (location.point != null) {
      if (goToLocation) {
        _mapController.move(
            LatLng(location.point!.latitude, location.point!.longitude), 18.0);
      }

      if (updateAutocomplete) {
        _autocompleteController.location = location.point;
      }

      _publishNewLocation(location);
    }
  }

  void _publishNewLocation(osm.SearchInfo? newValue) {
    _latLng = newValue != null && newValue.point != null
        ? LatLng(newValue.point!.latitude, newValue.point!.longitude)
        : null;
    for (var listener in _listeners) {
      listener();
    }
  }

  void _initialize({
    required MapController mapController,
    required GeoAutocompleteController autocompleteController,
  }) {
    _mapController = mapController;
    _autocompleteController = autocompleteController;
  }
}

class LocationPicker extends StatefulWidget {
  const LocationPicker({
    Key? key,
    this.localizeUser,
    this.initPosition,
    this.controller,
  }) : super(key: key);

  final bool? localizeUser;
  final osm.SearchInfo? initPosition;
  final LocationPickerController? controller;

  @override
  State<LocationPicker> createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  late LocationPickerController _controller;
  late MapController _mapController;
  final GeoAutocompleteController _autocompleteController =
      GeoAutocompleteController();

  Future _goToInitLocation() async {
    if (widget.initPosition != null) {
      await _controller.setLocation(widget.initPosition!);
    }
  }

  @override
  void initState() {
    super.initState();

    _mapController = MapControllerImpl();

    _controller = widget.controller ?? LocationPickerController();
    _controller._initialize(
        autocompleteController: _autocompleteController,
        mapController: _mapController);

    _autocompleteController.addListener(() async {
      var searchInfo = _autocompleteController.searchInfo;

      if (searchInfo != null) {
        _controller._setLocationInner(searchInfo, updateAutocomplete: false);
      }

      _controller._publishNewLocation(searchInfo);
    });

    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              onTap: (tapPosition, latlng) {
                if (_autocompleteController.hasFocus) {
                  _autocompleteController.unfocus();
                  return;
                }

                var newlocation = osm.SearchInfo(
                  point: osm.GeoPoint(
                    latitude: latlng.latitude,
                    longitude: latlng.longitude,
                  ),
                );

                _controller._setLocationInner(newlocation, goToLocation: false);
                _controller._publishNewLocation(newlocation);
              },
              onMapReady: () async {
                await _goToInitLocation();
              },
              initialCenter: const LatLng(52.230053, 21.011445),
              initialZoom: 6,
              minZoom: 3,
              maxZoom: 19,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
              ),
              MarkerLayer(markers: [
                if (_controller.latLng != null)
                  Marker(
                    point: _controller.latLng!,
                    child: const osm.MarkerIcon(
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
          Row(
            children: [
              Flexible(
                child: GeoAutocomplete(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 16.0),
                  criticalWidth: 500.0,
                  maxSuggestionsHeight: 300.0,
                  controller: _autocompleteController,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
