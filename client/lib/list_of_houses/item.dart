import 'package:ccquarters/house_details/gate.dart';
import 'package:ccquarters/list_of_houses/cubit.dart';
import 'package:ccquarters/model/building_type.dart';
import 'package:ccquarters/model/house.dart';
import 'package:ccquarters/common_widgets/always_visible_label.dart';
import 'package:ccquarters/model/house_details.dart';
import 'package:ccquarters/model/location.dart';
import 'package:ccquarters/utils/consts.dart';
import 'package:ccquarters/common_widgets/image.dart';
import 'package:ccquarters/common_widgets/inkwell_with_photo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';

class HouseListTile extends StatefulWidget {
  const HouseListTile({super.key, required this.house});

  final House house;

  @override
  State<HouseListTile> createState() => _HouseListTileState();
}

class _HouseListTileState extends State<HouseListTile> {
  final NumberFormat _formatter = NumberFormat("#,##0", "pl-PL");

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Theme.of(context).colorScheme.secondary,
      elevation: elevation,
      margin: const EdgeInsets.only(top: 8, bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(formBorderRadius),
      ),
      child: Column(
        children: [
          InkWellWithPhoto(
            imageWidget: _buildPhoto(context),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HouseDetailsGate(
                    houseId: widget.house.id,
                  ),
                ),
              );
            },
            onDoubleTap: () {
              setState(() {
                if (!widget.house.isLiked) {
                  widget.house.isLiked = !widget.house.isLiked;
                }
              });
            },
            inkWellChild: _buildCityAndDistrictLabel(context),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
                largePaddingSize, paddingSize, largePaddingSize, paddingSize),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfo(),
                _buildLikeButton(),
              ],
            ),
          )
        ],
      ),
    );
  }

  ConstrainedBox _buildPhoto(BuildContext context) {
    return ConstrainedBox(
      constraints:
          BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.3),
      child: ImageWidget(
        imageUrl: widget.house.photo.url,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(formBorderRadius),
          topRight: Radius.circular(formBorderRadius),
        ),
      ),
    );
  }

  Column _buildCityAndDistrictLabel(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                _getIconForHouseType(widget.house.details),
                color: Colors.white.withOpacity(0.8),
                shadows: const [Shadow(color: Colors.black54, blurRadius: 64)],
              ),
            )),
        Expanded(child: Container()),
        AlwaysVisibleLabel(
          background: Colors.black.withOpacity(0.5),
          child: Row(
            children: [
              const SizedBox(
                width: 1,
              ),
              Icon(
                Icons.location_pin,
                color: Colors.white.withOpacity(0.75),
                size: 12,
              ),
              const SizedBox(
                width: 4,
              ),
              Text(
                _getCityAndDistrict(widget.house.location),
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Column _buildInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${_formatter.format(widget.house.details.price)} zł",
          textScaler: const TextScaler.linear(1.4),
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        Text(
          _getAreaAndRoomCount(widget.house.details),
          style: TextStyle(
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }

  LikeButton _buildLikeButton() {
    return LikeButton(
      bubblesColor: const BubblesColor(
          dotPrimaryColor: Colors.red,
          dotSecondaryColor: Colors.redAccent,
          dotThirdColor: Colors.redAccent,
          dotLastColor: Colors.redAccent),
      circleSize: 0,
      isLiked: widget.house.isLiked,
      size: 32,
      likeBuilder: (bool isLiked) {
        return Icon(
          Icons.favorite,
          color: isLiked ? Colors.red : Colors.grey,
          size: 32,
        );
      },
      onTap: (isLiked) async {
        var newValue = await context
            .read<ListOfHousesCubit>()
            .likeHouse(widget.house.id, widget.house.isLiked);
        widget.house.isLiked = newValue;

        return Future.value(newValue);
      },
    );
  }

  _getCityAndDistrict(Location location) {
    var result = location.city;
    if (location.district != null && location.district!.isNotEmpty) {
      result += ", ${location.district}";
    }
    return result;
  }

  _getAreaAndRoomCount(HouseDetails details) {
    var result = "${details.area.toStringAsFixed(1)} m\u00B2";
    if (widget.house.details.roomCount != null &&
        widget.house.details.roomCount! > 0) {
      result += ", ${formatRoomCount(widget.house.details.roomCount!)}";
    }
    return result;
  }

  _getIconForHouseType(HouseDetails details) {
    switch (details.buildingType) {
      case BuildingType.apartment:
        return Icons.apartment;
      case BuildingType.house:
        return Icons.home;
      case BuildingType.room:
        return Icons.bed;
    }
  }
}

formatRoomCount(int count) {
  if (count > 4) {
    return "$count pokoi";
  } else if (count == 1) {
    return "$count pokój";
  } else {
    return "$count pokoje";
  }
}
