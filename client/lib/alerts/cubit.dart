import 'package:ccquarters/model/alert.dart';
import 'package:ccquarters/services/alerts/service.dart';
import 'package:ccquarters/services/service_response.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AlertsState {}

class AlertsMainPageState extends AlertsState {}

class AlertPageState extends AlertsState {
  AlertPageState({
    required this.alert,
  });

  final Alert? alert;
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

  Future<void> saveAlert(Alert alert) async {
    emit(LoadingOrSendingDataState());

    if (alert.id.isEmpty) {
      _createAlert(alert);
    } else {
      await _updateAlert(alert);
    }

    emit(AlertsMainPageState());
  }

  Future<void> _createAlert(Alert alert) async {
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

  Future<void> goToAlertsMainPage() async {
    emit(AlertsMainPageState());
  }

  Future<void> goToAlertPage(Alert? alert) async {
    emit(AlertPageState(alert: alert));
  }
}
