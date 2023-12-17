import 'dart:math';

import 'package:ccquarters/model/filter.dart';
import 'package:ccquarters/utils/consts.dart';
import 'package:flutter/material.dart';
import 'package:multiselect/multiselect.dart';

class FloorMultiSelectDropdown extends StatelessWidget {
  const FloorMultiSelectDropdown({
    super.key,
    required this.onClear,
    required this.onChanged,
    required this.filters,
  });

  final Function(List<FloorNumber>) onChanged;
  final Function() onClear;
  final HouseFilter filters;
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
          const Text("Piętro"),
          const SizedBox(width: 10),
          Container(
            constraints: BoxConstraints(
              maxWidth: min(200, MediaQuery.of(context).size.width / 2),
              maxHeight: 100,
            ),
            child: DropDownMultiSelect(
              onChanged: onChanged,
              options: List.generate(12, (index) => FloorNumber(index)),
              selectedValues: filters.floors != null
                  ? filters.floors!.map((e) => FloorNumber(e)).toList()
                  : <FloorNumber>[],
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
              ),
            ),
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
