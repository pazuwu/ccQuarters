import 'package:ccquarters/house_details/cubit.dart';
import 'package:ccquarters/house_details/views/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HouseDetailsGate extends StatelessWidget {
  const HouseDetailsGate({super.key, required this.houseId});

  final String houseId;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HouseDetailsCubit(houseId, context.read()),
      child: BlocBuilder<HouseDetailsCubit, HouseDetailsState>(
        builder: (context, state) {
          if (state is LoadingState) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (state is ErrorState) {
            return const Scaffold(
              body: Center(
                child: Text('Error'),
              ),
            );
          } else if (state is DetailsState) {
            return DetailsView(house: state.house);
          }
          return Container();
        },
      ),
    );
  }
}
