import 'package:bloc_test/bloc_test.dart';
import 'package:ccquarters/services/virtual_tours/service.dart';
import 'package:ccquarters/tours/tour_loader/cubit.dart';
import 'package:ccquarters/tours/tour_loader/states.dart';
import 'package:flutter_test/flutter_test.dart' as test;
import 'package:test/test.dart';

import 'mocks/file_service_mock.dart';
import 'mocks/vt_api_mock.dart';

const url = "http://ccquarters.com";

class VTTestingState extends TourLoadingState {}

void main() {
  test.TestWidgetsFlutterBinding.ensureInitialized();
  virtualTourCubit();
}

void virtualTourCubit() {
  const id = "cb849fa2-1033-4d6b-7c88-08db36d6f10f";
  group('VirtualTourCubit', () {
    blocTest<TourLoaderCubit, TourLoadingState>(
      'emits VTViewingState when loadVirtualTour is called with readOnly=true flag',
      build: () => TourLoaderCubit(
        tourId: id,
        readOnly: true,
        initialState: VTTestingState(),
        service: VTService(
          VTAPIMock.createVTApiMock(url),
          FileServiceMock(),
          url,
        ),
      ),
      expect: () => [isA<TourLoadedState>()],
    );

    blocTest<TourLoaderCubit, TourLoadingState>(
      'emits VTEditingState when loadVirtualTour is called with readOnly=false flag',
      build: () => TourLoaderCubit(
        readOnly: false,
        tourId: id,
        initialState: VTTestingState(),
        service: VTService(
          VTAPIMock.createVTApiMock(url),
          FileServiceMock(),
          url,
        ),
      ),
      expect: () => [isA<TourForEditLoadedState>()],
    );
  });
}
