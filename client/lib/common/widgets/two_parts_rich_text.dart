import 'package:flutter/material.dart';

class TwoPartsRichText extends StatelessWidget {
  const TwoPartsRichText({
    super.key,
    required this.firstText,
    required this.secondText,
  });

  final String firstText;
  final String secondText;
  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: firstText,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 15,
        ),
        children: <TextSpan>[
          TextSpan(
            text: secondText,
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
