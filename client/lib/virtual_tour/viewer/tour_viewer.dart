import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ccquarters/virtual_tour/model/scene.dart';
import 'package:ccquarters/virtual_tour/model/tour.dart';
import 'package:ccquarters/services/virtual_tours/service.dart';
import 'package:ccquarters/virtual_tour/viewer/cubit.dart';
import 'package:ccquarters/virtual_tour/viewer/scene_viewer.dart';

class TourViewer extends StatelessWidget {
  const TourViewer({
    Key? key,
    required this.readOnly,
    required this.tour,
    required this.service,
    this.currentScene,
  }) : super(key: key);

  final bool readOnly;
  final Tour tour;
  final VTService service;
  final Scene? currentScene;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: VTViewerCubit(tour, service, initialScene: currentScene),
      child:
          BlocBuilder<VTViewerCubit, VTViewerState>(builder: (context, state) {
        if (state is VTViewingSceneState) {
          return SceneViewer(
            scene: state.currentScene,
            links: state.links,
            cubit: context.read(),
            readOnly: readOnly,
          );
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      }),
    );
  }
}
