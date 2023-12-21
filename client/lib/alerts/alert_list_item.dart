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
        endActionPane: _buildActionPane(),
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

  ActionPane _buildActionPane() {
    return ActionPane(
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
            if (alert.offerType != null)
              Text("${alert.offerType!.toString()} ${_getBuildingTypeString()}",
                  style: const TextStyle(fontWeight: FontWeight.w500)),
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

  _getBuildingTypeString() {
    switch (alert.buildingType) {
      case BuildingType.apartment:
        return "mieszkania";
      case BuildingType.house:
        return "domu";
      case BuildingType.room:
        return "pokoju";
      case null:
        return "";
    }
  }

  _buildLocation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(
          color: Colors.grey,
        ),
        if (alert.voivodeship != null)
          _getRichTextWithStyle("Województwo: ", alert.voivodeship!),
        if (alert.cities != null && alert.cities!.isNotEmpty)
          if (alert.cities!.length == 1)
            _getRichTextWithStyle("Miasto: ", alert.cities!.first)
          else
            _getRichTextWithStyle(
              "Miasta: ",
              _getStringOfList(alert.cities!),
            ),
        if (alert.districts != null && alert.districts!.isNotEmpty)
          if (alert.districts!.length == 1)
            _getRichTextWithStyle("Dzielnica: ", alert.districts!.first)
          else
            _getRichTextWithStyle(
              "Dzielnice: ",
              _getStringOfList(alert.districts!),
            )
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
          _getRichTextWithStyle(
              "Cena: ", _getPriceString(alert.minPrice, alert.maxPrice)),
        if (alert.minPricePerM2 != null || alert.maxPricePerM2 != null)
          _getRichTextWithStyle("Cena za m2: ",
              _getPriceString(alert.minPricePerM2, alert.maxPricePerM2))
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
          _getRichTextWithStyle("Powierzchnia: ", _getAreaString()),
        if (alert.minRoomCount != null || alert.maxRoomCount != null)
          _getRichTextWithStyle("Liczba pokoi: ", _getRoomString()),
        if (alert.minFloor != null ||
            (alert.floors != null && alert.floors!.isNotEmpty))
          _getRichTextWithStyle("Piętro: ", _getFloorString()),
      ],
    );
  }

  RichText _getRichTextWithStyle(String firstText, String secondText) {
    return RichText(
      text: TextSpan(
        text: firstText,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 15,
        ),
        children: <TextSpan>[
          TextSpan(
            text: secondText,
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  String _getStringOfList(List<String> list) {
    String result = "";
    for (String s in list) {
      result += "$s, ";
    }
    return result.substring(0, result.length - 2);
  }

  String _getPriceString(double? minPrice, double? maxPrice) {
    String result = "";

    if (minPrice != null) {
      result += "od $minPrice zł ";
    }
    if (maxPrice != null) {
      result += "do $maxPrice zł";
    }

    return result;
  }

  String _getAreaString() {
    String result = "";
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
    String result = "";
    if (alert.minRoomCount != null) {
      result += "od ${alert.minRoomCount} ";
    }
    if (alert.maxRoomCount != null) {
      result += "do ${alert.maxRoomCount}";
    }
    return result;
  }

  String _getFloorString() {
    String result = "";
    var floors = alert.floors?.map((e) => e.toString()).toList() ?? [];
    if (alert.minFloor != null) {
      floors.add("powyżej ${alert.minFloor}");
    }
    result += "${_getStringOfList(floors)} ";
    return result;
  }
}
