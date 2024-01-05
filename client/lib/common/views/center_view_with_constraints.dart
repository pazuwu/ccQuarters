import 'package:flutter/material.dart';

class CenterViewWithConstraints extends StatelessWidget {
  const CenterViewWithConstraints({
    super.key,
    required this.child,
    this.widthMultiplier = 0.5,
  });

  final Widget child;
  final double widthMultiplier;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
            maxWidth:
                MediaQuery.of(context).orientation == Orientation.landscape &&
                        MediaQuery.of(context).size.width > 700
                    ? MediaQuery.of(context).size.width * widthMultiplier
                    : MediaQuery.of(context).size.width),
        child: child,
      ),
    );
  }
}
