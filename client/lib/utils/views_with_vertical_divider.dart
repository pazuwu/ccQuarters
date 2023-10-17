import 'package:flutter/material.dart';

class ViewsWithVerticalDivider extends StatelessWidget {
  const ViewsWithVerticalDivider({
    super.key,
    required this.firstView,
    required this.secondView,
  });

  final Widget firstView;
  final Widget secondView;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          firstView,
          VerticalDivider(thickness: 1, color: Colors.grey.shade300),
          secondView,
        ],
      ),
    );
  }
}