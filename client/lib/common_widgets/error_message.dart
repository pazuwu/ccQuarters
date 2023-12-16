import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ErrorMessage extends StatelessWidget {
  const ErrorMessage(
    this.errorMessage, {
    Key? key,
    this.tip,
    this.closeButton,
  }) : super(key: key);

  final String errorMessage;
  final String? tip;
  final bool? closeButton;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 0.75 *
            min(MediaQuery.of(context).size.width,
                MediaQuery.of(context).size.height),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(
              FontAwesomeIcons.triangleExclamation,
              color: Colors.blueGrey.shade600,
              size: 0.25 *
                  min(MediaQuery.of(context).size.width,
                      MediaQuery.of(context).size.height),
            ),
            const SizedBox(height: 24),
            Text(
              errorMessage,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            if (tip != null) ...[
              const SizedBox(height: 24),
              Text(
                tip!,
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
      ),
    );
  }
}
