import 'package:ccquarters/common/images/asset_image.dart';
import 'package:ccquarters/house_details/gate.dart';
import 'package:ccquarters/list_of_houses/cubit.dart';
import 'package:ccquarters/list_of_houses/like_button.dart';
import 'package:ccquarters/list_of_houses/price_info.dart';
import 'package:ccquarters/model/building_type.dart';
import 'package:ccquarters/model/house.dart';
import 'package:ccquarters/common/widgets/always_visible_label.dart';
import 'package:ccquarters/model/location.dart';
import 'package:ccquarters/common/consts.dart';
import 'package:ccquarters/common/images/image.dart';
import 'package:ccquarters/common/images/inkwell_with_photo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HouseListTile extends StatefulWidget {
  const HouseListTile({super.key, required this.house});

  final House house;

  @override
  State<HouseListTile> createState() => _HouseListTileState();
}

class _HouseListTileState extends State<HouseListTile> {
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
                PriceRoomCountAreaInfo(details: widget.house.details),
                LikeButtonWithTheme(
                  isLiked: widget.house.isLiked,
                  onTap: (isLiked) async {
                    var newValue = await context
                        .read<ListOfHousesCubit>()
                        .likeHouse(widget.house.id, widget.house.isLiked);
                    widget.house.isLiked = newValue;

                    return Future.value(newValue);
                  },
                ),
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
      child: widget.house.photoUrl != null
          ? ImageWidget(
              imageUrl: widget.house.photoUrl!,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(formBorderRadius),
                topRight: Radius.circular(formBorderRadius),
              ),
            )
          : AssetImageWidget(
              fit: BoxFit.contain,
              imagePath: widget.house.getFilenameDependOnBuildingType(),
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
        if (widget.house.photoUrl != null)
          Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  widget.house.details.buildingType.icon,
                  color: Colors.white.withOpacity(0.8),
                  shadows: const [
                    Shadow(color: Colors.black54, blurRadius: 64)
                  ],
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

  _getCityAndDistrict(Location location) {
    var result = location.city;
    if (location.district != null && location.district!.isNotEmpty) {
      result += ", ${location.district}";
    }
    return result;
  }
}
