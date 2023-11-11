import 'package:flutter/material.dart';

class GoBackNextButtons extends StatelessWidget {
  const GoBackNextButtons({
    super.key,
    required this.goBackOnPressed,
    required this.nextOnPressed,
  });

  final Function()? goBackOnPressed;
  final Function() nextOnPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (goBackOnPressed != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 20.0),
            child: ElevatedButton(
              key: const Key('goBack'),
              onPressed: goBackOnPressed,
              child: const Text("Wróć"),
            ),
          ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 20.0),
          child: ElevatedButton(
            key: const Key('next'),
            onPressed: nextOnPressed,
            child: const Text("Dalej"),
          ),
        ),
      ],
    );
  }
}
