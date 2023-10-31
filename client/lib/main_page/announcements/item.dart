import 'package:ccquarters/main_page/cubit.dart';
import 'package:ccquarters/model/house.dart';
import 'package:ccquarters/utils/inkwell_with_photo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utils/consts.dart';

class AnnouncementItem extends StatelessWidget {
  const AnnouncementItem(
      {super.key,
      required this.prize,
      required this.image,
      required this.height,
      required this.house});

  final double prize;
  final Image image;
  final House house;
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
            onTap: () {
              context.read<MainPageCubit>().goToDetails(house);
            },
          ),
        ),
      ),
    );
  }
}
