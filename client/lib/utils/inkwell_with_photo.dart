import 'package:flutter/material.dart';

class InkWellWithPhoto extends StatelessWidget {
  const InkWellWithPhoto({
    super.key,
    required this.imageWidget,
    required this.onTap,
    this.inkWellChild,
  });

  final Widget imageWidget;
  final Function() onTap;
  final Widget? inkWellChild;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        imageWidget,
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              child: inkWellChild,
            ),
          ),
        ),
      ],
    );
  }
}