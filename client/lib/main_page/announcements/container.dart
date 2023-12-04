import 'package:ccquarters/list_of_houses/gate.dart';
import 'package:ccquarters/model/house.dart';
import 'package:ccquarters/utils/consts.dart';
import 'package:ccquarters/common_widgets/shadow.dart';
import 'package:ccquarters/utils/device_type.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'list.dart';

class AnnouncementsContainer extends StatelessWidget {
  const AnnouncementsContainer({
    super.key,
    required this.title,
    required this.pagingController,
    required this.getHouses,
  });

  final String title;
  final PagingController<int, House> pagingController;
  final Future<List<House>> Function(int, int) getHouses;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(getPaddingSizeForMainPage(context)),
        child: Shadow(
          color: Theme.of(context).colorScheme,
          child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ListOfHousesGate()));
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ListLabel(title: title),
                  AnnouncementList(
                    pagingController: pagingController,
                    getHouses: getHouses,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ListLabel extends StatelessWidget {
  const ListLabel({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const Icon(Icons.arrow_forward),
        ],
      ),
    );
  }
}
