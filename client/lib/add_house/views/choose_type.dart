import 'package:ccquarters/add_house/cubit.dart';
import 'package:ccquarters/utils/consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ccquarters/model/building_type.dart';
import 'package:ccquarters/model/offer_type.dart';

class ChooseTypeView extends StatefulWidget {
  const ChooseTypeView({
    super.key,
    required this.offerType,
    required this.buildingType,
  });

  final OfferType offerType;
  final BuildingType buildingType;
  @override
  State<ChooseTypeView> createState() => _ChooseTypeViewState();
}

class _ChooseTypeViewState extends State<ChooseTypeView> {
  final List<bool> _selectedBuildingType = <bool>[false, false, false];
  final List<bool> _selectedOfferType = <bool>[false, false];
  final List<bool> _selectedSingleOfferType = <bool>[true];

  late BuildingType _buildingType;
  late OfferType _offerType;

  @override
  void initState() {
    super.initState();
    _buildingType = widget.buildingType;
    _offerType = widget.offerType;

    if (_buildingType == BuildingType.house) {
      _selectedBuildingType[0] = true;
    } else if (_buildingType == BuildingType.apartment) {
      _selectedBuildingType[1] = true;
    } else {
      _selectedBuildingType[2] = true;
    }

    if (_offerType == OfferType.rent) {
      _selectedOfferType[0] = true;
    } else {
      _selectedOfferType[1] = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ToggleButtonsTheme(
        data: ToggleButtonsThemeData(
          selectedBorderColor: Theme.of(context).colorScheme.primary,
          fillColor: Theme.of(context).colorScheme.secondary,
          borderRadius: const BorderRadius.all(
            Radius.circular(formBorderRadius),
          ),
        ),
        child: Column(
          children: [
            _buildBuildingType(context),
            _buildOfferType(context),
          ],
        ),
      ),
    );
  }

  Widget _buildBuildingType(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(largePaddingSize),
      child: Column(
        children: [
          const Text(
            'Typ ogłoszenia:',
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(
            height: 20,
          ),
          ToggleButtons(
            isSelected: _selectedBuildingType,
            onPressed: (int index) {
              setState(() {
                for (int i = 0; i < _selectedBuildingType.length; i++) {
                  _selectedBuildingType[i] = i == index;
                }
                _buildingType = BuildingType.values[index];
                context
                    .read<AddHouseFormCubit>()
                    .saveBuildingType(_buildingType);
              });
            },
            children: [
              ToggleButton(text: BuildingType.house.toString()),
              ToggleButton(text: BuildingType.apartment.toString()),
              ToggleButton(text: BuildingType.room.toString()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOfferType(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        const Text(
          'Typ oferty:',
          style: TextStyle(fontSize: 20),
        ),
        const SizedBox(
          height: 20,
        ),
        _buildingType != BuildingType.room
            ? _buildMultiOffertType(context)
            : _buildSingleOfferType()
      ],
    );
  }

  ToggleButtons _buildMultiOffertType(BuildContext context) {
    return ToggleButtons(
      isSelected: _selectedOfferType,
      onPressed: (int index) {
        setState(
          () {
            for (int i = 0; i < _selectedOfferType.length; i++) {
              _selectedOfferType[i] = i == index;
            }
            _offerType = OfferType.values[index];
            context.read<AddHouseFormCubit>().saveOfferType(_offerType);
          },
        );
      },
      children: [
        ToggleButton(text: OfferType.rent.toString()),
        ToggleButton(text: OfferType.sale.toString()),
      ],
    );
  }

  ToggleButtons _buildSingleOfferType() {
    return ToggleButtons(
      isSelected: _selectedSingleOfferType,
      onPressed: (int index) {
        setState(
          () {
            for (int i = 0; i < _selectedSingleOfferType.length; i++) {
              _selectedSingleOfferType[i] = i == index;
            }
            _offerType = OfferType.rent;
          },
        );
      },
      children: [
        ToggleButton(
          text: OfferType.rent.toString(),
        ),
      ],
    );
  }
}

class ToggleButton extends StatelessWidget {
  const ToggleButton({super.key, required this.text});

  final String text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(largePaddingSize),
      child: Text(
        text,
        style: const TextStyle(fontSize: 20),
      ),
    );
  }
}
