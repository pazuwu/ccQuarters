import 'package:bloc_test/bloc_test.dart';
import 'package:ccquarters/services/virtual_tours/service.dart';
import 'package:ccquarters/tours/tour_loader/cubit.dart';
import 'package:ccquarters/tours/tour_loader/states.dart';
import 'package:flutter_test/flutter_test.dart' as test;
import 'package:test/test.dart';

import 'mocks/file_service_mock.dart';
import 'mocks/mock_data.dart';
import 'mocks/vt_api_mock.dart';

const url = "http://ccquarters.com";

class TourLoaderTestingState extends TourLoadingState {}

void main() {
  test.TestWidgetsFlutterBinding.ensureInitialized();
  tourLoaderCubit();
}

void tourLoaderCubit() {
  group('TourLoaderCubit', () {
    blocTest<TourLoaderCubit, TourLoadingState>(
      'emits VTViewingState when loadVirtualTour is called with readOnly=true flag',
      build: () => TourLoaderCubit(
        tourId: mockId,
        readOnly: true,
        initialState: TourLoaderTestingState(),
        service: VTService(
          VTAPIMock.createVTApiMock(url),
          FileServiceMock(),
          url,
        ),
      ),
      wait: const Duration(milliseconds: 500),
      expect: () => [isA<TourLoadedState>()],
    );

    blocTest<TourLoaderCubit, TourLoadingState>(
      'emits VTEditingState when loadVirtualTour is called with readOnly=false flag',
      build: () => TourLoaderCubit(
        readOnly: false,
        tourId: mockId,
        initialState: TourLoaderTestingState(),
        service: VTService(
          VTAPIMock.createVTApiMock(url),
          FileServiceMock(),
          url,
        ),
      ),
      wait: const Duration(milliseconds: 500),
      expect: () => [isA<TourForEditLoadedState>()],
    );
  });
}
