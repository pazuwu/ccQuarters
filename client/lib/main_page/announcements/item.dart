import 'package:ccquarters/house_details/view.dart';
import 'package:ccquarters/model/house.dart';
import 'package:ccquarters/utils/consts.dart';
import 'package:ccquarters/utils/inkwell_with_photo.dart';
import 'package:flutter/material.dart';

class AnnouncementItem extends StatelessWidget {
  const AnnouncementItem({
    super.key,
    required this.house,
  });
  final House house;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => FittedBox(
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
                  Image.network(
                    house.photos.first,
                    height: constraints.maxHeight * 0.85,
                    fit: BoxFit.fitHeight,
                  ),
                  Text("${house.details.price.toStringAsFixed(0)} zł",
                      style: labelStyle),
                ],
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DetailsView(house: house)));
              },
            ),
          ),
        ),
      ),
    );
  }
}
