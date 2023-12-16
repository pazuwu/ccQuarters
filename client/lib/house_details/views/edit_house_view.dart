import 'package:ccquarters/add_house/gate.dart';
import 'package:ccquarters/house_details/cubit.dart';
import 'package:ccquarters/model/detailed_house.dart';
import 'package:ccquarters/model/new_house.dart';
import 'package:ccquarters/model/photo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditHouseView extends StatefulWidget {
  const EditHouseView({super.key, required this.house});

  final DetailedHouse house;

  @override
  State<EditHouseView> createState() => _EditHouseViewState();
}

class _EditHouseViewState extends State<EditHouseView> {
  final List<Photo> _deletedPhotos = [];
  late NewHouse _house;

  @override
  void initState() {
    _house = NewHouse.fromDetailedHouse(widget.house);
    super.initState();
  }

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
            onPressed: () => context.read<HouseDetailsCubit>().updateHouse(
                  widget.house,
                  _house.newPhotos,
                  _deletedPhotos,
                ),
            icon: const Icon(Icons.check),
          )
        ],
      ),
      body: AddHouseGate(house: _house),
    );
  }
}
