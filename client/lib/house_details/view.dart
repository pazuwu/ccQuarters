import 'package:ccquarters/house_details/accordion.dart';
import 'package:ccquarters/house_details/contact.dart';
import 'package:ccquarters/house_details/map.dart';
import 'package:ccquarters/house_details/photos.dart';
import 'package:ccquarters/main_page/cubit.dart';
import 'package:ccquarters/model/house.dart';
import 'package:ccquarters/utils/device_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailsView extends StatelessWidget {
  const DetailsView({super.key, required this.house});

  final House house;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const Key("details_view"),
      appBar: AppBar(
        toolbarHeight: 68,
        leading: IconButton(
          onPressed: () => context.read<MainPageCubit>().goBack(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(house.details.title),
      ),
      body: Inside(house: house),
    );
  }
}

class Inside extends StatelessWidget {
  const Inside({
    super.key,
    required this.house,
  });

  final House house;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Photos(
                      photos: house.photos,
                    ),
                    if (getDeviceType(context) == DeviceType.mobile)
                      ButtonContactWidget(user: house.user),
                    AccordionPage(
                      house: house,
                    ),
                    if (house.location.geoX != null &&
                        house.location.geoY != null)
                      MapCard(location: house.location),
                  ],
                ),
              ),
            ),
            if (getDeviceType(context) == DeviceType.web)
              ContactWidget(user: house.user),
          ]),
    );
  }
}
