import 'package:ccquarters/common/consts.dart';
import 'package:flutter/material.dart';

class WideTextButton extends StatelessWidget {
  const WideTextButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.isLightTheme = false,
  });

  final Function() onPressed;
  final String text;
  final bool isLightTheme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(smallPaddingSize),
      child: SizedBox(
        width: MediaQuery.of(context).size.width *
            (MediaQuery.of(context).orientation == Orientation.landscape
                ? 0.25
                : 0.5),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            side: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 1.5,
            ),
            backgroundColor: isLightTheme
                ? Colors.white
                : Theme.of(context).colorScheme.primary,
            elevation: 0,
          ),
          child: Text(
            text.toUpperCase(),
            style: TextStyle(
              color: isLightTheme
                  ? Theme.of(context).colorScheme.primary
                  : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
