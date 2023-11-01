import 'package:ccquarters/virtual_tour/scene_viewer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ccquarters/virtual_tour/cubit.dart';
import 'package:ccquarters/virtual_tour/scene_list.dart';
import 'package:ccquarters/virtual_tour/service/service.dart';

class VirtualTourGate extends StatelessWidget {
  const VirtualTourGate({
    Key? key,
    required this.tourId,
    required this.readOnly,
  }) : super(key: key);

  final String tourId;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider.value(
          value: VirtualTourCubit(
              initialState: VTLoadingState(tourId: tourId, readOnly: readOnly),
              service: VTService(dio: Dio(), url: "https://localhost:7101")),
          child: BlocBuilder<VirtualTourCubit, VTState>(
            builder: (context, state) {
              if (state is VTLoadingState) {
                return const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(
                        height: 32.0,
                      ),
                      Text("Trwa ładowanie wirtualnego spaceru..."),
                    ],
                  ),
                );
              }

              if (state is VTEditingState) {
                return SceneList(scenes: state.virtualTour.scenes);
              }

              if (state is VTViewingState) {
                return SceneViewer(
                  scene: state.currentScene,
                  links: state.links,
                  cubit: context.read(),
                  editable: !readOnly,
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
