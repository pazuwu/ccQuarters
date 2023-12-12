import 'package:ccquarters/virtual_tour/service/service.dart';
import 'package:ccquarters/virtual_tour/tour_list/cubit.dart';
import 'package:ccquarters/virtual_tour/tour_list/tour_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VTListGate extends StatelessWidget {
  const VTListGate({required VTService vtService, super.key})
      : _vtService = vtService;

  final VTService _vtService;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<VTListCubit>(
        create: (context) =>
            VTListCubit(vtService: _vtService, state: VTListLoadingState()),
        child: BlocBuilder<VTListCubit, VTListState>(
          builder: (context, state) {
            if (state is VTListLoadingState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is VTListLoadedState) {
              return TourList(tours: state.tours);
            } else if (state is VTListErrorState) {
              return Center(
                child: Text(state.message),
              );
            }

            return Container();
          },
        ));
  }
}
