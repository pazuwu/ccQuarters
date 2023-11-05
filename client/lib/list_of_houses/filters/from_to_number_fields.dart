import 'package:ccquarters/utils/consts.dart';
import 'package:ccquarters/utils/number_text_field.dart';
import 'package:flutter/material.dart';

class FromToNumberFields extends StatelessWidget {
  const FromToNumberFields({
    super.key,
    required this.title,
    required this.from,
    required this.to,
    required this.onChangedFrom,
    required this.onChangedTo,
    this.isDecimal = false,
  });

  final String title;
  final String from;
  final String to;
  final Function(String) onChangedFrom;
  final Function(String) onChangedTo;
  final bool isDecimal;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(title),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: smallPaddingSize,
            bottom: smallPaddingSize,
          ),
          child: Row(
            children: [
              Expanded(
                child: NumberTextField(
                  label: 'Od',
                  initialValue: from,
                  onChanged: onChangedFrom,
                  isDecimal: isDecimal,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: NumberTextField(
                  label: 'Do',
                  initialValue: to,
                  onChanged: onChangedTo,
                  isDecimal: isDecimal,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}