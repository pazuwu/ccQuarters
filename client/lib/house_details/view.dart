import 'package:ccquarters/house_details/accordion.dart';
import 'package:ccquarters/house_details/map.dart';
import 'package:ccquarters/main_page/cubit.dart';
import 'package:ccquarters/model/house.dart';
import 'package:ccquarters/utils/device_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailsView extends StatefulWidget {
  const DetailsView({super.key, required this.house});

  final House house;
  @override
  State<DetailsView> createState() => _DetailsViewState();
}

class _DetailsViewState extends State<DetailsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 68,
        leading: IconButton(
          onPressed: () => context.read<MainPageCubit>().goBack(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(widget.house.houseDetails.title),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: getDeviceType(context) == DeviceType.web
                ? BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width / 2)
                : const BoxConstraints(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Photos(
                //   photos: widget.house.photos,
                // ),
                AccordionPage(
                  house: widget.house,
                ),
                if (widget.house.location.geoX != null &&
                    widget.house.location.geoY != null)
                  MapCard(location: widget.house.location),
              ],
            ),
          ),
        ),
      ),
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
