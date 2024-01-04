import 'package:ccquarters/common/consts.dart';
import 'package:ccquarters/common/inputs/number_text_field.dart';
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
          child: Text(
            title,
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(fontSize: 20),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
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
