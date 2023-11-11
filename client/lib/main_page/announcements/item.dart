import 'package:ccquarters/common_widgets/image.dart';
import 'package:ccquarters/house_details/views/view.dart';
import 'package:ccquarters/model/house.dart';
import 'package:ccquarters/utils/consts.dart';
import 'package:ccquarters/common_widgets/inkwell_with_photo.dart';
import 'package:ccquarters/utils/device_type.dart';
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
                  ConstrainedBox(
                    constraints: BoxConstraints(
                        maxHeight: constraints.maxHeight * 0.85,
                        maxWidth: MediaQuery.of(context).size.width *
                            (getDeviceType(context) == DeviceType.mobile
                                ? 0.4
                                : 0.2)),
                    child: ImageWidget(
                      imageUrl: house.photos.first,
                      fit: BoxFit.cover,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(borderRadius),
                          topRight: Radius.circular(borderRadius)),
                    ),
                  ),
                  Text("${house.details.price.toStringAsFixed(0)} zł",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w400)),
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
