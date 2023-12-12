import 'package:ccquarters/alerts/cubit.dart';
import 'package:ccquarters/model/alert.dart';
import 'package:ccquarters/profile/cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AlertsView extends StatelessWidget {
  const AlertsView({super.key, required this.alerts});

  final List<Alert> alerts;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Alerty"),
        leading: BackButton(
          onPressed: context.read<ProfilePageCubit>().goToProfilePage,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              context
                  .read<AlertsPageCubit>()
                  .goToAlertPage(null);
            },
          )
        ],
      ),
      body: alerts.isNotEmpty
          ? ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                final alert = alerts[index];
                return ListTile(
                  title: Text("${alert.city} ${alert.district}"),
                  onTap: () {
                    context.read<AlertsPageCubit>().goToAlertPage(alert);
                  },
                );
              },
              itemCount: alerts.length,
            )
          : const Center(
              child: Text("Brak alertów. Dodaj nowe!"),
            ),
    );
  }
}
