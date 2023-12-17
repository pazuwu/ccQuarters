import 'package:ccquarters/house_details/cubit.dart';
import 'package:ccquarters/house_details/states.dart';
import 'package:ccquarters/house_details/views/edit_house_view.dart';
import 'package:ccquarters/house_details/views/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HouseDetailsGate extends StatelessWidget {
  const HouseDetailsGate({super.key, required this.houseId});

  final String houseId;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HouseDetailsCubit(
        houseId,
        context.read(),
        LoadingState(),
      ),
      child: BlocBuilder<HouseDetailsCubit, HouseDetailsState>(
        builder: (context, state) {
          if (state is LoadingState) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (state is ErrorState) {
            return Scaffold(
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(state.message),
                ),
              ),
            );
          } else if (state is DetailsState) {
            return DetailsView(house: state.house);
          } else if (state is EditHouseState) {
            return EditHouseView(
              house: state.house,
            );
          }
          return Container();
        },
      ),
    );
  }
}
