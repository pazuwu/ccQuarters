import 'package:ccquarters/model/alert.dart';
import 'package:ccquarters/model/alert_base.dart';
import 'package:ccquarters/model/new_alert.dart';
import 'package:ccquarters/services/alerts/service.dart';
import 'package:ccquarters/services/service_response.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AlertsState {}

class AlertsMainPageState extends AlertsState {}

class AlertPageState extends AlertsState {
  AlertPageState({
    required this.alert,
  });

  final AlertBase alert;
}

class LoadingOrSendingDataState extends AlertsState {}

class ErrorState extends AlertsState {
  ErrorState({required this.message});
  final String message;
}

class AlertsPageCubit extends Cubit<AlertsState> {
  AlertsPageCubit({
    required this.alertService,
  }) : super(AlertsMainPageState());

  AlertService alertService;

  Future<List<Alert>> getAlerts(int pageNumber, int pageCount) async {
    final response = await alertService.getAlerts(
      pageNumber: pageNumber,
      pageCount: pageCount,
    );

    if (response.error != ErrorType.none) {
      return [];
    }

    return response.data;
  }

  Future<void> saveAlert(AlertBase alert) async {
    emit(LoadingOrSendingDataState());

    if (alert is Alert) {
      await _updateAlert(alert);
    } else if (alert is NewAlert) {
      await _createAlert(alert);
    }

    emit(AlertsMainPageState());
  }

  Future<void> _createAlert(NewAlert alert) async {
    final response = await alertService.createAlert(alert);
    if (response.error != ErrorType.none) {
      emit(ErrorState(
          message: "Nie udało się wysłać alertu. Spróbuj ponownie później."));
      return;
    }
  }

  Future<void> _updateAlert(Alert alert) async {
    final response = await alertService.updateAlert(alert);
    if (response.error != ErrorType.none) {
      emit(ErrorState(
          message:
              "Nie udało się zaktualizować alertu. Spróbuj ponownie później."));
      return;
    }
  }

  Future<void> deleteAlert(Alert alert) async {
    emit(LoadingOrSendingDataState());

    final response = await alertService.deleteAlert(alert.id);
    if (response.error != ErrorType.none) {
      emit(ErrorState(
          message: "Nie udało się usunąć alertu. Spróbuj ponownie później."));
      return;
    }

    emit(AlertsMainPageState());
  }

  Future<void> goToAlertsMainPage() async {
    emit(AlertsMainPageState());
  }

  Future<void> goToAlertPage(AlertBase alert) async {
    emit(AlertPageState(alert: alert));
  }
}
