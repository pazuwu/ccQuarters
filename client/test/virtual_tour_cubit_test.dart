import 'package:bloc_test/bloc_test.dart';
import 'package:ccquarters/virtual_tour/service/service.dart';
import 'package:ccquarters/virtual_tour/tour/cubit.dart';
import 'package:flutter_test/flutter_test.dart' as test;
import 'package:test/test.dart';

import 'mocks/file_service_mock.dart';
import 'mocks/vt_api_mock.dart';

const url = "http://ccquarters.com";

class VTTestingState extends VTState {}

void main() {
  test.TestWidgetsFlutterBinding.ensureInitialized();
  virtualTourCubit();
}

void virtualTourCubit() {
  const id = "cb849fa2-1033-4d6b-7c88-08db36d6f10f";
  group('VirtualTourCubit', () {
    blocTest<VirtualTourCubit, VTState>(
      'emits VTViewingState when loadVirtualTour is called with readOnly=true flag',
      build: () => VirtualTourCubit(
        initialState: VTTestingState(),
        service: VTService(
          VTAPIMock.createVTApiMock(url),
          FileServiceMock(),
          url,
        ),
      ),
      act: (cubit) => cubit.loadVirtualTour(id, true),
      expect: () => [isA<VTViewingState>()],
    );

    blocTest<VirtualTourCubit, VTState>(
      'emits VTEditingState when loadVirtualTour is called with readOnly=false flag',
      build: () => VirtualTourCubit(
        initialState: VTTestingState(),
        service: VTService(
          VTAPIMock.createVTApiMock(url),
          FileServiceMock(),
          url,
        ),
      ),
      act: (cubit) => cubit.loadVirtualTour(id, false),
      expect: () => [isA<VTEditingState>()],
    );
  });
}
