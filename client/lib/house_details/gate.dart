import 'package:ccquarters/common/messages/error_message.dart';
import 'package:ccquarters/house_details/cubit.dart';
import 'package:ccquarters/house_details/states.dart';
import 'package:ccquarters/house_details/views/edit_house_view.dart';
import 'package:ccquarters/house_details/views/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

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
              body: ErrorMessage(
                state.message,
                tip: state.tip,
                closeButton: true,
                onClose: () => context
                    .go(GoRouterState.of(context).extra?.toString() ?? '/home'),
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
