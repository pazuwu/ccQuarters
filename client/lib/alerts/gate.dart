import 'package:ccquarters/alerts/cubit.dart';
import 'package:ccquarters/alerts/alerts.dart';
import 'package:ccquarters/alerts/alert_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AlertsGate extends StatelessWidget {
  const AlertsGate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AlertsPageCubit(
        alertService: context.read(),
      ),
      child: BlocBuilder<AlertsPageCubit, AlertsState>(
        builder: (context, state) {
          if (state is AlertsMainPageState) {
            return AlertsView(
              alerts: state.alerts,
            );
          } else if (state is AlertPageState) {
            return AlertView(
              alert: state.alert,
            );
          } else if (state is LoadingOrSendingDataState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is ErrorState) {
            return Center(
              child: Text(state.message),
            );
          }

          return Container();
        },
      ),
    );
  }
}
