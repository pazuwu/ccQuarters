import 'package:flutter/material.dart';
import 'go_back_next_buttons.dart';
import 'header.dart';

class ViewWithHeader extends StatelessWidget {
  const ViewWithHeader({
    super.key,
    required this.title,
    required this.inBetweenWidget,
    required this.goBackOnPressed,
    required this.nextOnPressed,
  });

  final String title;
  final Widget inBetweenWidget;
  final Function()? goBackOnPressed;
  final Function() nextOnPressed;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverFillRemaining(
          hasScrollBody: true,
          child: Column(
            children: [
              Header(title: title),
              inBetweenWidget,
              GoBackNextButtons(
                goBackOnPressed: goBackOnPressed,
                nextOnPressed: nextOnPressed,
              )
            ],
          ),
        ),
      ],
    );
  }
}
