import 'package:ccquarters/house_details/cubit.dart';
import 'package:ccquarters/house_details/view.dart';
import 'package:ccquarters/model/house.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HouseDetailsGate extends StatelessWidget {
  const HouseDetailsGate({super.key, required this.house});

  final House house;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HouseDetailsCubit(house),
      child: BlocBuilder<HouseDetailsCubit, HouseDetailsState>(
        builder: (context, state) {
          if (state is DetailsState) {
            return DetailsView(house: state.house);
          }
          return Container();
        },
      ),
    );
  }
}
