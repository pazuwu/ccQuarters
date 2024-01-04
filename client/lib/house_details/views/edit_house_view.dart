import 'package:ccquarters/add_house/gate.dart';
import 'package:ccquarters/house_details/cubit.dart';
import 'package:ccquarters/model/house/detailed_house.dart';
import 'package:ccquarters/model/house/new_house.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    return BackButtonListener(
      onBackButtonPressed: () async {
        context.read<HouseDetailsCubit>().goBackToHouseDetails();
        return true;
      },
      child: AddHouseGate(house: _house),
    );
  }
}
