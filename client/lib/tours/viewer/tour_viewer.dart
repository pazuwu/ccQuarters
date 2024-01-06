import 'package:ccquarters/common/views/loading_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ccquarters/model/virtual_tour/tour.dart';
import 'package:ccquarters/tours/viewer/cubit.dart';
import 'package:ccquarters/tours/viewer/scene_viewer.dart';

class TourViewer extends StatelessWidget {
  const TourViewer({
    Key? key,
    required this.readOnly,
    required this.tour,
    this.currentSceneId,
  }) : super(key: key);

  final bool readOnly;
  final Tour tour;
  final String? currentSceneId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: VTViewerCubit(
        tour,
        context.read(),
        initialSceneId: currentSceneId,
      ),
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

        return const LoadingView();
      }),
    );
  }
}
