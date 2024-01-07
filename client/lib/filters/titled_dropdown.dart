import 'package:ccquarters/common/consts.dart';
import 'package:flutter/material.dart';

class TitledDropdown<T> extends StatelessWidget {
  const TitledDropdown(
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
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                  paddingSize, 0, paddingSize, paddingSize),
              child: _buildDropdownButtonFormField(context),
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

  DropdownButtonFormField<dynamic> _buildDropdownButtonFormField(
      BuildContext context) {
    return DropdownButtonFormField<T?>(
      isExpanded: true,
      value: value,
      onChanged: onChanged,
      menuMaxHeight: MediaQuery.of(context).size.height * 0.3,
      items: values.map<DropdownMenuItem<T>>((T value) {
        return DropdownMenuItem<T>(
          value: value,
          child: Text(
            value.toString(),
            style:
                const TextStyle(fontSize: 14, overflow: TextOverflow.ellipsis),
          ),
        );
      }).toList(),
      decoration: InputDecoration(
        label: Text(title),
      ),
    );
  }
}
