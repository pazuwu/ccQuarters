import 'package:ccquarters/alerts/alert_details.dart';
import 'package:ccquarters/alerts/cubit.dart';
import 'package:ccquarters/common/consts.dart';
import 'package:ccquarters/common/messages/delete_dialog.dart';
import 'package:ccquarters/common/widgets/icon_option_combo.dart';
import 'package:ccquarters/model/alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class AlertListItem extends StatelessWidget {
  const AlertListItem({super.key, required this.alert});

  final Alert alert;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Card(
          shadowColor: Theme.of(context).colorScheme.secondary,
          elevation: elevation,
          margin: const EdgeInsets.all(8),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          child: Slidable(
            endActionPane:
                MediaQuery.of(context).orientation == Orientation.landscape
                    ? null
                    : _buildActionPane(context),
            child: AlertDetails(alert: alert),
          ),
        ),
        if (MediaQuery.of(context).orientation == Orientation.landscape)
          Positioned(
            right: 0,
            top: 0,
            child: _buildIconOptionCombo(context),
          ),
      ],
    );
  }

  ActionPane _buildActionPane(BuildContext context) {
    return ActionPane(
      motion: const ScrollMotion(),
      children: [
        SlidableAction(
          onPressed: (_) => _editAlert(context),
          backgroundColor: Colors.blueGrey[300]!,
          foregroundColor: Colors.white,
          icon: Icons.edit,
        ),
        SlidableAction(
          onPressed: (_) => _deleteAlert(context),
          backgroundColor: Colors.blueGrey,
          foregroundColor: Colors.white,
          icon: Icons.delete,
        ),
      ],
    );
  }

  Widget _buildIconOptionCombo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(mediumPaddingSize),
      child: IconOptionCombo(
        foreground: Colors.black,
        children: [
          IconButton(
            onPressed: () {
              _editAlert(context);
            },
            icon: const Icon(
              Icons.edit,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () {
              _deleteAlert(context);
            },
            icon: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  void _editAlert(BuildContext context) {
    context.read<AlertsPageCubit>().goToAlertPage(alert);
  }

  void _deleteAlert(BuildContext context) {
    showDeleteDialog(context, "alertu", "alert", () {
      context.read<AlertsPageCubit>().deleteAlert(alert);
    });
  }
}
