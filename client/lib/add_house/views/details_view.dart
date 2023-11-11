import 'package:ccquarters/add_house/cubit.dart';
import 'package:ccquarters/model/new_house.dart';
import 'package:ccquarters/utils/consts.dart';
import 'package:ccquarters/common_widgets/input_decorator_form.dart';
import 'package:ccquarters/common_widgets/view_with_header_and_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ccquarters/model/building_type.dart';

class DetailsFormView extends StatelessWidget {
  const DetailsFormView({
    super.key,
    required this.details,
    required this.buildingType,
    required this.formKey,
  });

  final NewHouseDetails details;
  final BuildingType buildingType;
  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    return ViewWithHeader(
      title: "Uzupełnij szczegóły ogłoszenia",
      inBetweenWidget: DetailsForm(
        details: details,
        buildingType: buildingType,
        formKey: formKey,
      ),
      goBackOnPressed: () {
        formKey.currentState!.save();
        context.read<AddHouseFormCubit>().saveDetails(details);
        context.read<AddHouseFormCubit>().goToChooseTypeForm();
      },
      nextOnPressed: () {
        if (formKey.currentState!.validate()) {
          formKey.currentState!.save();
          context.read<AddHouseFormCubit>().saveDetails(details);
          context.read<AddHouseFormCubit>().goToLocationForm();
        }
      },
    );
  }
}

class DetailsForm extends StatelessWidget {
  const DetailsForm(
      {super.key,
      required this.formKey,
      required this.buildingType,
      required this.details});

  final NewHouseDetails details;
  final BuildingType buildingType;
  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(largePaddingSize),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              _buildTitleField(context),
              const SizedBox(height: sizedBoxHeight),
              _buildDescriptionField(context),
              const SizedBox(height: sizedBoxHeight),
              _buildPriceField(context),
              const SizedBox(height: sizedBoxHeight),
              _buildAreaField(context),
              const SizedBox(height: sizedBoxHeight),
              if (buildingType != BuildingType.room)
                _buildRoomCountField(context),
              if (buildingType != BuildingType.room)
                const SizedBox(height: sizedBoxHeight),
              _buildFloorField(context),
            ],
          ),
        ),
      ),
    );
  }

  TextFormField _buildTitleField(BuildContext context) {
    return TextFormField(
      key: const Key("titleField"),
      initialValue: details.title,
      onSaved: (newValue) => details.title = newValue?.trim() ?? '',
      decoration: createInputDecorationForForm(
        context,
        "Tytuł ogłoszenia",
        isRequired: true,
      ),
      validator: (value) =>
          value?.isEmpty ?? false ? "Wpisz tytuł ogłoszenia" : null,
    );
  }

  ConstrainedBox _buildDescriptionField(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 216),
      child: TextFormField(
        key: const Key("descriptionField"),
        initialValue: details.description,
        onSaved: (newValue) => details.description = newValue?.trim() ?? '',
        minLines: 5,
        maxLines: null,
        decoration: createInputDecorationForForm(
          context,
          "Opis ogłoszenia",
          alignLabelWithHint: true,
        ),
      ),
    );
  }

  TextFormField _buildPriceField(BuildContext context) {
    return TextFormField(
      key: const Key("priceField"),
      initialValue: details.price != 0 ? details.price.toString() : null,
      onSaved: (newValue) =>
          details.price = newValue != null ? double.tryParse(newValue) ?? 0 : 0,
      decoration: createInputDecorationForForm(
        context,
        "Cena",
        isRequired: true,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Wpisz cenę";
        } else if (double.tryParse(value) == null) {
          return "Wpisz poprawną cenę";
        } else if (double.tryParse(value) == 0) {
          return "Cena nie może być równa 0";
        }
        return null;
      },
    );
  }

  TextFormField _buildAreaField(BuildContext context) {
    return TextFormField(
      key: const Key("areaField"),
      initialValue: details.area != 0 ? details.area.toString() : null,
      onSaved: (newValue) =>
          details.area = newValue != null ? double.tryParse(newValue) ?? 0 : 0,
      decoration: createInputDecorationForForm(
        context,
        "Powierzchnia",
        isRequired: true,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Wpisz powierzchnię";
        } else if (double.tryParse(value) == null) {
          return "Wpisz poprawną powierzchnię";
        } else if (double.tryParse(value) == 0) {
          return "Powierzchnia nie może być równa 0";
        }
        return null;
      },
    );
  }

  TextFormField _buildRoomCountField(BuildContext context) {
    return TextFormField(
      key: const Key("roomCountField"),
      initialValue:
          details.roomCount != 0 ? details.roomCount.toString() : null,
      onSaved: (newValue) => details.roomCount =
          newValue != null ? int.tryParse(newValue) ?? 0 : 0,
      decoration: createInputDecorationForForm(
        context,
        "Liczba pokoi",
      ),
      validator: (value) {
        if (value != null &&
            value.isNotEmpty &&
            double.tryParse(value) == null) {
          return "Wpisz poprawną liczbę pokoi";
        }
        return null;
      },
    );
  }

  TextFormField _buildFloorField(BuildContext context) {
    return TextFormField(
      key: const Key("floorField"),
      initialValue: details.floor != null && details.floor != 0
          ? details.floor.toString()
          : null,
      onSaved: (newValue) =>
          details.floor = newValue != null ? int.tryParse(newValue) ?? 0 : 0,
      decoration: createInputDecorationForForm(
        context,
        buildingType == BuildingType.house ? "Liczba pięter" : "Piętro",
      ),
      validator: (value) {
        if (value != null &&
            value.isNotEmpty &&
            double.tryParse(value) == null) {
          return "Wpisz poprawne piętro";
        }
        return null;
      },
    );
  }
}
