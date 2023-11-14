import 'package:ccquarters/list_of_houses/filters/expansion_panel_list.dart';
import 'package:ccquarters/list_of_houses/filters/sort_by_dropdown.dart';
import 'package:ccquarters/model/filter.dart';
import 'package:ccquarters/utils/consts.dart';
import 'package:ccquarters/utils/device_type.dart';
import 'package:flutter/material.dart';

class Filters extends StatefulWidget {
  const Filters({super.key, required this.filters});

  final HouseFilter filters;

  @override
  State<Filters> createState() => _FiltersState();
}

class _FiltersState extends State<Filters> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        getDeviceType(context) == DeviceType.mobile
            ? IconButton(
                icon: const Icon(Icons.filter_list_rounded),
                onPressed: () {
                  showModalBottomSheet<bool>(
                    useSafeArea: true,
                    isDismissible: false,
                    isScrollControlled: true,
                    enableDrag: true,
                    showDragHandle: true,
                    context: context,
                    builder: (BuildContext context) =>
                        FilterForm(filters: widget.filters),
                  );
                },
              )
            : Container(),
        SortBy(
          onChanged: (newValue) {
            widget.filters.sortBy = newValue!;
          },
        ),
      ],
    );
  }
}

class FilterForm extends StatelessWidget {
  const FilterForm({super.key, required this.filters});

  final HouseFilter filters;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (getDeviceType(context) == DeviceType.mobile)
            _buildButton(context, 'Anuluj', false),
          _buildButton(context, 'Zapisz', true),
        ],
      ),
      body: ConstrainedBox(
        constraints: const BoxConstraints.expand(),
        child: Padding(
          padding: const EdgeInsets.all(largePaddingSize),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(largePaddingSize),
                  child: Text(
                    'Filtry',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                FiltersExpansionPanelList(filters: filters),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String text, bool doesDelete) {
    return Padding(
      padding: const EdgeInsets.all(largePaddingSize),
      child: TextButton(
        style: ButtonStyle(
          foregroundColor: !doesDelete
              ? MaterialStateProperty.all<Color>(Colors.grey)
              : null,
        ),
        onPressed: () => {
          if (getDeviceType(context) == DeviceType.mobile)
            Navigator.pop(context, doesDelete)
        },
        child: Text(
          text,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}