import 'package:ccquarters/common/consts.dart';
import 'package:ccquarters/common/messages/delete_dialog.dart';
import 'package:ccquarters/common/messages/dialog_with_message.dart';
import 'package:ccquarters/house_details/cubit.dart';
import 'package:ccquarters/house_details/views/accordion.dart';
import 'package:ccquarters/house_details/views/contact.dart';
import 'package:ccquarters/house_details/views/map.dart';
import 'package:ccquarters/house_details/views/photos.dart';
import 'package:ccquarters/list_of_houses/like_button.dart';
import 'package:ccquarters/list_of_houses/price_info.dart';
import 'package:ccquarters/model/detailed_house.dart';
import 'package:ccquarters/services/auth/service.dart';
import 'package:ccquarters/common/device_type.dart';
import 'package:ccquarters/common/widgets/icon_360.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class DetailsView extends StatelessWidget {
  const DetailsView({
    super.key,
    required this.house,
    required this.goBack,
    this.isOwnedByCurrentUser = false,
  });

  final DetailedHouse house;
  final bool isOwnedByCurrentUser;
  final Function(BuildContext) goBack;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const Key("details_view"),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 68,
        leading: MediaQuery.of(context).orientation == Orientation.portrait
            ? IconButton(
                onPressed: () => goBack(context),
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
    context.go(
      '/tours/${house.details.virtualTourId}',
      extra: GoRouter.of(context).routeInformationProvider.value.uri,
    );
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
          showDeleteDialog(
            context,
            "ogłoszenia",
            "ogłoszenie",
            () {
              context.read<HouseDetailsCubit>().deleteHouse().then(
                (value) {
                  if (value) {
                    showDialogWithMessage(
                      context: context,
                      title: "Ogłoszenie zostało usunięte.",
                      onOk: () => goBack(context),
                    );
                  } else {
                    showDialogWithMessage(
                      context: context,
                      title: "Nie udało się usunąć ogłoszenia.",
                      content: "Spróbuj ponownie później.",
                    );
                  }
                },
              );
            },
          ),
      },
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
                  if (getDeviceType(context) == DeviceType.mobile)
                    _buildPriceInfo(context),
                  if (house.photos.isNotEmpty)
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
            ContactWidget(
              user: house.user,
              additionalWidget: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Divider(
                      thickness: 1,
                      height: 1,
                      color: Colors.grey,
                    ),
                  ),
                  _buildPriceInfo(context),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPriceInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: largePaddingSize,
        right: largePaddingSize,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          PriceRoomCountAreaInfo(details: house.details),
          LikeButtonWithTheme(
            isLiked: house.isLiked,
            onTap: (isLiked) async {
              var newValue = await context
                  .read<HouseDetailsCubit>()
                  .likeHouse(house.id, house.isLiked);
              house.isLiked = newValue;
              return Future.value(newValue);
            },
            size: 40,
          ),
        ],
      ),
    );
  }
}
