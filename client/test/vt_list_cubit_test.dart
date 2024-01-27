import 'package:bloc_test/bloc_test.dart';
import 'package:ccquarters/my_tours/tour_list/cubit.dart';
import 'package:ccquarters/services/virtual_tours/service.dart';
import 'package:flutter_test/flutter_test.dart' as test;
import 'package:test/test.dart';

import 'mocks/file_service_mock.dart';
import 'mocks/mock_data.dart';
import 'mocks/vt_api_mock.dart';

const url = "http://ccquarters.com";

class VTListTestingState extends VTListState {}

void main() {
  test.TestWidgetsFlutterBinding.ensureInitialized();
  vtListCubit();
}

void vtListCubit() {
  group('VTListCubit', () {
    blocTest<VTListCubit, VTListState>(
      'emits VTListLoadedState when loadTours is called',
      build: () => VTListCubit(
        vtService: VTService(
          VTAPIMock.createVTApiMock(url),
          FileServiceMock(),
          url,
        ),
        state: VTListTestingState(),
      ),
      act: (cubit) => cubit.loadTours(),
      expect: () => [isA<VTListLoadedState>()],
    );

    blocTest<VTListCubit, VTListState>(
      'emits VTTourProcessingState and VTListLoadedState when createTour is called',
      build: () => VTListCubit(
        vtService: VTService(
          VTAPIMock.createVTApiMock(url),
          FileServiceMock(),
          url,
        ),
        state: VTListTestingState(),
      ),
      act: (cubit) => cubit.createTour(name: "Test tour"),
      expect: () => [isA<VTTourProcessingState>(), isA<VTListLoadedState>()],
    );

    blocTest<VTListCubit, VTListState>(
      'emits VTTourProcessingState and VTListLoadedState when deleteTours is called',
      build: () => VTListCubit(
        vtService: VTService(
          VTAPIMock.createVTApiMock(url),
          FileServiceMock(),
          url,
        ),
        state: VTListTestingState(),
      ),
      act: (cubit) => cubit.deleteTours([mockId]),
      expect: () => [isA<VTTourProcessingState>(), isA<VTListLoadedState>()],
    );

    blocTest<VTListCubit, VTListState>(
      'emits VTTourProcessingState and VTListLoadedState when updateTour is called',
      build: () => VTListCubit(
        vtService: VTService(
          VTAPIMock.createVTApiMock(url),
          FileServiceMock(),
          url,
        ),
        state: VTListTestingState(),
      ),
      act: (cubit) => cubit.updateTour(mockId, "Test tour"),
      expect: () => [isA<VTTourProcessingState>(), isA<VTListLoadedState>()],
    );
  });
}
