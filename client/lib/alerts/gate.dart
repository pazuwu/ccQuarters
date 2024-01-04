import 'package:ccquarters/alerts/cubit.dart';
import 'package:ccquarters/alerts/views/list.dart';
import 'package:ccquarters/alerts/views/form.dart';
import 'package:ccquarters/common/messages/snack_messenger.dart';
import 'package:ccquarters/common/views/loading_view.dart';
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
            return AlertForm(
              alert: state.alert,
            );
          } else if (state is SendingDataState) {
            return BackButtonListener(
              onBackButtonPressed: () async {
                context.read<AlertsPageCubit>().goToAlertsMainPage();
                return true;
              },
              child: const LoadingView(),
            );
          }

          return Container();
        },
      ),
    );
  }
}
