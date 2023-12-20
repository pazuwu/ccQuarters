import 'dart:math';

import 'package:flutter/material.dart';

class Message extends StatelessWidget {
  const Message({
    Key? key,
    this.padding,
    this.icon,
    required this.title,
    this.subtitle,
    this.closeButton,
    this.adjustToLandscape = true,
  }) : super(key: key);

  final EdgeInsets? padding;
  final IconData? icon;
  final String title;
  final String? subtitle;
  final bool? closeButton;
  final bool adjustToLandscape;

  Widget _buildLandscapeMessage(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(
            icon!,
            size: 0.25 *
                min(MediaQuery.of(context).size.width,
                    MediaQuery.of(context).size.height),
          ),
          const SizedBox(width: 48),
        ],
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 24),
              Text(
                subtitle!,
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ],
            if (closeButton ?? false) ...[
              const SizedBox(height: 24),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Zamknij"),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildPortraitMessage(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(
            icon!,
            size: 0.25 *
                min(MediaQuery.of(context).size.width,
                    MediaQuery.of(context).size.height),
          ),
          const SizedBox(height: 24),
        ],
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 24),
          Text(
            subtitle!,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
        if (closeButton ?? false) ...[
          const SizedBox(height: 24),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Zamknij"),
          ),
        ],
      ],
    );
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
