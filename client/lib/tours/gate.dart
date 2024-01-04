import 'package:ccquarters/login_register/cubit.dart';
import 'package:ccquarters/tours/tour_loader/gate.dart';
import 'package:ccquarters/tours/viewer/tour_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class TourViewerGate extends StatelessWidget {
  const TourViewerGate({
    Key? key,
    required this.tourId,
    this.currentSceneId,
  }) : super(key: key);

  final String tourId;
  final String? currentSceneId;

  @override
  Widget build(BuildContext context) {
    return BackButtonListener(
      onBackButtonPressed: () async {
        _goBack(context);
        return true;
      },
      child: TourLoaderGate(
        tourId: tourId,
        tourBuilder: (context, tour) => TourViewer(
          currentSceneId: currentSceneId ?? tour.primarySceneId,
          readOnly: context.read<AuthCubit>().user?.id != tour.ownerId,
          tour: tour,
        ),
      ),
    );
  }

  void _goBack(BuildContext context) {
    var previousRoute = GoRouterState.of(context).extra;
    if (previousRoute == null) {
      context.pop();
    } else {
      context.go(previousRoute.toString());
    }
  }
}
