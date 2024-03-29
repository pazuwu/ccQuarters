import 'package:ccquarters/model/houses/house_details.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PriceRoomCountAreaInfo extends StatefulWidget {
  const PriceRoomCountAreaInfo({
    super.key,
    required this.details,
    this.priceTextScale = 1.4,
    this.roomCountTextScale = 1.0,
  });

  final HouseDetails details;
  final double priceTextScale;
  final double roomCountTextScale;

  @override
  State<PriceRoomCountAreaInfo> createState() => _PriceRoomCountAreaInfoState();
}

class _PriceRoomCountAreaInfoState extends State<PriceRoomCountAreaInfo> {
  final NumberFormat _formatter = NumberFormat("#,##0", "pl-PL");

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${_formatter.format(widget.details.price)} zł",
          textScaler: TextScaler.linear(widget.priceTextScale),
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        Text(
          _getAreaAndRoomCount(widget.details),
          textScaler: TextScaler.linear(widget.roomCountTextScale),
          style: TextStyle(
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }

  _getAreaAndRoomCount(HouseDetails details) {
    var result = "${details.area.toStringAsFixed(1)} m\u00B2";
    if (details.roomCount != null && details.roomCount! > 0) {
      result += ", ${_formatRoomCount(details.roomCount!)}";
    }
    return result;
  }

  _formatRoomCount(int count) {
    if (count > 4) {
      return "$count pokoi";
    } else if (count == 1) {
      return "$count pokój";
    } else {
      return "$count pokoje";
    }
  }
}
