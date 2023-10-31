import 'package:flutter/material.dart';

class Icon360 extends StatelessWidget {
  const Icon360({
    Key? key,
    this.onPressed,
    this.style,
    this.color,
  }) : super(key: key);

  final void Function()? onPressed;
  final ButtonStyle? style;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
        style: style,
        label: Text(
          "360°",
          style: TextStyle(color: color),
        ),
        onPressed: onPressed,
        icon: Icon(
          Icons.visibility,
          color: color,
        ));
  }
}
