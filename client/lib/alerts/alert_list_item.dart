import 'package:ccquarters/alerts/cubit.dart';
import 'package:ccquarters/model/alert.dart';
import 'package:ccquarters/model/building_type.dart';
import 'package:ccquarters/utils/consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class AlertListItem extends StatelessWidget {
  const AlertListItem({super.key, required this.alert});

  final Alert alert;
  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Theme.of(context).colorScheme.secondary,
      elevation: elevation,
      margin: const EdgeInsets.all(8),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (context) {
                context.read<AlertsPageCubit>().goToAlertPage(alert);
              },
              backgroundColor: Colors.blueGrey[300]!,
              foregroundColor: Colors.white,
              icon: Icons.edit,
            ),
            SlidableAction(
              onPressed: (context) {
                context.read<AlertsPageCubit>().deleteAlert(alert);
              },
              backgroundColor: Colors.blueGrey,
              foregroundColor: Colors.white,
              icon: Icons.delete,
            ),
          ],
        ),
        child: ListTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_canBuildType()) _buildType(),
              if (_canBuildLocation()) _buildLocation(),
              if (_canBuildPrice()) _buildPrice(),
              if (_canBuildDetails()) _buildDetails(),
            ],
          ),
        ),
      ),
    );
  }

  bool _canBuildType() => alert.offerType != null || alert.buildingType != null;
  bool _canBuildLocation() =>
      alert.voivodeship != null ||
      (alert.cities != null && alert.cities!.isNotEmpty) ||
      (alert.districts != null && alert.districts!.isNotEmpty);
  bool _canBuildPrice() =>
      alert.minPrice != null ||
      alert.maxPrice != null ||
      alert.minPricePerM2 != null ||
      alert.maxPricePerM2 != null;
  bool _canBuildDetails() =>
      alert.minArea != null ||
      alert.maxArea != null ||
      alert.minRoomCount != null ||
      alert.maxRoomCount != null ||
      alert.minFloor != null ||
      (alert.floors != null && alert.floors!.isNotEmpty);

  _buildType() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (alert.offerType != null) Text(alert.offerType!.toString()),
            if (alert.buildingType != null)
              Icon(
                alert.buildingType!.icon,
                size: 32.0,
              ),
          ],
        ),
      ],
    );
  }

  _buildLocation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(
          color: Colors.grey,
        ),
        if (alert.voivodeship != null)
          Text(
            "Województwo ${alert.voivodeship!}",
          ),
        if (alert.cities != null && alert.cities!.isNotEmpty)
          Text("Miasta: ${_getStringOfList(alert.cities!)}"),
        if (alert.districts != null && alert.districts!.isNotEmpty)
          Text("Dzielnice: ${_getStringOfList(alert.districts!)}"),
      ],
    );
  }

  _buildPrice() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(
          color: Colors.grey,
        ),
        if (alert.minPrice != null || alert.maxPrice != null)
          Text(_getPriceString(alert.minPrice, alert.maxPrice, false)),
        if (alert.minPricePerM2 != null || alert.maxPricePerM2 != null)
          Text(_getPriceString(alert.minPricePerM2, alert.maxPricePerM2, true)),
      ],
    );
  }

  _buildDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(
          color: Colors.grey,
        ),
        if (alert.minArea != null || alert.maxArea != null)
          Text(_getAreaString()),
        if (alert.minRoomCount != null || alert.maxRoomCount != null)
          Text(_getRoomString()),
        if (alert.minFloor != null ||
            (alert.floors != null && alert.floors!.isNotEmpty))
          Text(_getFloorString()),
      ],
    );
  }

  String _getStringOfList(List<String> list) {
    String result = "";
    for (String s in list) {
      result += "$s, ";
    }
    return result.substring(0, result.length - 2);
  }

  String _getPriceString(double? minPrice, double? maxPrice, bool isPerM2) {
    String result = "Cena ";

    if (isPerM2) {
      result += "za m2 ";
    }
    if (minPrice != null) {
      result += "od $minPrice zł ";
    }
    if (maxPrice != null) {
      result += "do $maxPrice zł";
    }

    return result;
  }

  String _getAreaString() {
    String result = "Powierzchnia: ";
    if (alert.minArea != null) {
      result += "od ${alert.minArea} ";
    }
    if (alert.maxArea != null) {
      result += "do ${alert.maxArea} ";
    }
    result += "m\u00B2";
    return result;
  }

  String _getRoomString() {
    String result = "Liczba pokoi:";
    if (alert.minRoomCount != null) {
      result += " od ${alert.minRoomCount}";
    }
    if (alert.maxRoomCount != null) {
      result += " do ${alert.maxRoomCount}";
    }
    return result;
  }

  String _getFloorString() {
    String result = "Piętro: ";
    var floors = alert.floors?.map((e) => e.toString()).toList() ?? [];
    if (alert.minFloor != null) {
      floors.add("powyżej ${alert.minFloor}");
    }
    result += "${_getStringOfList(floors)} ";
    return result;
  }
}
