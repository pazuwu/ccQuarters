import 'package:ccquarters/model/alert/alert.dart';
import 'package:ccquarters/model/alert/alert_base.dart';
import 'package:ccquarters/model/alert/new_alert.dart';
import 'package:ccquarters/services/alerts/service.dart';
import 'package:ccquarters/services/service_response.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AlertsState {}

class AlertsMainPageState extends AlertsState {
  AlertsMainPageState({this.isSuccess = true, this.message});

  final String? message;
  final bool isSuccess;
}

class AlertPageState extends AlertsState {
  AlertPageState({
    required this.alert,
  });

  final AlertBase alert;
}

class SendingDataState extends AlertsState {}

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
    emit(SendingDataState());

    if (alert is Alert) {
      if (!await _updateAlert(alert)) return;
    } else if (alert is NewAlert) {
      if (!await _createAlert(alert)) return;
    }

    emit(AlertsMainPageState(message: "Alert został zapisany."));
  }

  Future<bool> _createAlert(NewAlert alert) async {
    final response = await alertService.createAlert(alert);
    if (response.error != ErrorType.none) {
      if (response.error == ErrorType.emptyRequest) {
        emit(AlertsMainPageState(
          message: "Nie można wysłać pustego alertu.",
          isSuccess: false,
        ));
      } else {
        emit(AlertsMainPageState(
          message: "Nie udało się wysłać alertu. Spróbuj ponownie później.",
          isSuccess: false,
        ));
      }
      return false;
    }
    return true;
  }

  Future<bool> _updateAlert(Alert alert) async {
    final response = await alertService.updateAlert(alert);
    if (response.error != ErrorType.none) {
      emit(AlertsMainPageState(
        message:
            "Nie udało się zaktualizować alertu. Spróbuj ponownie później.",
        isSuccess: false,
      ));
      return false;
    }
    return true;
  }

  Future<void> deleteAlert(Alert alert) async {
    emit(SendingDataState());

    final response = await alertService.deleteAlert(alert.id);
    if (response.error != ErrorType.none) {
      emit(AlertsMainPageState(
        message: "Nie udało się usunąć alertu. Spróbuj ponownie później.",
        isSuccess: false,
      ));
      return;
    }

    emit(AlertsMainPageState(
      message: "Alert został usunięty.",
    ));
  }

  Future<void> goToAlertsMainPage() async {
    emit(AlertsMainPageState());
  }

  Future<void> goToAlertPage(AlertBase alert) async {
    emit(AlertPageState(alert: alert));
  }
}
