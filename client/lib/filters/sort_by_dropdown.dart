import 'package:ccquarters/model/house/filter.dart';
import 'package:flutter/material.dart';

class SortBy extends StatelessWidget {
  const SortBy({super.key, required this.onChanged, required this.value});

  final Function(SortingMethod?) onChanged;
  final SortingMethod value;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text('Sortuj po:'),
        const SizedBox(width: 10),
        DropdownButton<SortingMethod>(
          value: value,
          onChanged: onChanged,
          items: SortingMethod.values
              .map<DropdownMenuItem<SortingMethod>>((SortingMethod value) {
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
