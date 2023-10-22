import 'package:ccquarters/add_house/cubit.dart';
import 'package:ccquarters/add_house/map_view.dart';
import 'package:ccquarters/model/new_house.dart';
import 'package:ccquarters/utils/consts.dart';
import 'package:ccquarters/utils/input_decorator_form.dart';
import 'package:ccquarters/utils/view_with_header_and_buttons.dart';
import 'package:ccquarters/utils/views_with_vertical_divider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ccquarters/model/building_type.dart';

class LocationFormView extends StatefulWidget {
  const LocationFormView({
    super.key,
    required this.location,
    required this.buildingType,
  });

  final NewLocation location;
  final BuildingType buildingType;

  @override
  State<LocationFormView> createState() => _LocationFormViewState();
}

class _LocationFormViewState extends State<LocationFormView> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ViewWithHeader(
        title: "Uzupełnij lokalizację",
        inBetweenWidget: kIsWeb
            ? ViewsWithVerticalDivider(
                firstView: LocationForm(
                    location: widget.location,
                    buildingType: widget.buildingType,
                    formKey: _formKey),
                secondView: const ChooseLocationOnMap(),
              )
            : LocationForm(
                location: widget.location,
                buildingType: widget.buildingType,
                formKey: _formKey),
        goBackOnPressed: () {
          _formKey.currentState!.save();
          context.read<AddHouseFormCubit>().saveLocation(widget.location);
          if (kIsWeb) {
            context.read<AddHouseFormCubit>().goToChooseTypeForm();
          } else {
            context.read<AddHouseFormCubit>().goToDetailsForm();
          }
        },
        nextOnPressed: () {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            context.read<AddHouseFormCubit>().saveLocation(widget.location);
            if (kIsWeb) {
              context.read<AddHouseFormCubit>().goToPhotosForm();
            } else {
              context.read<AddHouseFormCubit>().goToMap();
            }
          }
        });
  }
}

class LocationForm extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(paddingSize),
        child: Form(
          key: formKey,
          child: Column(
            children: [
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
              if (buildingType != BuildingType.house)
                _buildFlatNumberField(context),
              if (buildingType != BuildingType.house)
                const SizedBox(height: sizedBoxHeight),
            ],
          ),
        ),
      ),
    );
  }

  TextFormField _buildCityField(BuildContext context) {
    return TextFormField(
      initialValue: location.city,
      onSaved: (newValue) => location.city = newValue?.trim() ?? '',
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
      initialValue: location.district,
      onSaved: (newValue) => location.district = newValue?.trim() ?? '',
      decoration: createInputDecorationForForm(
        context,
        "Dzielnica",
      ),
    );
  }

  TextFormField _buildStreetField(BuildContext context) {
    return TextFormField(
      initialValue: location.streetName,
      onSaved: (newValue) => location.streetName = newValue?.trim() ?? '',
      decoration: createInputDecorationForForm(
        context,
        "Ulica",
      ),
    );
  }

  TextFormField _buildStreetNumberField(BuildContext context) {
    return TextFormField(
      initialValue: location.streetNumber,
      onSaved: (newValue) => location.streetNumber = newValue?.trim() ?? '',
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
      initialValue: location.flatNumber,
      onSaved: (newValue) => location.flatNumber = newValue?.trim() ?? '',
      decoration: createInputDecorationForForm(
        context,
        "Numer mieszkania",
      ),
    );
  }

  Widget _buildPostalCodeField(BuildContext context) {
    return TextFormField(
        initialValue: location.zipCode,
        onSaved: (newValue) => location.zipCode = newValue?.trim() ?? '',
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
