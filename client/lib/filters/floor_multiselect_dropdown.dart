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
              options: _getOptions(),
              selectedValues: _getSelectedValues(),
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

  List<FloorNumber> _getOptions() {
    List<FloorNumber> result = [];

    result.addAll(List.generate(11, (index) => FloorNumber(index)));
    result.add(FloorNumber.aboveTen());
    
    return result;
  }

  List<FloorNumber> _getSelectedValues() {
    List<FloorNumber> result = [];

    if (filters.floors != null) {
      result.addAll(filters.floors!.map((e) => FloorNumber(e)));
    }

    if (filters.minFloor != null) {
      result.add(FloorNumber.aboveTen());
    }

    return result;
  }
}
