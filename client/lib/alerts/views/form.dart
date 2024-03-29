import 'package:ccquarters/alerts/cubit.dart';
import 'package:ccquarters/filters/expansion_panel_list.dart';
import 'package:ccquarters/model/alerts/alert.dart';
import 'package:ccquarters/model/alerts/alert_base.dart';
import 'package:ccquarters/model/houses/filter.dart';
import 'package:ccquarters/model/alerts/new_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AlertForm extends StatelessWidget {
  const AlertForm({
    super.key,
    required this.alert,
  });

  final AlertBase alert;
  @override
  Widget build(BuildContext context) {
    var filters = HouseFilter.fromAlert(alert);
    return BackButtonListener(
      onBackButtonPressed: () async {
        context.read<AlertsPageCubit>().goToAlertsMainPage();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: alert is Alert
              ? const Text("Edytuj alert")
              : const Text("Dodaj nowy alert"),
          leading: BackButton(
            onPressed: context.read<AlertsPageCubit>().goToAlertsMainPage,
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: () {
                context.read<AlertsPageCubit>().saveAlert(alert is Alert
                    ? Alert.fromHouseFilter(filters, (alert as Alert).id)
                    : NewAlert.fromHouseFilter(filters));
              },
            )
          ],
        ),
        body: SingleChildScrollView(
          child: FiltersExpansionPanelList(
            filters: filters,
          ),
        ),
      ),
    );
  }
}
