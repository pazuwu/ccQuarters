import 'package:ccquarters/model/filter.dart';
import 'package:ccquarters/common_widgets/chip_keyboard_input.dart';
import 'package:flutter/material.dart';

class CityChipKeyboardInput extends StatefulWidget {
  const CityChipKeyboardInput({super.key, required this.filters});

  final HouseFilter filters;
  @override
  State<CityChipKeyboardInput> createState() => _CityChipKeyboardInputState();
}

class _CityChipKeyboardInputState extends State<CityChipKeyboardInput> {
  final TextEditingController _textEditingController = TextEditingController();
  bool showValidation = false;

  @override
  Widget build(BuildContext context) {
    return ChipKeyboardInput(
      label: "Miasto",
      textEditingController: _textEditingController,
      choices: widget.filters.cities!,
      onAdded: () {
        if (_textEditingController.text.isEmpty) {
          setState(() {
            showValidation = true;
          });
          return;
        }
        setState(() {
          showValidation = false;
          widget.filters.cities!.add(_textEditingController.text.trim());
          _textEditingController.clear();
        });
      },
      validation: showValidation ? "Wpisz miasto" : null,
    );
  }
}

class DistrictChipKeyboardInput extends StatefulWidget {
  const DistrictChipKeyboardInput({super.key, required this.filters});

  final HouseFilter filters;
  @override
  State<DistrictChipKeyboardInput> createState() =>
      _DistrictChipKeyboardInputState();
}

class _DistrictChipKeyboardInputState extends State<DistrictChipKeyboardInput> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChipKeyboardInput(
      label: "Dzielnica",
      textEditingController: _textEditingController,
      choices: widget.filters.districts!,
      onAdded: () {
        if (_textEditingController.text.isEmpty) {
          return;
        }
        setState(() {
          widget.filters.districts!.add(_textEditingController.text.trim());
          _textEditingController.clear();
        });
      },
    );
  }
}
