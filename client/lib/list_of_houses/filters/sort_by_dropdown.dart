import 'package:ccquarters/model/filter.dart';
import 'package:flutter/material.dart';

class SortBy extends StatelessWidget {
  const SortBy({super.key, required this.onChanged});

  final Function(SortByType?) onChanged;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text('Sortuj po:'),
        const SizedBox(width: 10),
        DropdownButton<SortByType>(
          value: SortByType.newest,
          onChanged: onChanged,
          items: SortByType.values
              .map<DropdownMenuItem<SortByType>>((SortByType value) {
            return DropdownMenuItem(
              value: value,
              child:
                  Text(value.toString(), style: const TextStyle(fontSize: 14)),
            );
          }).toList(),
        ),
      ],
    );
  }
}