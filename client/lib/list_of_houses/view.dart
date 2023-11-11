import 'package:ccquarters/list_of_houses/filters/filters.dart';
import 'package:ccquarters/list_of_houses/item.dart';
import 'package:ccquarters/model/filter.dart';
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
      body: RefreshIndicator(
        onRefresh: () {
          return Future.delayed(const Duration(seconds: 1));
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (getDeviceType(context) == DeviceType.web)
              Container(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.25),
                child: FilterForm(filters: HouseFilter()),
              ),
            Container(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width *
                      (getDeviceType(context) == DeviceType.web ? 0.5 : 1)),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: paddingSize, right: paddingSize),
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: SizedBox(
                        child: Filters(filters: HouseFilter()),
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return LayoutBuilder(
                            builder: (context, constraints) => HouseListTile(
                              house: House(Location(), HouseDetails(), User()),
                            ),
                          );
                        },
                        childCount: 30,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
