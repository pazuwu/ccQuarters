import 'package:ccquarters/common/messages/snack_messenger.dart';
import 'package:ccquarters/virtual_tour/scene_list/scene_list.dart';
import 'package:ccquarters/virtual_tour/scene_list/states.dart';
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
            SnackMessenger.hide(context);
            SnackMessenger.showLoading(context, state.message);
          } else if (state is VTScenesSuccessState) {
            SnackMessenger.hide(context);
            SnackMessenger.showSuccess(context, state.message);
          }

          return SceneList(tour: state.tour);
        },
      ),
    );
  }
}
