import 'package:ccquarters/add_house/cubit.dart';
import 'package:ccquarters/add_house/views/map_view.dart';
import 'package:ccquarters/model/houses/new_house.dart';
import 'package:ccquarters/model/houses/voivodeship.dart';
import 'package:ccquarters/common/consts.dart';
import 'package:ccquarters/common/device_type.dart';
import 'package:ccquarters/common/inputs/input_decorator_form.dart';
import 'package:ccquarters/common/views/view_with_buttons.dart';
import 'package:ccquarters/common/views/views_with_vertical_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ccquarters/model/houses/building_type.dart';

class LocationFormView extends StatefulWidget {
  const LocationFormView({
    super.key,
    required this.location,
    required this.buildingType,
    required this.formKey,
  });

  final NewLocation location;
  final BuildingType buildingType;
  final GlobalKey<FormState> formKey;

  @override
  State<LocationFormView> createState() => _LocationFormViewState();
}

class _LocationFormViewState extends State<LocationFormView> {
  @override
  Widget build(BuildContext context) {
    return ViewWithButtons(
        inBetweenWidget: getDeviceType(context) == DeviceType.web
            ? ViewsWithVerticalDivider(
                firstView: LocationForm(
                    location: widget.location,
                    buildingType: widget.buildingType,
                    formKey: widget.formKey),
                secondView:
                    ChooseLocationOnMap(addHouseFormCubit: context.read()),
              )
            : LocationForm(
                location: widget.location,
                buildingType: widget.buildingType,
                formKey: widget.formKey),
        goBackOnPressed: () {
          widget.formKey.currentState!.save();
          context.read<AddHouseFormCubit>().saveLocation(widget.location);
          if (getDeviceType(context) == DeviceType.web) {
            context.read<AddHouseFormCubit>().goToChooseTypeForm();
          } else {
            context.read<AddHouseFormCubit>().goToDetailsForm();
          }
        },
        nextOnPressed: () {
          if (widget.formKey.currentState!.validate()) {
            widget.formKey.currentState!.save();
            context.read<AddHouseFormCubit>().saveLocation(widget.location);
            if (getDeviceType(context) == DeviceType.web) {
              context.read<AddHouseFormCubit>().goToPhotosForm();
            } else {
              context.read<AddHouseFormCubit>().goToMap();
            }
          }
        });
  }
}

class LocationForm extends StatefulWidget {
  const LocationForm({
    super.key,
    required this.location,
    required this.buildingType,
    required this.formKey,
  });

  final NewLocation location;
  final BuildingType buildingType;
  final GlobalKey<FormState> formKey;

  @override
  State<LocationForm> createState() => _LocationFormState();
}

class _LocationFormState extends State<LocationForm> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(largePaddingSize),
        child: Form(
          key: widget.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildVoivodeshipDropdown(context),
              const SizedBox(height: sizedBoxHeight),
              _buildCityField(context),
              const SizedBox(height: sizedBoxHeight),
              _buildPostalCodeField(context),
              const SizedBox(height: sizedBoxHeight),
              _buildDistrictField(context),
              const SizedBox(height: sizedBoxHeight),
              _buildStreetField(context),
              const SizedBox(height: sizedBoxHeight),
              _buildStreetNumberField(context),
              const SizedBox(height: sizedBoxHeight),
              if (widget.buildingType != BuildingType.house)
                _buildFlatNumberField(context),
              if (widget.buildingType != BuildingType.house)
                const SizedBox(height: sizedBoxHeight),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVoivodeshipDropdown(BuildContext context) {
    return DropdownButtonFormField<Voivodeship?>(
      value: widget.location.voivodeship,
      onChanged: (val) {
        setState(() {
          widget.location.voivodeship = val;
        });
      },
      focusColor: Colors.grey.shade300,
      items: Voivodeship.values.map<DropdownMenuItem<Voivodeship>>(
        (Voivodeship value) {
          return DropdownMenuItem<Voivodeship>(
            value: value,
            child: Text(value.toString(), style: const TextStyle(fontSize: 14)),
          );
        },
      ).toList(),
      decoration: createInputDecorationForForm(
        context,
        "Województwo",
        isRequired: true,
      ),
      validator: (value) => value == null ? "Wpisz województwo" : null,
    );
  }

  TextFormField _buildCityField(BuildContext context) {
    return TextFormField(
      initialValue: widget.location.city,
      onSaved: (newValue) => widget.location.city = newValue?.trim() ?? '',
      decoration: createInputDecorationForForm(
        context,
        "Miasto",
        isRequired: true,
      ),
      validator: (value) => value?.isEmpty ?? false ? "Wpisz miasto" : null,
    );
  }

  TextFormField _buildDistrictField(BuildContext context) {
    return TextFormField(
      initialValue: widget.location.district,
      onSaved: (newValue) => widget.location.district = newValue?.trim() ?? '',
      decoration: createInputDecorationForForm(
        context,
        "Dzielnica",
      ),
    );
  }

  TextFormField _buildStreetField(BuildContext context) {
    return TextFormField(
      initialValue: widget.location.streetName,
      onSaved: (newValue) =>
          widget.location.streetName = newValue?.trim() ?? '',
      decoration: createInputDecorationForForm(
        context,
        "Ulica",
      ),
    );
  }

  TextFormField _buildStreetNumberField(BuildContext context) {
    return TextFormField(
      initialValue: widget.location.streetNumber,
      onSaved: (newValue) =>
          widget.location.streetNumber = newValue?.trim() ?? '',
      decoration: createInputDecorationForForm(
        context,
        "Numer budynku",
        isRequired: true,
      ),
      validator: (value) =>
          value?.isEmpty ?? false ? "Wpisz numer budynku" : null,
    );
  }

  TextFormField _buildFlatNumberField(BuildContext context) {
    return TextFormField(
      initialValue: widget.location.flatNumber,
      onSaved: (newValue) =>
          widget.location.flatNumber = newValue?.trim() ?? '',
      decoration: createInputDecorationForForm(
        context,
        "Numer mieszkania",
      ),
    );
  }

  Widget _buildPostalCodeField(BuildContext context) {
    return TextFormField(
        initialValue: widget.location.zipCode,
        onSaved: (newValue) => widget.location.zipCode = newValue?.trim() ?? '',
        decoration: createInputDecorationForForm(
          context,
          "Kod pocztowy",
          isRequired: true,
        ),
        validator: (value) {
          if (value?.isEmpty ?? true) {
            return "Wpisz kod pocztowy";
          } else {
            RegExp exp = RegExp(r'[0-9]{2}-[0-9]{3}');
            String str = value.toString();
            if (!exp.hasMatch(str)) {
              return "Podaj kod pocztowy w formacie 00-000";
            }
          }
          return null;
        });
  }
}
