import 'dart:math';

import 'package:flutter/material.dart';

class SnackMessenger {
  static void showMessage(BuildContext context, String message,
      {Duration? duration, Widget? icon}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        _InfoSnackbar(
          context: context,
          message: message,
          icon: icon,
          duration: duration ?? const Duration(seconds: 4),
        ),
      );
    });
  }

  static void showLoading(BuildContext context, String message,
      {Duration? delay, Duration? duration}) {
    showMessage(
      context,
      message,
      duration: duration,
      icon: const SizedBox.square(
        dimension: 12,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          strokeCap: StrokeCap.round,
        ),
      ),
    );
  }

  static void showSuccess(BuildContext context, String message,
      {Duration? delay, Duration? duration}) {
    showMessage(
      context,
      message,
      duration: duration,
      icon: const Icon(Icons.done, size: 16),
    );
  }

  static void showError(BuildContext context, String message,
      {Duration? delay, Duration? duration}) {
    showMessage(
      context,
      message,
      duration: duration,
      icon: const Icon(Icons.error, size: 16),
    );
  }

  static void hide(context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }
}

class _InfoSnackbar extends SnackBar {
  _InfoSnackbar({
    super.duration,
    required BuildContext context,
    String? message,
    Widget? icon,
  }) : super(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          behavior: SnackBarBehavior.floating,
          margin: MediaQuery.of(context).orientation == Orientation.portrait
              ? EdgeInsets.symmetric(
                  horizontal: max(MediaQuery.of(context).size.width / 5,
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
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null)
                Align(alignment: Alignment.centerLeft, child: icon),
              if (message != null) ...[
                const SizedBox(
                  width: 12,
                ),
                Flexible(
                  child: Text(
                    message,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ),
              ],
            ],
          ),
        );
}
