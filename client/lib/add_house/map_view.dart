import 'package:ccquarters/add_house/cubit.dart';
import 'package:ccquarters/map/location_picker.dart';
import 'package:ccquarters/model/new_house.dart';
import 'package:ccquarters/utils/view_with_header_and_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class MapView extends StatelessWidget {
  const MapView({super.key});

  SearchInfo _mapAddress(NewLocation location) {
    return SearchInfo(
        point: location.geoX != null && location.geoY != null
            ? GeoPoint(longitude: location.geoX!, latitude: location.geoY!)
            : null,
        address: Address(
            city: location.city,
            postcode: location.zipCode,
            street: location.streetName,
            name: "${location.streetNumber}/${location.flatNumber}"));
  }

  @override
  Widget build(BuildContext context) {
    return ViewWithHeader(
        scrollable: false,
        title: "Wybierz lokalizację",
        inBetweenWidget: Expanded(
          child: LocationPicker(
              initPosition:
                  _mapAddress(context.read<AddHouseFormCubit>().house.location),
              onLocationChosen: (location) {
                context.read<AddHouseFormCubit>().saveCoordinates(
                    longitute: location?.point?.longitude,
                    latitude: location?.point?.latitude);

                context.read<AddHouseFormCubit>().goToPhotosForm();
              }),
        ),
        goBackOnPressed: () {
          context.read<AddHouseFormCubit>().goToLocationForm();
        },
        nextOnPressed: () {
          context.read<AddHouseFormCubit>().goToPhotosForm();
        });
  }
}
