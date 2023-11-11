import 'package:flutter/material.dart';

class AlwaysVisibleTextLabel extends StatelessWidget {
  const AlwaysVisibleTextLabel({
    Key? key,
    required this.text,
    this.fontSize,
    this.fontWeight,
    this.background,
    this.alignment = Alignment.center,
    this.paddingSize = 0,
  }) : super(key: key);

  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? background;
  final AlignmentGeometry alignment;
  final double paddingSize;

  @override
  Widget build(BuildContext context) {
    return AlwaysVisibleLabel(
      background: background,
      child: Padding(
        padding: EdgeInsets.all(paddingSize),
        child: Align(
          alignment: alignment,
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: fontSize,
              fontWeight: fontWeight,
            ),
          ),
        ),
      ),
    );
  }
}

class AlwaysVisibleLabel extends StatelessWidget {
  const AlwaysVisibleLabel({
    Key? key,
    required this.child,
    this.background,
    this.stretch = true,
    this.padding,
  }) : super(key: key);

  final Widget child;
  final Color? background;
  final bool stretch;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
          color: background ?? Colors.black38,
          borderRadius: const BorderRadius.all(Radius.circular(4))),
      child: stretch ? Center(child: child) : child,
    );
  }
}
