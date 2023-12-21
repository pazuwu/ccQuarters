import 'package:ccquarters/alerts/cubit.dart';
import 'package:ccquarters/alerts/alert_list_item.dart';
import 'package:ccquarters/common_widgets/error_message.dart';
import 'package:ccquarters/common_widgets/message.dart';
import 'package:ccquarters/model/alert.dart';
import 'package:ccquarters/model/new_alert.dart';
import 'package:ccquarters/profile/cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class AlertsView extends StatefulWidget {
  const AlertsView({super.key});

  @override
  State<AlertsView> createState() => _AlertsViewState();
}

class _AlertsViewState extends State<AlertsView> {
  final PagingController<int, Alert> _pagingController =
      PagingController(firstPageKey: 0);
  final _numberOfPostsPerRequest = 10;

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      var alerts = await context
          .read<AlertsPageCubit>()
          .getAlerts(pageKey, _numberOfPostsPerRequest);
      final isLastPage = alerts.length < _numberOfPostsPerRequest;
      if (isLastPage) {
        _pagingController.appendLastPage(alerts);
      } else {
        var nextPageKey = pageKey + 1;
        _pagingController.appendPage(alerts, nextPageKey);
      }
    } catch (e) {
      _pagingController.error = e;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _pagingController.dispose();
  }

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
              context.read<AlertsPageCubit>().goToAlertPage(NewAlert());
            },
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => _pagingController.refresh(),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width *
                  (MediaQuery.of(context).orientation == Orientation.landscape
                      ? 0.5
                      : 1),
            ),
            child: PagedListView<int, Alert>(
              pagingController: _pagingController,
              builderDelegate: PagedChildBuilderDelegate<Alert>(
                noItemsFoundIndicatorBuilder: (context) => const Message(
                  title: "Nie posiadasz żadnych alertów",
                  subtitle: "Dodaj je klikając przycisk +",
                  icon: Icons.collections_bookmark,
                  adjustToLandscape: true,
                  padding: EdgeInsets.all(8.0),
                ),
                firstPageErrorIndicatorBuilder: (context) => const ErrorMessage(
                  "Nie udało się pobrać alertów",
                  tip: "Sprawdź połączenie z internetem i spróbuj ponownie",
                ),
                newPageErrorIndicatorBuilder: (context) => const ErrorMessage(
                  "Nie udało się pobrać alertów",
                  tip: "Sprawdź połączenie z internetem i spróbuj ponownie",
                ),
                itemBuilder: (context, alert, index) {
                  return AlertListItem(alert: alert);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
