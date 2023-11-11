import 'package:ccquarters/utils/consts.dart';
import 'package:flutter/material.dart';

class ChooseTypeDropdown<T> extends StatelessWidget {
  const ChooseTypeDropdown(
      {super.key,
      required this.title,
      this.value,
      required this.values,
      required this.onChanged,
      required this.onClear});

  final String title;
  final T? value;
  final List<T> values;
  final Function(T?) onChanged;
  final Function() onClear;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: smallPaddingSize,
        bottom: smallPaddingSize,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          const SizedBox(width: 10),
          DropdownButton<T?>(
            value: value,
            onChanged: onChanged,
            items: values.map<DropdownMenuItem<T>>((T value) {
              return DropdownMenuItem<T>(
                value: value,
                child: Text(value.toString(),
                    style: const TextStyle(fontSize: 14)),
              );
            }).toList(),
          ),
          IconButton(
            onPressed: onClear,
            icon: const Icon(Icons.clear),
          ),
        ],
      ),
    );
  }
}
