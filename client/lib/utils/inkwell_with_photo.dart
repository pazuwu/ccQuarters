import 'package:flutter/material.dart';

class InkWellWithPhoto extends StatelessWidget {
  const InkWellWithPhoto({
    super.key,
    required this.imageWidget,
    required this.onTap,
    this.inkWellChild,
    this.fit = StackFit.loose,
    this.onDoubleTap,
  });

  final Widget imageWidget;
  final Function() onTap;
  final Function()? onDoubleTap;
  final Widget? inkWellChild;
  final StackFit fit;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: fit,
      children: [
        imageWidget,
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              onDoubleTap: onDoubleTap,
              child: inkWellChild,
            ),
          ),
        ),
      ],
    );
  }
}
