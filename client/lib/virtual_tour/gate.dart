import 'package:ccquarters/virtual_tour/scene_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ccquarters/virtual_tour/cubit.dart';

class VirtualTourGate extends StatelessWidget {
  const VirtualTourGate({
    Key? key,
    required this.houseId,
  }) : super(key: key);

  final String houseId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
        value: VirtualTourCubit(VTLoadingState(houseId: houseId)),
        child: BlocBuilder<VirtualTourCubit, VTState>(
          builder: (context, state) {
            if (state is VTLoadingState) {
              return const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    Text("Trwa ładowanie wirtualnego spaceru..."),
                  ],
                ),
              );
            }

            if (state is VTLoadedState) {
              return SceneList(
                  scenes: state.virtualTour.areas
                      .map((e) => e.scenes)
                      .reduce((value, element) => value + element));
            }

            if (state is VTErrorState) {
              return Center(
                child: Text(state.text),
              );
            }

            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Wystąpił błąd poczas ładowania wirtualnego spaceru. "),
                  Text("Przepraszamy za utrudnienia"),
                ],
              ),
            );
          },
        ));
  }
}
