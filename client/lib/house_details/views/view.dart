import 'package:ccquarters/house_details/views/accordion.dart';
import 'package:ccquarters/house_details/views/contact.dart';
import 'package:ccquarters/house_details/views/map.dart';
import 'package:ccquarters/house_details/views/photos.dart';
import 'package:ccquarters/model/house.dart';
import 'package:ccquarters/utils/device_type.dart';
import 'package:ccquarters/common_widgets/icon_360.dart';
import 'package:ccquarters/virtual_tour/gate.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(house.details.title),
        actions: [
          if (house.details.virtualTourId != null)
            Icon360(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => VirtualTourGate(
                          authService: context.read(),
                          tourId: house.details.virtualTourId!,
                          readOnly: true,
                        )));
              },
            ),
        ],
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
                      photos: house.photos.map((e) => e.url).toList(),
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
