import 'package:flutter/material.dart';

showDialogWithMessage({
  required BuildContext context,
  required String title,
  String? content,
  Function()? onOk,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: Text(title),
      content: content != null ? Text(content) : null,
      actions: <Widget>[
        Center(
          child: TextButton(
              onPressed: () {
                Navigator.pop(context);
                onOk?.call();
              },
              child: const Text('OK')),
        )
      ],
    ),
  );
}
