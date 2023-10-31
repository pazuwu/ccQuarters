import 'package:ccquarters/model/house.dart';
import 'package:ccquarters/model/user.dart';
import 'package:flutter/material.dart';
import 'item.dart';

class AnnouncementList extends StatelessWidget {
  const AnnouncementList({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(8.0),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) => LayoutBuilder(
              builder: (context, constraints) => AnnouncementItem(
                    house: House(Location(), HouseDetails(), User()),
                  )),
          itemCount: 30,
        ),
      ),
    );
  }
}
