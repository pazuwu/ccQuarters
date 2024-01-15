import 'dart:math';

import 'package:flutter/material.dart';

class Message extends StatelessWidget {
  const Message({
    Key? key,
    this.padding,
    this.imageWidget,
    required this.title,
    this.subtitle,
    this.actionButton,
    this.actionButtonTitle,
    this.onAction,
    this.adjustToLandscape = true,
  }) : super(key: key);

  final EdgeInsets? padding;
  final Widget? imageWidget;
  final String title;
  final String? subtitle;
  final bool? actionButton;
  final String? actionButtonTitle;
  final void Function()? onAction;
  final bool adjustToLandscape;

  Widget _buildLandscapeMessage(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (imageWidget != null) ...[
          _buildImage(context),
          const SizedBox(width: 48),
        ],
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildTitle(context),
            if (subtitle != null) ..._buildSubtitle(context),
            if (actionButton ?? false) ..._buildActionButton(context),
          ],
        ),
      ],
    );
  }

  Widget _buildPortraitMessage(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (imageWidget != null) ...[
          _buildImage(context),
          const SizedBox(height: 24),
        ],
        _buildTitle(context),
        if (subtitle != null) ..._buildSubtitle(context),
        if (actionButton ?? false) ..._buildActionButton(context),
      ],
    );
  }

  Widget _buildImage(BuildContext context) {
    return SizedBox.square(
        dimension: 0.25 *
            min(MediaQuery.of(context).size.width,
                MediaQuery.of(context).size.height),
        child: imageWidget!);
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.headlineSmall,
      textAlign: TextAlign.center,
    );
  }

  List<Widget> _buildSubtitle(BuildContext context) {
    return [
      const SizedBox(height: 24),
      Text(
        subtitle!,
        style: Theme.of(context).textTheme.bodyLarge,
        textAlign: TextAlign.center,
      ),
    ];
  }

  List<Widget> _buildActionButton(BuildContext context) {
    return [
      const SizedBox(height: 24),
      TextButton(
        onPressed: onAction != null ? onAction! : () => Navigator.pop(context),
        child: Text(actionButtonTitle ?? "Zamknij"),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.all(0.0),
      child: Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: adjustToLandscape &&
                  MediaQuery.of(context).orientation == Orientation.landscape
              ? _buildLandscapeMessage(context)
              : _buildPortraitMessage(context),
        ),
      ),
    );
  }
}
