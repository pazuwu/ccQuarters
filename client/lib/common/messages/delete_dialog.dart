import 'package:flutter/material.dart';

showDeleteDialog(BuildContext context, String whatToDeleteTitle,
    String whatToDelete, Function() onDelete) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Usuwanie $whatToDeleteTitle"),
          content: Text("Czy na pewno chcesz usunąć $whatToDelete?"),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Anuluj"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                onDelete();
              },
              child: const Text("Usuń"),
            ),
          ],
        );
      });
}
