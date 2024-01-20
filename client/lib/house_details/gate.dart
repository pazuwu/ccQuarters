import 'package:ccquarters/common/messages/error_message.dart';
import 'package:ccquarters/common/views/loading_view.dart';
import 'package:ccquarters/house_details/cubit.dart';
import 'package:ccquarters/house_details/states.dart';
import 'package:ccquarters/house_details/views/edit_house_view.dart';
import 'package:ccquarters/house_details/views/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ccquarters/navigation/history_navigator.dart';

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
          if (state is EditHouseState) {
            return EditHouseView(
              house: state.house,
            );
          } else {
            return _getViewsToBackButton(state, context);
          }
        },
      ),
    );
  }

  Widget _getViewsToBackButton(HouseDetailsState state, BuildContext context) {
    if (state is LoadingState) {
      return const LoadingView();
    } else if (state is ErrorState) {
      return ErrorMessage(
        state.message,
        tip: state.tip,
        actionButton: true,
        onAction: () => context.goBack(),
      );
    } else if (state is DetailsState) {
      return DetailsView(
        house: state.house,
        goBack: (context) => context.goBack(),
      );
    }

    return Container();
  }
}
