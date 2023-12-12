import 'package:ccquarters/list_of_houses/filters/chips.dart';
import 'package:ccquarters/list_of_houses/filters/titled_dropdown.dart';
import 'package:ccquarters/list_of_houses/filters/floor_multiselect_dropdown.dart';
import 'package:ccquarters/list_of_houses/filters/from_to_number_fields.dart';
import 'package:ccquarters/model/building_type.dart';
import 'package:ccquarters/model/filter.dart';
import 'package:ccquarters/model/offer_type.dart';
import 'package:ccquarters/model/voivodeship.dart';
import 'package:ccquarters/utils/consts.dart';
import 'package:ccquarters/utils/device_type.dart';
import 'package:flutter/material.dart';

class FiltersExpansionPanelList extends StatefulWidget {
  const FiltersExpansionPanelList({super.key, required this.filters});

  final HouseFilter filters;

  @override
  State<FiltersExpansionPanelList> createState() =>
      _FiltersExpansionPanelListState();
}

class _FiltersExpansionPanelListState extends State<FiltersExpansionPanelList> {
  final _isExpanded = [false, null, false];

  @override
  Widget build(BuildContext context) {
    if (_isExpanded[1] == null && getDeviceType(context) == DeviceType.web) {
      _isExpanded[1] = true;
    }

    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _isExpanded[index] = isExpanded;
        });
      },
      dividerColor: Colors.grey,
      children: [
        _buildOfferTypeExpansionPanel(context),
        _buildDetailsExpansionPanel(context),
        _buildLocationExpansionPanel(context),
      ],
    );
  }

  ExpansionPanel _buildOfferTypeExpansionPanel(BuildContext context) {
    return _buildExpansionPanel(
      context,
      0,
      "Typ ogłoszenia",
      [
        TitledDropdown(
          title: 'Typ budynku',
          value: widget.filters.buildingType,
          values: BuildingType.values,
          onChanged: (BuildingType? newValue) =>
              setState(() => widget.filters.buildingType = newValue),
          onClear: () => setState(() {
            widget.filters.buildingType = null;
          }),
        ),
        TitledDropdown(
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

  ExpansionPanel _buildDetailsExpansionPanel(BuildContext context) {
    return _buildExpansionPanel(
      context,
      1,
      "Szczegóły ogłoszenia",
      [
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
      ],
    );
  }

  ExpansionPanel _buildLocationExpansionPanel(BuildContext context) {
    return _buildExpansionPanel(
      context,
      2,
      "Lokalizacja",
      [
        TitledDropdown(
          title: 'Województwo',
          value: widget.filters.voivodeship,
          values: Voivodeship.values,
          onChanged: (val) {
            setState(() {
              widget.filters.voivodeship = val;
            });
          },
          onClear: () => setState(() {
            widget.filters.voivodeship = null;
          }),
        ),
        CityChipKeyboardInput(
          filters: widget.filters,
        ),
        Divider(thickness: 1, color: Colors.grey.shade400),
        DistrictChipKeyboardInput(
          filters: widget.filters,
        ),
      ],
    );
  }

  ExpansionPanel _buildExpansionPanel(
      BuildContext context, int index, String title, List<Widget> children) {
    return ExpansionPanel(
      isExpanded: _isExpanded[index] ?? false,
      headerBuilder: (context, isOpen) => Padding(
        padding: const EdgeInsets.all(mediumPaddingSize),
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(
            mediumPaddingSize, 0, mediumPaddingSize, mediumPaddingSize),
        child: Column(
          children: children,
        ),
      ),
    );
  }
}
