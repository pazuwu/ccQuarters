import 'package:ccquarters/utils/consts.dart';
import 'package:flutter/material.dart';

class Shadow extends StatelessWidget {
  const Shadow({
    super.key,
    required this.color,
    required this.child,
  });

  final ColorScheme color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      shadowColor: color.secondary,
      elevation: elevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      color: color.secondary,
      child: child,
    );
  }
}