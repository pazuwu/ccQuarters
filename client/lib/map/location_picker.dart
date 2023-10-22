import 'package:ccquarters/map/geo_autocomplete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class LocationPicker extends StatefulWidget {
  const LocationPicker({
    Key? key,
    this.localizeUser,
    this.initPosition,
    this.onLocationChosen,
  }) : super(key: key);

  final bool? localizeUser;
  final SearchInfo? initPosition;
  final void Function(SearchInfo?)? onLocationChosen;

  @override
  State<LocationPicker> createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  late MapController _mapController;
  final GeoAutocompleteController _autocompleteController =
      GeoAutocompleteController();

  SearchInfo? location;

  Future _goToInitLocation() async {
    if (widget.initPosition?.point != null ||
        widget.initPosition?.address == null) return;

    var suggestions = await addressSuggestion(
        widget.initPosition!.address!.toString(),
        limitInformation: 1);

    if (suggestions.isNotEmpty && suggestions.first.point != null) {
      location = SearchInfo(
          address: widget.initPosition!.address,
          point: suggestions.first.point);
      await _mapController.addMarker(location!.point!);
      await _mapController.setZoom(zoomLevel: 18.0);
      await _mapController.goToLocation(location!.point!);
      _autocompleteController.location = suggestions.first.point!;
    }
  }

  @override
  void initState() {
    super.initState();

    _mapController = (widget.localizeUser ?? false)
        ? MapController.withUserPosition(
            trackUserLocation: const UserTrackingOption(
            enableTracking: true,
            unFollowUser: false,
          ))
        : MapController.withPosition(
            initPosition: widget.initPosition?.point ??
                GeoPoint(longitude: 19.0, latitude: 52.0));

    _mapController.listenerMapSingleTapping.addListener(() async {
      if (_mapController.listenerMapSingleTapping.value == null) return;

      if (_autocompleteController.hasFocus) {
        _autocompleteController.unfocus();
        return;
      }

      if (location?.point != null) {
        await _mapController.removeMarker(location!.point!);
      }

      location =
          SearchInfo(point: _mapController.listenerMapSingleTapping.value);

      await _mapController.addMarker(location!.point!);

      _autocompleteController.location =
          _mapController.listenerMapSingleTapping.value!;

      widget.onLocationChosen?.call(location);
    });

    _autocompleteController.addListener(() async {
      var searchInfo = _autocompleteController.searchInfo;

      if (location?.point != null) {
        await _mapController.removeMarker(location!.point!);
      }

      location = searchInfo;

      if (searchInfo != null) {
        await _mapController.setZoom(zoomLevel: 16.0);
        await _mapController.goToLocation(searchInfo.point!);

        await _mapController.addMarker(searchInfo.point!);
        widget.onLocationChosen?.call(searchInfo);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          OSMFlutter(
              onMapIsReady: (_) async {
                await _goToInitLocation();
              },
              mapIsLoading: const Center(child: CircularProgressIndicator()),
              controller: _mapController,
              osmOption: OSMOption(
                enableRotationByGesture: false,
                zoomOption: const ZoomOption(
                  initZoom: 6,
                  minZoomLevel: 3,
                  maxZoomLevel: 19,
                  stepZoom: 1.0,
                ),
                userLocationMarker: UserLocationMaker(
                  personMarker: const MarkerIcon(
                    icon: Icon(
                      Icons.location_history_rounded,
                      color: Colors.red,
                      size: 56,
                    ),
                  ),
                  directionArrowMarker: const MarkerIcon(
                    icon: Icon(
                      Icons.double_arrow,
                      size: 48,
                    ),
                  ),
                ),
                roadConfiguration: const RoadOption(
                  roadColor: Colors.yellowAccent,
                ),
              )),
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
