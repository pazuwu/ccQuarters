import 'package:ccquarters/house_details/accordion.dart';
import 'package:ccquarters/house_details/contact.dart';
import 'package:ccquarters/house_details/map.dart';
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
      bottomNavigationBar: getDeviceType(context) == DeviceType.mobile
          ? ButtomContactWidget(user: house.user)
          : null,
      appBar: AppBar(
        toolbarHeight: 68,
        leading: IconButton(
          onPressed: () => context.read<MainPageCubit>().goBack(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(house.houseDetails.title),
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

class Photos extends StatefulWidget {
  const Photos({super.key, required this.photos});

  final List<String> photos;
  @override
  State<Photos> createState() => _PhotosState();
}

class _PhotosState extends State<Photos> {
  final controller = PageController(viewportFraction: 0.8, keepPage: true);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
