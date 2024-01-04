import 'package:ccquarters/add_house/cubit.dart';
import 'package:ccquarters/add_house/views/additional_info_form.dart';
import 'package:ccquarters/common/messages/snack_messenger.dart';
import 'package:ccquarters/common/views/show_form.dart';
import 'package:ccquarters/model/house/new_house.dart';
import 'package:ccquarters/common/consts.dart';
import 'package:ccquarters/common/inputs/input_decorator_form.dart';
import 'package:ccquarters/common/views/view_with_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ccquarters/model/house/building_type.dart';

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
    return ViewWithButtons(
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

class DetailsForm extends StatefulWidget {
  const DetailsForm(
      {super.key,
      required this.formKey,
      required this.buildingType,
      required this.details});

  final NewHouseDetails details;
  final BuildingType buildingType;
  final GlobalKey<FormState> formKey;

  @override
  State<DetailsForm> createState() => _DetailsFormState();
}

class _DetailsFormState extends State<DetailsForm> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(largePaddingSize),
        child: Form(
          key: widget.formKey,
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
              if (widget.buildingType != BuildingType.room)
                _buildRoomCountField(context),
              if (widget.buildingType != BuildingType.room)
                const SizedBox(height: sizedBoxHeight),
              _buildFloorField(context),
              _buildAdditionalInfo(context)
            ],
          ),
        ),
      ),
    );
  }

  TextFormField _buildTitleField(BuildContext context) {
    return TextFormField(
      key: const Key("titleField"),
      initialValue: widget.details.title,
      maxLength: 50,
      onSaved: (newValue) => widget.details.title = newValue?.trim() ?? '',
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
        initialValue: widget.details.description,
        onSaved: (newValue) =>
            widget.details.description = newValue?.trim() ?? '',
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
      initialValue:
          widget.details.price != 0 ? widget.details.price.toString() : null,
      onSaved: (newValue) => widget.details.price =
          newValue != null ? double.tryParse(newValue) ?? 0 : 0,
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
      initialValue:
          widget.details.area != 0 ? widget.details.area.toString() : null,
      onSaved: (newValue) => widget.details.area =
          newValue != null ? double.tryParse(newValue) ?? 0 : 0,
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
      initialValue: widget.details.roomCount != 0
          ? widget.details.roomCount.toString()
          : null,
      onSaved: (newValue) => widget.details.roomCount =
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
      initialValue: widget.details.floor != null && widget.details.floor != 0
          ? widget.details.floor.toString()
          : null,
      onSaved: (newValue) => widget.details.floor =
          newValue != null ? int.tryParse(newValue) ?? 0 : 0,
      decoration: createInputDecorationForForm(
        context,
        widget.buildingType == BuildingType.house ? "Liczba pięter" : "Piętro",
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

  Widget _buildAdditionalInfo(BuildContext context) {
    var items = widget.details.additionalInfo?.entries.toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "Dodatkowe informacje",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(width: 8),
            IconButton(
                onPressed: () => _buildAdditionalInfoForm(context),
                icon: const Icon(Icons.add)),
          ],
        ),
        if (items != null && items.isNotEmpty)
          _buildAdditionalInfoList(items, context),
      ],
    );
  }

  Wrap _buildAdditionalInfoList(
    List<MapEntry<String, String>> items,
    BuildContext context,
  ) {
    return Wrap(
      spacing: 4,
      children: [
        for (final item in items)
          InputChip(
            onPressed: () {
              _buildAdditionalInfoForm(
                context,
                title: item.key,
                info: item.value,
                isEdit: true,
              );
            },
            label: Text("${item.key}: ${item.value}"),
            onDeleted: () {
              setState(() {
                widget.details.additionalInfo!.remove(item.key);
              });
            },
            backgroundColor: Theme.of(context).colorScheme.secondary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(formBorderRadius / 1.5),
              side: const BorderSide(
                color: Colors.blueGrey,
                width: inputDecorationBorderSide,
              ),
            ),
          ),
      ],
    );
  }

  _buildAdditionalInfoForm(
    BuildContext context, {
    String title = "",
    String info = "",
    bool isEdit = false,
  }) {
    return showForm(
      context: context,
      builder: (c) {
        return AdditionalInfoForm(
          onSubmit: (t, info) {
            if (isEdit) {
              widget.details.additionalInfo!.remove(title);
            }
            _addAdditionalInfo(t, info);
          },
          title: title.toString(),
          info: info.toString(),
        );
      },
    );
  }

  _addAdditionalInfo(String title, String info) {
    setState(() {
      widget.details.additionalInfo ??= {};
      if (!widget.details.additionalInfo!.containsKey(title)) {
        widget.details.additionalInfo!.putIfAbsent(title, () => info);
      } else {
        SnackMessenger.showMessage(
          context,
          "Informacja o takim tytule już istnieje, edytuj ją",
        );
      }
    });
  }
}
