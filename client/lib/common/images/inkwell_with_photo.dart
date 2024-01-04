import 'package:flutter/material.dart';

class InkWellWithPhoto extends StatelessWidget {
  const InkWellWithPhoto({
    Key? key,
    required this.imageWidget,
    required this.onTap,
    this.onDoubleTap,
    this.onLongPress,
    this.inkWellChild,
    this.fit = StackFit.loose,
  }) : super(key: key);

  final Widget imageWidget;
  final Function() onTap;
  final Function()? onDoubleTap;
  final Function()? onLongPress;
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
              onLongPress: onLongPress,
              child: inkWellChild,
            ),
          ),
        ),
      ],
    );
  }
}
