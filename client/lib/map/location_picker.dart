import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

import 'package:ccquarters/map/geo_autocomplete.dart';

class LocationPickerController implements Listenable {
  final List<VoidCallback> _listeners = [];

  late MapController _mapController;
  late GeoAutocompleteController _autocompleteController;
  late bool _isReadOnly;

  SearchInfo? _location;
  SearchInfo? get location => _location;

  @override
  void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }

  Future setLocation(SearchInfo location) async {
    if (location.point != null) {
      return _setLocationInner(location);
    }

    if (location.address == null) return;

    var suggestions = await addressSuggestion(location.address!.toString(),
        limitInformation: 1);

    if (suggestions.isNotEmpty && suggestions.first.point != null) {
      location =
          SearchInfo(address: location.address, point: suggestions.first.point);
      _setLocationInner(location);
    }
  }

  Future _setLocationInner(SearchInfo location,
      {bool updateAutocomplete = true, bool goToLocation = true}) async {
    if (location.point != null) {
      _location = location;
      if ((_isReadOnly && !kIsWeb) || !_isReadOnly) {
        await _mapController.addMarker(location.point!);
      }

      if (goToLocation) {
        await _mapController.setZoom(zoomLevel: 18.0);
        await _mapController.goToLocation(location.point!);
      }

      if (updateAutocomplete) {
        _autocompleteController.location = location.point;
      }
    }
  }

  void _publishNewLocation(SearchInfo? newValue) {
    _location = newValue;
    for (var listener in _listeners) {
      listener();
    }
  }

  void _initialize({
    required MapController mapController,
    required GeoAutocompleteController autocompleteController,
    required bool isReadOnly,
  }) {
    _mapController = mapController;
    _autocompleteController = autocompleteController;
    _isReadOnly = isReadOnly;
  }
}

class LocationPicker extends StatefulWidget {
  const LocationPicker({
    Key? key,
    this.localizeUser,
    this.initPosition,
    this.controller,
    this.isReadOnly = false,
  }) : super(key: key);

  final bool? localizeUser;
  final SearchInfo? initPosition;
  final LocationPickerController? controller;
  final bool isReadOnly;

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

    _mapController = (widget.localizeUser ?? false)
        ? MapController.withUserPosition(
            trackUserLocation: const UserTrackingOption(
            enableTracking: true,
            unFollowUser: false,
          ))
        : MapController.withPosition(
            initPosition: widget.initPosition?.point ??
                GeoPoint(longitude: 19.0, latitude: 52.0));

    _controller = widget.controller ?? LocationPickerController();
    _controller._initialize(
        autocompleteController: _autocompleteController,
        mapController: _mapController,
        isReadOnly: widget.isReadOnly);

    if (!widget.isReadOnly) {
      _mapController.listenerMapSingleTapping.addListener(() async {
        if (_mapController.listenerMapSingleTapping.value == null) return;

        if (_autocompleteController.hasFocus) {
          _autocompleteController.unfocus();
          return;
        }

        if (_controller.location?.point != null) {
          await _mapController.removeMarker(_controller.location!.point!);
        }

        var newlocation =
            SearchInfo(point: _mapController.listenerMapSingleTapping.value);

        _controller._setLocationInner(newlocation, goToLocation: false);
        _controller._publishNewLocation(newlocation);
      });

      _autocompleteController.addListener(() async {
        var searchInfo = _autocompleteController.searchInfo;

        if (_controller.location?.point != null) {
          await _mapController.removeMarker(_controller.location!.point!);
        }

        if (searchInfo != null) {
          _controller._setLocationInner(searchInfo, updateAutocomplete: false);
          _controller._publishNewLocation(searchInfo);
        }
      });
    }
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
          if (!widget.isReadOnly)
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
