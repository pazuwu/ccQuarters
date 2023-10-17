import 'package:flutter/material.dart';

InputDecoration createInputDecorationForForm(BuildContext context, String label,
    {bool alignLabelWithHint = false, bool isRequired = false}) {
  return InputDecoration(
    label: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label),
        if (isRequired) const SizedBox(width: 1),
        if (isRequired)
          Text(
            '*',
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
      ],
    ),
    alignLabelWithHint: alignLabelWithHint,
  );
}
