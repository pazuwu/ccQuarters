import 'package:ccquarters/model/filter.dart';
import 'package:flutter/material.dart';

class SortBy extends StatelessWidget {
  const SortBy({super.key, required this.onChanged});

  final Function(SortingMethod?) onChanged;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text('Sortuj po:'),
        const SizedBox(width: 10),
        DropdownButton<SortingMethod>(
          value: SortingMethod.newest,
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
