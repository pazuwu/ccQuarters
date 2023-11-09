import 'package:ccquarters/model/filter.dart';
import 'package:ccquarters/model/voivodeship.dart';
import 'package:ccquarters/utils/chip_keyboard_input.dart';
import 'package:flutter/material.dart';

class CityAndVoivodeshipChipKeyboardInput extends StatefulWidget {
  const CityAndVoivodeshipChipKeyboardInput({super.key, required this.filters});

  final HouseFilter filters;
  @override
  State<CityAndVoivodeshipChipKeyboardInput> createState() =>
      _CityAndVoivodeshipChipKeyboardInputState();
}

class _CityAndVoivodeshipChipKeyboardInputState
    extends State<CityAndVoivodeshipChipKeyboardInput> {
  final TextEditingController _textEditingController = TextEditingController();
  Voivodeship? voivodeship;
  bool showValidation = false;

  @override
  Widget build(BuildContext context) {
    return ChipKeyboardInput(
      label: "Miasto",
      additionalWidget: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Województwo:"),
          DropdownButton<Voivodeship?>(
            value: voivodeship,
            onChanged: (val) {
              setState(() {
                voivodeship = val;
              });
            },
            focusColor: Colors.grey.shade300,
            items: Voivodeship.values
                .map<DropdownMenuItem<Voivodeship>>((Voivodeship value) {
              return DropdownMenuItem<Voivodeship>(
                value: value,
                child: Text(value.toString(),
                    style: const TextStyle(fontSize: 14)),
              );
            }).toList(),
          ),
        ],
      ),
      textEditingController: _textEditingController,
      choices: widget.filters.voivodeshipsAndCities,
      onAdded: () {
        if (_textEditingController.text.isEmpty || voivodeship == null) {
          setState(() {
            showValidation = true;
          });
          return;
        }
        setState(() {
          showValidation = false;
          widget.filters.voivodeshipsAndCities.add(CityWithVoivodeship(
            city: _textEditingController.text.trim(),
            voivodeship: voivodeship!,
          ));
          _textEditingController.clear();
        });
      },
      validation: showValidation ? "Wybierz województwo i wpisz miasto" : null,
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
      choices: widget.filters.districts,
      onAdded: () {
        if (_textEditingController.text.isEmpty) {
          return;
        }
        setState(() {
          widget.filters.districts.add(_textEditingController.text.trim());
          _textEditingController.clear();
        });
      },
    );
  }
}
