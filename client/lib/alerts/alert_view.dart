import 'package:ccquarters/alerts/cubit.dart';
import 'package:ccquarters/list_of_houses/filters/expansion_panel_list.dart';
import 'package:ccquarters/model/alert.dart';
import 'package:ccquarters/model/filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AlertView extends StatelessWidget {
  const AlertView({
    super.key,
    required this.alert,
  });

  final Alert? alert;
  @override
  Widget build(BuildContext context) {
    var filters = alert != null ? HouseFilter.fromAlert(alert!) : HouseFilter();
    return Scaffold(
      appBar: AppBar(
        title: alert != null
            ? const Text("Dodaj nowy alert")
            : const Text("Edytuj alert"),
        leading: BackButton(
          onPressed: context.read<AlertsPageCubit>().goToAlertsMainPage,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              context
                  .read<AlertsPageCubit>()
                  .saveAlert(Alert.fromHouseFilter(filters));
            },
          )
        ],
      ),
      body: FiltersExpansionPanelList(
        filters: filters,
      ),
    );
  }
}
