import 'package:ccquarters/add_house/gate.dart';
import 'package:ccquarters/model/detailed_house.dart';
import 'package:ccquarters/model/new_house.dart';
import 'package:flutter/material.dart';

class EditHouseView extends StatefulWidget {
  const EditHouseView({super.key, required this.house});

  final DetailedHouse house;

  @override
  State<EditHouseView> createState() => _EditHouseViewState();
}

class _EditHouseViewState extends State<EditHouseView> {
  late NewHouse _house;

  @override
  void initState() {
    _house = NewHouse.fromDetailedHouse(widget.house);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AddHouseGate(house: _house);
  }
}
