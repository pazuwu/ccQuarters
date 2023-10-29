import 'dart:ui';

import 'package:ccquarters/model/house.dart';
import 'package:ccquarters/utils/consts.dart';
import 'package:ccquarters/utils/inkwell_with_photo.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';

const textScaler = TextScaler.linear(1.2);

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
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(borderRadius),
              topRight: Radius.circular(borderRadius),
            ),
            child: InkWellWithPhoto(
                imageWidget: Image.network(
                  widget.house.photos.first,
                  height: MediaQuery.of(context).size.height * 0.3,
                  fit: BoxFit.cover,
                ),
                onTap: () {},
                onDoubleTap: () {
                  setState(() {
                    widget.house.isLiked = !widget.house.isLiked;
                  });
                }),
          ),
          Padding(
            padding: const EdgeInsets.all(paddingSize),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: smallPaddingSize),
                  child: Text(
                    "${widget.house.details.price.toStringAsFixed(0)} zł",
                    textScaler: textScaler,
                  ),
                ),
                Expanded(
                  child: Wrap(
                    children: [
                      Text(
                        "${widget.house.details.area.toStringAsFixed(1)} m",
                        textScaler: textScaler,
                      ),
                      const Text(
                        '2',
                        style: TextStyle(
                          fontFeatures: [FontFeature.superscripts()],
                        ),
                        textScaler: textScaler,
                      ),
                      if (widget.house.details.roomCount != null &&
                          widget.house.details.roomCount! > 0)
                        Text(
                          "/${formatRoomCount(widget.house.details.roomCount!)}",
                          textScaler: textScaler,
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: Wrap(
                    spacing: 8.0,
                    runSpacing: 4.0,
                    children: <Widget>[
                      Text(
                        _getCityAndDistrict(widget.house.location),
                        textScaler: textScaler,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: smallPaddingSize),
                  child: LikeButton(
                    bubblesColor: const BubblesColor(
                        dotPrimaryColor: Colors.red,
                        dotSecondaryColor: Colors.redAccent,
                        dotThirdColor: Colors.redAccent,
                        dotLastColor: Colors.redAccent),
                    circleSize: 0,
                    isLiked: widget.house.isLiked,
                    size: 36,
                    likeBuilder: (bool isLiked) {
                      return Icon(
                        Icons.favorite,
                        color: isLiked ? Colors.red : Colors.grey,
                        size: 36,
                      );
                    },
                    onTap: (isLiked) {
                      widget.house.isLiked = !isLiked;
                      return Future.value(!isLiked);
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  _getCityAndDistrict(Location location) {
    var result = location.city;
    if (location.district != null && location.district!.isNotEmpty) {
      result += "/${location.district}";
    }
    return result;
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
