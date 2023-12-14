import 'package:ccquarters/add_house/gate.dart';
import 'package:ccquarters/house_details/cubit.dart';
import 'package:ccquarters/model/detailed_house.dart';
import 'package:ccquarters/model/new_house.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditHouseView extends StatelessWidget {
  const EditHouseView({super.key, required this.house});

  final DetailedHouse house;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edytuj ogłoszenie"),
        leading: BackButton(
          onPressed: context.read<HouseDetailsCubit>().goBackToHouseDetails,
        ),
        actions: [
          IconButton(
            onPressed: () =>
                context.read<HouseDetailsCubit>().updateHouse(house),
            icon: const Icon(Icons.check),
          )
        ],
      ),
      body: AddHouseGate(
        house: NewHouse.fromDetailedHouse(house),
      ),
    );
  }
}
