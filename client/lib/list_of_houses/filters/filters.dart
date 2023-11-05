import 'package:ccquarters/list_of_houses/filters/choose_type_dropdown.dart';
import 'package:ccquarters/list_of_houses/filters/floor_multiselect_dropdown.dart';
import 'package:ccquarters/list_of_houses/filters/from_to_number_fields.dart';
import 'package:ccquarters/list_of_houses/filters/sort_by_dropdown.dart';
import 'package:ccquarters/model/building_type.dart';
import 'package:ccquarters/model/filter.dart';
import 'package:ccquarters/model/offer_type.dart';
import 'package:ccquarters/utils/consts.dart';
import 'package:ccquarters/utils/device_type.dart';
import 'package:flutter/material.dart';

class Filters extends StatelessWidget {
  const Filters({super.key, required this.filters});

  final HouseFilter filters;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        getDeviceType(context) == DeviceType.mobile
            ? IconButton(
                icon: const Icon(Icons.filter_list_rounded),
                onPressed: () {
                  showDialog<bool>(
                    context: context,
                    builder: (BuildContext context) =>
                        FilterForm(filters: filters),
                  );
                },
              )
            : Container(),
        SortBy(
          onChanged: (newValue) {
            filters.sortBy = newValue!;
          },
        ),
      ],
    );
  }
}

class FilterForm extends StatefulWidget {
  const FilterForm({super.key, required this.filters});

  final HouseFilter filters;

  @override
  State<FilterForm> createState() => _FilterFormState();
}

class _FilterFormState extends State<FilterForm> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(paddingSize),
      child: Card(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(paddingSize),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Filtry',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 10),
                _buildChooseType(),
                _buildInputFields(),
                FloorMultiSelectDropdown(
                  onChanged: (List<FloorNumber> newValue) {
                    setState(() {
                      widget.filters.floor =
                          newValue.map((e) => e.floorNumber).toList();
                      widget.filters.floor!.sort();
                    });
                  },
                  filters: widget.filters,
                  onClear: () {
                    setState(() {
                      widget.filters.floor = null;
                    });
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (getDeviceType(context) == DeviceType.mobile)
                      _buildButton(context, 'Anuluj', false),
                    _buildButton(context, 'Zapisz', true),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputFields() {
    return Column(
      children: [
        FromToNumberFields(
          title: "Cena",
          from: widget.filters.minPrice?.toStringAsFixed(0) ?? "",
          to: widget.filters.maxPrice?.toStringAsFixed(0) ?? "",
          onChangedFrom: (val) {
            widget.filters.minPrice = double.tryParse(val);
          },
          onChangedTo: (val) {
            widget.filters.maxPrice = double.tryParse(val);
          },
        ),
        FromToNumberFields(
          title: "Cena za m\u00B2",
          from: widget.filters.minPricePerMeter?.toStringAsFixed(2) ?? "",
          to: widget.filters.maxPricePerMeter?.toStringAsFixed(2) ?? "",
          onChangedFrom: (val) {
            widget.filters.minPricePerMeter = double.tryParse(val);
          },
          onChangedTo: (val) {
            widget.filters.maxPricePerMeter = double.tryParse(val);
          },
          isDecimal: true,
        ),
        FromToNumberFields(
          title: "Powierzchnia",
          from: widget.filters.minArea?.toStringAsFixed(2) ?? "",
          to: widget.filters.maxArea?.toStringAsFixed(2) ?? "",
          onChangedFrom: (val) {
            widget.filters.minArea = double.tryParse(val);
          },
          onChangedTo: (val) {
            widget.filters.maxArea = double.tryParse(val);
          },
          isDecimal: true,
        ),
        FromToNumberFields(
          title: "Liczba pokoi",
          from: widget.filters.minRoomCount?.toString() ?? "",
          to: widget.filters.maxRoomCount?.toString() ?? "",
          onChangedFrom: (val) {
            widget.filters.minRoomCount = int.tryParse(val);
          },
          onChangedTo: (val) {
            widget.filters.maxRoomCount = int.tryParse(val);
          },
        ),
      ],
    );
  }

  Widget _buildChooseType() {
    return Column(
      children: [
        ChooseTypeDropdown(
          title: 'Typ budynku',
          value: widget.filters.buildingType,
          values: BuildingType.values,
          onChanged: (BuildingType? newValue) =>
              setState(() => widget.filters.buildingType = newValue),
          onClear: () => setState(() {
            widget.filters.buildingType = null;
          }),
        ),
        ChooseTypeDropdown(
          title: 'Typ oferty',
          value: widget.filters.offerType,
          values: OfferType.values,
          onChanged: (OfferType? newValue) =>
              setState(() => widget.filters.offerType = newValue),
          onClear: () => setState(() {
            widget.filters.offerType = null;
          }),
        ),
      ],
    );
  }

  Widget _buildButton(BuildContext context, String text, bool doesDelete) {
    return TextButton(
      style: ButtonStyle(
        foregroundColor: !doesDelete
            ? MaterialStateProperty.all<Color>(
                Colors.grey,
              )
            : null,
      ),
      onPressed: () => {
        if (getDeviceType(context) == DeviceType.mobile)
          Navigator.pop(context, doesDelete)
      },
      child: Text(
        text,
      ),
    );
  }
}
