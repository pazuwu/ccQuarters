import 'package:ccquarters/common/messages/error_message.dart';
import 'package:ccquarters/common/views/loading_view.dart';
import 'package:ccquarters/model/virtual_tours/tour.dart';
import 'package:ccquarters/model/virtual_tours/tour_for_edit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ccquarters/tours/tour_loader/cubit.dart';
import 'package:ccquarters/tours/tour_loader/states.dart';

class TourLoaderGate extends StatelessWidget {
  const TourLoaderGate({
    Key? key,
    required this.tourId,
    this.currentSceneId,
    this.tourBuilder,
    this.tourForEditBuilder,
  })  : assert((tourBuilder != null) ^ (tourForEditBuilder != null)),
        super(key: key);

  final String tourId;
  final String? currentSceneId;
  final Widget Function(BuildContext, Tour)? tourBuilder;
  final Widget Function(BuildContext, TourForEdit)? tourForEditBuilder;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: TourLoaderCubit(
        tourId: tourId,
        initialState: TourLoadingState(),
        service: context.read(),
        readOnly: tourBuilder != null,
      ),
      child: BlocBuilder<TourLoaderCubit, TourLoadingState>(
        builder: (context, state) {
          if (state is TourLoadingProgressState) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const LoadingView(),
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
          } else if (state is TourLoadingErrorState) {
            return ErrorMessage(
              state.text,
              tip: state.tip,
            );
          } else if (state is TourLoadedState) {
            return tourBuilder!.call(context, state.virtualTour);
          } else if (state is TourForEditLoadedState) {
            return tourForEditBuilder!.call(context, state.virtualTour);
          }

          return const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                LoadingView(),
                SizedBox(
                  height: 32.0,
                ),
                Text("Trwa ładowanie wirtualnego spaceru..."),
              ],
            ),
          );
        },
      ),
    );
  }
}
