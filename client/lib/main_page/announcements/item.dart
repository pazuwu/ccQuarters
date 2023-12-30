import 'package:ccquarters/common/images/asset_image.dart';
import 'package:ccquarters/common/images/image.dart';
import 'package:ccquarters/house_details/gate.dart';
import 'package:ccquarters/model/house.dart';
import 'package:ccquarters/common/consts.dart';
import 'package:ccquarters/common/images/inkwell_with_photo.dart';
import 'package:ccquarters/common/device_type.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class HouseItem extends StatelessWidget {
  HouseItem({
    super.key,
    required this.house,
  });

  final House house;
  final NumberFormat _formatter = NumberFormat("#,##0", "pl-PL");

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Card(
        shadowColor: Theme.of(context).colorScheme.secondary,
        elevation: elevation,
        margin: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(formBorderRadius),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(formBorderRadius),
          child: InkWellWithPhoto(
            imageWidget: Column(
              children: [
                _buildPhoto(constraints, context),
                _buildLabel(constraints, context),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HouseDetailsGate(
                    houseId: house.id,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPhoto(BoxConstraints constraints, BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: constraints.maxHeight - 52,
        maxWidth: MediaQuery.of(context).size.width *
            (getDeviceType(context) == DeviceType.mobile ? 0.4 : 0.2),
      ),
      child: house.photoUrl != null
          ? ImageWidget(
              imageUrl: house.photoUrl!,
              fit: BoxFit.cover,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(formBorderRadius),
                topRight: Radius.circular(formBorderRadius),
              ),
            )
          : AssetImageWidget(
              imagePath: house.getFilenameDependOnBuildingType(),
              fit: BoxFit.contain,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(formBorderRadius),
                topRight: Radius.circular(formBorderRadius),
              ),
            ),
    );
  }

  Widget _buildLabel(BoxConstraints constraints, BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: 36,
        minWidth: MediaQuery.of(context).size.width *
            (getDeviceType(context) == DeviceType.mobile ? 0.4 : 0.2),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (house.details.roomCount != null &&
                  house.details.roomCount != 0)
                _buildRoomCount(context),
              const SizedBox(
                width: 15,
              ),
              _buildPrice(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoomCount(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          house.details.roomCount!.toString(),
          style: Theme.of(context).textTheme.labelLarge?.copyWith(fontSize: 16),
        ),
        const SizedBox(
          width: 4,
        ),
        Icon(
          FontAwesomeIcons.bed,
          size: 12,
          color: Colors.blueGrey.shade700,
        ),
      ],
    );
  }

  Widget _buildPrice(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          FontAwesomeIcons.coins,
          color: Colors.blueGrey.shade700,
          size: 16,
        ),
        const SizedBox(
          width: 8,
        ),
        Text(
          "${_formatter.format(house.details.price)} zł",
          style: Theme.of(context)
              .textTheme
              .labelLarge
              ?.copyWith(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
