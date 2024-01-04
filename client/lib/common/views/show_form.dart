import 'package:flutter/material.dart';

Future<T?> showForm<T>(
    {required BuildContext context,
    required Widget Function(BuildContext) builder}) {
  if (MediaQuery.of(context).orientation == Orientation.landscape) {
    return showDialog<T>(
      context: context,
      useSafeArea: true,
      builder: (context) => Dialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16.0))),
          child: ConstrainedBox(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.4),
              child: builder(context))),
    );
  } else {
    return showModalBottomSheet<T>(
        context: context,
        useSafeArea: true,
        enableDrag: true,
        showDragHandle: true,
        isScrollControlled: true,
        builder: builder);
  }
}
