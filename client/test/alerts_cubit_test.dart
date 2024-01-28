import 'package:bloc_test/bloc_test.dart';
import 'package:ccquarters/alerts/cubit.dart';
import 'package:ccquarters/services/alerts/service.dart';
import 'package:test/test.dart';

import 'mocks/alerts_api_mock.dart';
import 'mocks/mock_data.dart';

const url = "http://ccquarters.com";

void main() {
  alertsCubit();
}

void alertsCubit() {
  group('AlertsCubit', () {
    blocTest<AlertsPageCubit, AlertsState>(
      'emits SendingDataState and AlertsMainPageState when saveAlert with empty new alert is called',
      build: () => AlertsPageCubit(
        alertService: AlertService(
          AlertsAPIMock.createAlertsApiMock("$url/alerts"),
          "$url/alerts",
        ),
      ),
      act: (cubit) => cubit.saveAlert(mockEmptyNewAlert),
      expect: () => [
        isA<SendingDataState>(),
        isA<AlertsMainPageState>()
            .having((p0) => p0.isSuccess, "isSuccess", false)
      ],
    );

    blocTest<AlertsPageCubit, AlertsState>(
      'emits SendingDataState and AlertsMainPageState when saveAlert with empty alert is called',
      build: () => AlertsPageCubit(
        alertService: AlertService(
          AlertsAPIMock.createAlertsApiMock("$url/alerts"),
          "$url/alerts",
        ),
      ),
      act: (cubit) => cubit.saveAlert(mockEmptyAlert),
      expect: () => [
        isA<SendingDataState>(),
        isA<AlertsMainPageState>()
            .having((p0) => p0.isSuccess, "isSuccess", false)
      ],
    );

    blocTest<AlertsPageCubit, AlertsState>(
      'emits SendingDataState and AlertsMainPageState when saveAlert with not empty new alert is called',
      build: () => AlertsPageCubit(
        alertService: AlertService(
          AlertsAPIMock.createAlertsApiMock("$url/alerts"),
          "$url/alerts",
        ),
      ),
      act: (cubit) => cubit.saveAlert(mockNewAlert),
      expect: () => [
        isA<SendingDataState>(),
        isA<AlertsMainPageState>()
            .having((p0) => p0.isSuccess, "isSuccess", true)
      ],
    );

    blocTest<AlertsPageCubit, AlertsState>(
      'emits SendingDataState and AlertsMainPageState when saveAlert with not empty alert is called',
      build: () => AlertsPageCubit(
        alertService: AlertService(
          AlertsAPIMock.createAlertsApiMock("$url/alerts"),
          "$url/alerts",
        ),
      ),
      act: (cubit) => cubit.saveAlert(mockAlert),
      expect: () => [
        isA<SendingDataState>(),
        isA<AlertsMainPageState>()
            .having((p0) => p0.isSuccess, "isSuccess", true)
      ],
    );

    blocTest<AlertsPageCubit, AlertsState>(
      'emits SendingDataState and AlertsMainPageState when deleteAlert is called',
      build: () => AlertsPageCubit(
        alertService: AlertService(
          AlertsAPIMock.createAlertsApiMock("$url/alerts"),
          "$url/alerts",
        ),
      ),
      act: (cubit) => cubit.deleteAlert(mockAlert),
      expect: () => [
        isA<SendingDataState>(),
        isA<AlertsMainPageState>()
            .having((p0) => p0.isSuccess, "isSuccess", true)
      ],
    );

    blocTest<AlertsPageCubit, AlertsState>(
      'emits AlertPageState when goToAlertPage is called',
      build: () => AlertsPageCubit(
        alertService: AlertService(
          AlertsAPIMock.createAlertsApiMock("$url/alerts"),
          "$url/alerts",
        ),
      ),
      act: (cubit) => cubit.goToAlertPage(mockAlert),
      expect: () => [isA<AlertPageState>()],
    );

    blocTest<AlertsPageCubit, AlertsState>(
      'emits AlertsMainPageState when goToAlertPage is called',
      build: () => AlertsPageCubit(
        alertService: AlertService(
          AlertsAPIMock.createAlertsApiMock("$url/alerts"),
          "$url/alerts",
        ),
      ),
      act: (cubit) => cubit.goToAlertsMainPage(),
      expect: () => [isA<AlertsMainPageState>()],
    );
  });
}
