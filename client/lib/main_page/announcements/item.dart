import 'package:ccquarters/utils/inkwell_with_photo.dart';
import 'package:flutter/material.dart';

import '../../utils/consts.dart';

class AnnouncementItem extends StatelessWidget {
  const AnnouncementItem(
      {super.key,
      required this.prize,
      required this.image,
      required this.url,
      required this.height});

  final double prize;
  final Image image;
  final String url;
  final double height;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Card(
        shadowColor: Theme.of(context).colorScheme.secondary,
        elevation: elevation,
        margin: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: InkWellWithPhoto(
            imageWidget: Column(
              children: [
                image,
                Text("${prize.toStringAsFixed(2)} zł", style: labelStyle),
              ],
            ),
            onTap: () {},
          ),
        ),
      ),
    );
  }
}
