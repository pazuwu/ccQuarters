import 'package:ccquarters/list_of_houses/item.dart';
import 'package:ccquarters/model/house.dart';
import 'package:ccquarters/model/user.dart';
import 'package:ccquarters/utils/consts.dart';
import 'package:ccquarters/utils/device_type.dart';
import 'package:flutter/material.dart';

class ListOfHouses extends StatelessWidget {
  const ListOfHouses({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ogłoszenia na wynajem"),
      ),
      body: Center(
        child: Container(
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width *
                  (getDeviceType(context) == DeviceType.web ? 0.5 : 1)),
          child: Padding(
            padding: const EdgeInsets.only(
                left: smallPaddingSize, right: smallPaddingSize),
            child: ListView.builder(
              itemCount: 30,
              itemBuilder: (context, index) {
                return LayoutBuilder(
                  builder: (context, constraints) => HouseListTile(
                    house: House(Location(), HouseDetails(), User()),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
