import 'package:flutter/material.dart';

class SceneLinkForm extends StatelessWidget {
  const SceneLinkForm({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
        constraints: const BoxConstraints.expand(),
        child: const SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Placeholder(),
        ])));
  }
}
