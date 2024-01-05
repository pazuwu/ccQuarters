// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:ccquarters/common/views/show_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ccquarters/common/consts.dart';
import 'package:ccquarters/common/device_type.dart';
import 'package:ccquarters/filters/expansion_panel_list.dart';
import 'package:ccquarters/filters/sort_by_dropdown.dart';
import 'package:ccquarters/list_of_houses/cubit.dart';
import 'package:ccquarters/login_register/cubit.dart';
import 'package:ccquarters/model/house/filter.dart';

class Filters extends StatefulWidget {
  const Filters({
    Key? key,
    this.onlySort = false,
    required this.filters,
    required this.onSave,
  }) : super(key: key);

  final HouseFilter filters;
  final bool onlySort;
  final Function(HouseFilter) onSave;

  @override
  State<Filters> createState() => _FiltersState();
}

class _FiltersState extends State<Filters> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        !widget.onlySort
            ? IconButton(
                icon: const Icon(Icons.filter_list_rounded),
                onPressed: () {
                  showForm<bool>(
                    context: context,
                    builder: (BuildContext context) => FilterForm(
                      filters: widget.filters,
                      onSave: widget.onSave,
                    ),
                  );
                },
              )
            : Container(),
        SortBy(
          onChanged: (newValue) {
            setState(() {
              widget.filters.sortBy = newValue!;
            });
            widget.onSave(widget.filters);
          },
          value: widget.filters.sortBy,
        ),
      ],
    );
  }
}

class FilterForm extends StatelessWidget {
  const FilterForm({super.key, required this.filters, required this.onSave});

  final HouseFilter filters;
  final Function(HouseFilter) onSave;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      bottomNavigationBar: _buildButtons(context),
      body: ConstrainedBox(
        constraints: const BoxConstraints.expand(),
        child: Padding(
          padding: const EdgeInsets.all(mediumPaddingSize),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(mediumPaddingSize),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Filtry',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      if (context.read<AuthCubit>().user != null)
                        _buildSaveAsAlert(context),
                    ],
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

  Row _buildButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (getDeviceType(context) == DeviceType.mobile)
          _buildButton(context, 'Anuluj', false),
        _buildButton(context, 'Zapisz', true),
      ],
    );
  }

  Widget _buildButton(BuildContext context, String text, bool doesSave) {
    return Padding(
      padding: const EdgeInsets.all(largePaddingSize),
      child: TextButton(
        style: ButtonStyle(
          foregroundColor:
              !doesSave ? MaterialStateProperty.all<Color>(Colors.grey) : null,
        ),
        onPressed: () => {
          if (doesSave) onSave(filters),
          if (getDeviceType(context) == DeviceType.mobile)
            Navigator.pop(context)
        },
        child: Text(
          text,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }

  IconButton _buildSaveAsAlert(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.add_alert_rounded),
      onPressed: () {
        context.read<ListOfHousesCubit>().createAlert(filters);
      },
      tooltip: 'Zapisz jako alert',
    );
  }
}
