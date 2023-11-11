import 'package:ccquarters/list_of_houses/view.dart';
import 'package:ccquarters/utils/consts.dart';
import 'package:ccquarters/common_widgets/shadow.dart';
import 'package:ccquarters/utils/device_type.dart';
import 'package:flutter/material.dart';
import 'list.dart';

class AnnouncementsContainer extends StatelessWidget {
  const AnnouncementsContainer({super.key, required this.title});

  final String title;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(getPaddingSizeForMainPage(context)),
        child: Shadow(
          color: Theme.of(context).colorScheme,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ListLabel(title: title),
                const AnnouncementList(),
                SeeMoreButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ListOfHouses()));
                  },
                ),
              ],
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
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0),
        child: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}

class SeeMoreButton extends StatelessWidget {
  const SeeMoreButton({
    super.key,
    required this.onPressed,
  });

  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: TextButton(
        onPressed: onPressed,
        child: const Text(
          "Zobacz wszystkie",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
