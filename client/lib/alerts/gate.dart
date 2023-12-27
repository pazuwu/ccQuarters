import 'package:ccquarters/alerts/cubit.dart';
import 'package:ccquarters/alerts/alerts_list.dart';
import 'package:ccquarters/alerts/alert_view.dart';
import 'package:ccquarters/common/messages/snack_messenger.dart';
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
          SnackMessenger.hide(context);
          if (state is AlertsMainPageState) {
            if (state.message != null && state.message!.isNotEmpty) {
              if (state.isSuccess) {
                SnackMessenger.showSuccess(context, state.message!);
              } else {
                SnackMessenger.showError(context, state.message!);
              }
            }
            return const AlertsView();
          } else if (state is AlertPageState) {
            return AlertView(
              alert: state.alert,
            );
          } else if (state is LoadingOrSendingDataState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Container();
        },
      ),
    );
  }
}
