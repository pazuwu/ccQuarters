import 'package:flutter/material.dart';

class GoBackNextButtons extends StatelessWidget {
  const GoBackNextButtons({
    super.key,
    required this.goBackOnPressed,
    required this.nextOnPressed,
    this.isLastPage = false,
  });

  final Function()? goBackOnPressed;
  final Function() nextOnPressed;
  final bool isLastPage;

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
            child: Text(isLastPage ? "Wyślij" : "Dalej"),
          ),
        ),
      ],
    );
  }
}
