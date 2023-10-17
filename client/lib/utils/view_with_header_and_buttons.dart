// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'go_back_next_buttons.dart';
import 'header.dart';

class ViewWithHeader extends StatelessWidget {
  const ViewWithHeader({
    Key? key,
    required this.title,
    required this.inBetweenWidget,
    this.scrollable = true,
    required this.goBackOnPressed,
    required this.nextOnPressed,
  }) : super(key: key);

  final String title;
  final Widget inBetweenWidget;
  final bool scrollable;
  final Function()? goBackOnPressed;
  final Function() nextOnPressed;

  Widget _buildMainColumn(BuildContext context) {
    return Column(
      children: [
        Header(title: title),
        inBetweenWidget,
        GoBackNextButtons(
          goBackOnPressed: goBackOnPressed,
          nextOnPressed: nextOnPressed,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return scrollable
        ? CustomScrollView(
            slivers: [
              SliverFillRemaining(
                  hasScrollBody: true, child: _buildMainColumn(context)),
            ],
          )
        : _buildMainColumn(context);
  }
}
