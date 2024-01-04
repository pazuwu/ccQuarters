import 'dart:math';

import 'package:flutter/material.dart';

class ScenesInfoSnackbar extends SnackBar {
  ScenesInfoSnackbar({
    super.key,
    super.duration,
    required BuildContext context,
    String? message,
    Widget? suffix,
  }) : super(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          behavior: SnackBarBehavior.floating,
          margin: MediaQuery.of(context).orientation == Orientation.portrait
              ? EdgeInsets.symmetric(
                  horizontal: max(MediaQuery.of(context).size.width / 4,
                      (MediaQuery.of(context).size.width - 250) / 2),
                  vertical: 20.0)
              : EdgeInsets.only(
                  left: MediaQuery.of(context).size.width - 250 - 20,
                  right: 20,
                  bottom: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (message != null) ...[
                Text(
                  message,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                const SizedBox(
                  width: 8,
                ),
              ],
              if (suffix != null) suffix,
            ],
          ),
        );
}
