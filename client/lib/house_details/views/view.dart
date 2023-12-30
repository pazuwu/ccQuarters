import 'package:ccquarters/house_details/cubit.dart';
import 'package:ccquarters/house_details/views/accordion.dart';
import 'package:ccquarters/house_details/views/contact.dart';
import 'package:ccquarters/house_details/views/map.dart';
import 'package:ccquarters/house_details/views/photos.dart';
import 'package:ccquarters/model/detailed_house.dart';
import 'package:ccquarters/services/auth/service.dart';
import 'package:ccquarters/common/device_type.dart';
import 'package:ccquarters/common/widgets/icon_360.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class DetailsView extends StatelessWidget {
  const DetailsView(
      {super.key, required this.house, this.isOwnedByCurrentUser = false});

  final DetailedHouse house;
  final bool isOwnedByCurrentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const Key("details_view"),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 68,
        leading: MediaQuery.of(context).orientation == Orientation.portrait
            ? IconButton(
                onPressed: () {
                  var previousRoute = GoRouterState.of(context).extra;
                  if (previousRoute == null) {
                    context.pop();
                  } else {
                    context.go(previousRoute.toString());
                  }
                },
                icon: const Icon(Icons.arrow_back),
              )
            : null,
        title: Text(house.details.title),
        actions: [
          if (house.details.virtualTourId != null)
            Icon360(
              onPressed: () => _showVirtualTour(context),
            ),
          if (house.user.id == context.read<BaseAuthService>().currentUserId)
            _buildPopUpMenuButton(context),
        ],
      ),
      body: Inside(house: house),
    );
  }

  _showVirtualTour(BuildContext context) {
    context.push('/tours/${house.details.virtualTourId}');
  }

  PopupMenuButton _buildPopUpMenuButton(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (context) => [
        const PopupMenuItem<int>(
          value: 0,
          child: Text(
            "Edytuj ogłoszenie",
          ),
        ),
        const PopupMenuItem<int>(
          value: 1,
          child: Text(
            "Usuń ogłoszenie",
          ),
        ),
      ],
      onSelected: (item) => {
        if (item == 0)
          context.read<HouseDetailsCubit>().goToEditHouse()
        else if (item == 1)
          _showDeleteHouseDialog(context)
      },
    );
  }

  _showDeleteHouseDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Edytuj ogłoszenie"),
            content: const Text("Czy na pewno chcesz usunąć ogłoszenie?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("Nie"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text("Tak"),
              ),
            ],
          );
        }).then((delete) {
      if (delete) {
        context.read<HouseDetailsCubit>().deleteHouse().then((value) {
          if (value) {
            _showDialogWithMessage(context, "Ogłoszenie zostało usunięte.");
            Navigator.pop(context);
          } else {
            _showDialogWithMessage(context,
                "Nie udało się usunąć ogłoszenia. Spróbuj ponownie później.");
          }
        });
      }
    });
  }

  _showDialogWithMessage(BuildContext context, String error) {
    showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: Text(error),
        actions: <Widget>[
          Center(
            child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK')),
          )
        ],
      ),
    );
  }
}

class Inside extends StatelessWidget {
  const Inside({
    super.key,
    required this.house,
  });

  final DetailedHouse house;

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
        ],
      ),
    );
  }
}
