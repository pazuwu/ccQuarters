import 'package:ccquarters/add_house/cubit.dart';
import 'package:ccquarters/utils/view_with_header_and_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MapView extends StatelessWidget {
  const MapView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewWithHeader(
        title: "Wybierz lokalizację",
        inBetweenWidget: Container(),
        goBackOnPressed: () {
          context.read<AddHouseFormCubit>().goToLocationForm();
        },
        nextOnPressed: () {
          context.read<AddHouseFormCubit>().goToPhotosForm();
        });
  }
}
