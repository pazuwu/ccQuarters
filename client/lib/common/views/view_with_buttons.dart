import 'package:flutter/material.dart';

import '../widgets/go_back_next_buttons.dart';

class ViewWithButtons extends StatelessWidget {
  const ViewWithButtons({
    Key? key,
    required this.inBetweenWidget,
    this.scrollable = true,
    this.hasScrollBody = false,
    required this.goBackOnPressed,
    required this.nextOnPressed,
    this.isLastPage = false,
  }) : super(key: key);

  final Widget inBetweenWidget;
  final bool scrollable;
  final bool hasScrollBody;
  final Function()? goBackOnPressed;
  final Function()? nextOnPressed;
  final bool isLastPage;

  Widget _buildMainColumn(BuildContext context) {
    return Column(
      children: [
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
