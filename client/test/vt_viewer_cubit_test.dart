import 'package:bloc_test/bloc_test.dart';
import 'package:ccquarters/services/virtual_tours/service.dart';
import 'package:ccquarters/tours/viewer/cubit.dart';
import 'package:flutter_test/flutter_test.dart' as test;
import 'package:test/test.dart';

import 'mocks/file_service_mock.dart';
import 'mocks/mock_data.dart';
import 'mocks/vt_api_mock.dart';

const url = "http://ccquarters.com";

void main() {
  test.TestWidgetsFlutterBinding.ensureInitialized();
  vtViewerCubit();
}

void vtViewerCubit() {
  group('VTViewerCubit', () {
    blocTest<VTViewerCubit, VTViewerState>(
      'emits VTViewingSceneState when useLink is called',
      build: () => VTViewerCubit(
        mockTour,
        VTService(
          VTAPIMock.createVTApiMock(url),
          FileServiceMock(),
          url,
        ),
      ),
      act: (cubit) => cubit.useLink(mockLink),
      expect: () => [isA<VTViewingSceneState>()],
    );

    blocTest<VTViewerCubit, VTViewerState>(
      'emits VTViewingSceneState when addLink is called',
      build: () => VTViewerCubit(
        mockTour,
        VTService(
          VTAPIMock.createVTApiMock(url),
          FileServiceMock(),
          url,
        ),
      ),
      act: (cubit) => cubit.addLink(
          parentId: "1",
          destinationId: "2",
          longitude: 10,
          latitude: 10,
          text: "Korytarz"),
      expect: () => [isA<VTViewingSceneState>()],
    );

    blocTest<VTViewerCubit, VTViewerState>(
      'emits VTViewingSceneState when removeLink is called',
      build: () => VTViewerCubit(
        mockTour,
        VTService(
          VTAPIMock.createVTApiMock(url),
          FileServiceMock(),
          url,
        ),
      ),
      act: (cubit) => cubit.removeLink(mockLink),
      expect: () => [isA<VTViewingSceneState>()],
    );

    blocTest<VTViewerCubit, VTViewerState>(
      'emits VTViewingSceneState when updateLink is called',
      build: () => VTViewerCubit(
        mockTour,
        VTService(
          VTAPIMock.createVTApiMock(url),
          FileServiceMock(),
          url,
        ),
      ),
      act: (cubit) => cubit.updateLink(mockLink),
      expect: () => [isA<VTViewingSceneState>()],
    );
  });
}
