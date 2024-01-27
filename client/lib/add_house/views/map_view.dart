import 'package:ccquarters/common/consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

import 'package:ccquarters/add_house/cubit.dart';
import 'package:ccquarters/map/location_picker.dart';
import 'package:ccquarters/model/houses/new_house.dart';
import 'package:ccquarters/common/views/view_with_buttons.dart';

class MapView extends StatelessWidget {
  const MapView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewWithButtons(
        scrollable: false,
        inBetweenWidget: ChooseLocationOnMap(
          addHouseFormCubit: context.read(),
        ),
        goBackOnPressed: () {
          context.read<AddHouseFormCubit>().goToLocationForm();
        },
        nextOnPressed: () {
          context.read<AddHouseFormCubit>().goToPhotosForm();
        });
  }
}

class ChooseLocationOnMap extends StatefulWidget {
  const ChooseLocationOnMap({
    Key? key,
    required this.addHouseFormCubit,
  }) : super(key: key);

  final AddHouseFormCubit addHouseFormCubit;

  @override
  State<ChooseLocationOnMap> createState() => _ChooseLocationOnMapState();
}

class _ChooseLocationOnMapState extends State<ChooseLocationOnMap> {
  final LocationPickerController _locationPickerController =
      LocationPickerController();

  @override
  void initState() {
    super.initState();

    _locationPickerController.addListener(() {
      var latLng = _locationPickerController.latLng;

      widget.addHouseFormCubit.saveCoordinates(
          longitute: latLng?.longitude, latitude: latLng?.latitude);
    });
  }

  SearchInfo _mapAddress(NewLocation location) {
    return SearchInfo(
        point: location.geoX != null && location.geoY != null
            ? GeoPoint(longitude: location.geoX!, latitude: location.geoY!)
            : null,
        address: location.city.isNotEmpty &&
                location.zipCode.isNotEmpty &&
                location.streetNumber.isNotEmpty
            ? Address(
                city: location.city,
                postcode: location.zipCode,
                street: location.streetName,
                name: "${location.streetNumber}/${location.flatNumber}",
              )
            : null);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(largePaddingSize),
        child: LocationPicker(
          controller: _locationPickerController,
          initPosition:
              _mapAddress(context.read<AddHouseFormCubit>().house.location),
        ),
      ),
    );
  }
}
