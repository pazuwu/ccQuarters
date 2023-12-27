import 'package:ccquarters/virtual_tour/scene_list/gate.dart';
import 'package:ccquarters/virtual_tour/tour/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ccquarters/virtual_tour/tour/cubit.dart';
import 'package:ccquarters/virtual_tour/viewer/tour_viewer.dart';

class VirtualTourGate extends StatelessWidget {
  const VirtualTourGate({
    Key? key,
    required this.tourId,
    required this.readOnly,
    this.showTitle = false,
  }) : super(key: key);

  final String tourId;
  final bool readOnly;
  final bool showTitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider.value(
          value: VirtualTourCubit(
            initialState: VTLoadingState(tourId: tourId, readOnly: readOnly),
            service: context.read(),
          ),
          child: BlocBuilder<VirtualTourCubit, VTState>(
            builder: (context, state) {
              if (state is VTLoadingState) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(
                        height: 32.0,
                      ),
                      const Text("Trwa ładowanie wirtualnego spaceru..."),
                      const SizedBox(
                        height: 32.0,
                      ),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 200.0),
                        child: LinearProgressIndicator(
                          value: state.progress,
                        ),
                      )
                    ],
                  ),
                );
              }

              if (state is VTEditingState) {
                return SceneListGate(tour: state.virtualTour);
              }

              if (state is VTViewingState) {
                return TourViewer(
                  service: context.read(),
                  tour: state.virtualTour,
                  currentScene: state.currentScene,
                  readOnly: readOnly,
                );
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
                    Text(
                        "Wystąpił błąd poczas ładowania wirtualnego spaceru. "),
                    Text("Przepraszamy za utrudnienia"),
                  ],
                ),
              );
            },
          )),
    );
  }
}
