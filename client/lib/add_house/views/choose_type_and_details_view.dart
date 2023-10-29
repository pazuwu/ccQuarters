import 'package:ccquarters/add_house/views/choose_type.dart';
import 'package:ccquarters/add_house/cubit.dart';
import 'package:ccquarters/add_house/views/details_view.dart';
import 'package:ccquarters/model/new_house.dart';
import 'package:ccquarters/utils/view_with_header_and_buttons.dart';
import 'package:ccquarters/utils/views_with_vertical_divider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ccquarters/model/building_type.dart';
import 'package:ccquarters/model/offer_type.dart';

class ChooseTypeMainView extends StatefulWidget {
  const ChooseTypeMainView({
    super.key,
    required this.details,
    required this.offerType,
    required this.buildingType,
  });

  final NewHouseDetails details;
  final OfferType offerType;
  final BuildingType buildingType;

  @override
  State<ChooseTypeMainView> createState() => _ChooseTypeMainViewState();
}

class _ChooseTypeMainViewState extends State<ChooseTypeMainView> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ViewWithHeader(
      title: "Dodaj ogłoszenie",
      inBetweenWidget: kIsWeb
          ? ViewsWithVerticalDivider(
              firstView: ChooseTypeView(
                offerType: widget.offerType,
                buildingType: widget.buildingType,
              ),
              secondView: DetailsForm(
                details: widget.details,
                buildingType: widget.buildingType,
                formKey: formKey,
              ))
          : ChooseTypeView(
              offerType: widget.offerType, buildingType: widget.buildingType),
      goBackOnPressed: null,
      nextOnPressed: () {
        if (kIsWeb) {
          if (formKey.currentState!.validate()) {
            formKey.currentState!.save();
            context.read<AddHouseFormCubit>().saveDetails(widget.details);
            context.read<AddHouseFormCubit>().goToLocationForm();
          }
        } else {
          context.read<AddHouseFormCubit>().goToDetailsForm();
        }
      },
    );
  }
}
