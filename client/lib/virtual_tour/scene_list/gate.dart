import 'package:ccquarters/virtual_tour/scene_list/scene_list.dart';
import 'package:ccquarters/virtual_tour/scene_list/scenes_info_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ccquarters/virtual_tour/model/tour.dart';
import 'package:ccquarters/virtual_tour/scene_list/cubit.dart';

class SceneListGate extends StatelessWidget {
  const SceneListGate({
    Key? key,
    required this.tour,
  }) : super(key: key);

  final Tour tour;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: VTScenesCubit(context.read(), tour),
      child: BlocBuilder<VTScenesCubit, VTScenesState>(
        builder: (context, state) {
          if (state is VTScenesLoadingState) {
            _showLoadingSnackbar(context, state);
          } else {
            _hideLoadingSnackbar(context);
          }

          if (state is VTScenesSuccessState) {
            _showSuccessSnackbar(context, state);
          }

          return SceneList(tour: state.tour);
        },
      ),
    );
  }

  void _showLoadingSnackbar(BuildContext context, VTScenesLoadingState state) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        ScenesInfoSnackbar(
          context: context,
          message: state.message,
          suffix: const SizedBox.square(
            dimension: 16,
            child: CircularProgressIndicator(),
          ),
        ),
      );
    });
  }

  void _hideLoadingSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }

  void _showSuccessSnackbar(BuildContext context, VTScenesSuccessState state) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        ScenesInfoSnackbar(
          context: context,
          duration: const Duration(seconds: 2),
          message: state.message,
          suffix: const Icon(
            Icons.done,
            size: 16,
          ),
        ),
      );
    });
  }
}
