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
    this.hasScrollBody = false,
    required this.goBackOnPressed,
    required this.nextOnPressed,
    this.isLastPage = false,
  }) : super(key: key);

  final String title;
  final Widget inBetweenWidget;
  final bool scrollable;
  final bool hasScrollBody;
  final Function()? goBackOnPressed;
  final Function() nextOnPressed;
  final bool isLastPage;

  Widget _buildMainColumn(BuildContext context) {
    return Column(
      children: [
        Header(title: title),
        inBetweenWidget,
        GoBackNextButtons(
          goBackOnPressed: goBackOnPressed,
          nextOnPressed: nextOnPressed,
          isLastPage: isLastPage,
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
                hasScrollBody: hasScrollBody,
                child: _buildMainColumn(context),
              ),
            ],
          )
        : _buildMainColumn(context);
  }
}