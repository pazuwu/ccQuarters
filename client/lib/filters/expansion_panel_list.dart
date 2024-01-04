import 'package:ccquarters/filters/chips.dart';
import 'package:ccquarters/filters/titled_dropdown.dart';
import 'package:ccquarters/filters/floor_multiselect_dropdown.dart';
import 'package:ccquarters/filters/from_to_number_fields.dart';
import 'package:ccquarters/model/house/building_type.dart';
import 'package:ccquarters/model/house/filter.dart';
import 'package:ccquarters/model/house/offer_type.dart';
import 'package:ccquarters/model/house/voivodeship.dart';
import 'package:ccquarters/common/consts.dart';
import 'package:ccquarters/common/device_type.dart';
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

    return Theme(
      data: Theme.of(context).copyWith(
        inputDecorationTheme:
            const InputDecorationTheme(enabledBorder: UnderlineInputBorder()),
      ),
      child: ExpansionPanelList(
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
      ),
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
          values: _getBuildingTypeValues(),
          onChanged: (BuildingType? newValue) =>
              setState(() => widget.filters.buildingType = newValue),
          onClear: () => setState(() {
            widget.filters.buildingType = null;
          }),
        ),
        TitledDropdown(
          title: 'Typ oferty',
          value: widget.filters.offerType,
          values: _getOfferTypeValues(),
          onChanged: (OfferType? newValue) =>
              setState(() => widget.filters.offerType = newValue),
          onClear: () => setState(() {
            widget.filters.offerType = null;
          }),
        ),
      ],
    );
  }

  List<BuildingType> _getBuildingTypeValues() {
    if (widget.filters.offerType == OfferType.sell) {
      return [
        BuildingType.apartment,
        BuildingType.house,
      ];
    } else {
      return BuildingType.values;
    }
  }

  List<OfferType> _getOfferTypeValues() {
    if (widget.filters.buildingType == BuildingType.room) {
      return [OfferType.rent];
    } else {
      return OfferType.values;
    }
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
        const SizedBox(height: 16),
        FromToNumberFields(
          title: "Cena za m\u00B2",
          from: widget.filters.minPricePerM2?.toStringAsFixed(2) ?? "",
          to: widget.filters.maxPricePerM2?.toStringAsFixed(2) ?? "",
          onChangedFrom: (val) {
            widget.filters.minPricePerM2 = double.tryParse(val);
          },
          onChangedTo: (val) {
            widget.filters.maxPricePerM2 = double.tryParse(val);
          },
          isDecimal: true,
        ),
        const SizedBox(height: 16),
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
        const SizedBox(height: 16),
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
        const SizedBox(height: 16),
        FloorMultiSelectDropdown(
          onChanged: (List<FloorNumber> newValue) {
            setState(() {
              var newFloors = newValue.map((e) => e.floorNumber).toList();
              var indexAboveTen =
                  newValue.indexWhere((element) => element.isAboveTen);

              if (indexAboveTen != -1) {
                var aboveTen = newValue[indexAboveTen];
                widget.filters.minFloor = aboveTen.floorNumber;
                newFloors.remove(aboveTen.floorNumber);
              }

              widget.filters.floors = newFloors;
              widget.filters.floors!.sort();
            });
          },
          filters: widget.filters,
          onClear: () {
            setState(() {
              widget.filters.floors = null;
              widget.filters.minFloor = null;
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
