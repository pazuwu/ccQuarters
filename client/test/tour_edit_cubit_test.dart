import 'package:bloc_test/bloc_test.dart';
import 'package:ccquarters/my_tours/scene_list/cubit.dart';
import 'package:ccquarters/my_tours/scene_list/states.dart';
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
  tourEditCubit();
}

void tourEditCubit() {
  group('TourEditCubit', () {
    blocTest<TourEditCubit, TourEditState>(
      'emits TourEditModifyingState and TourEditSuccessState when createNewSceneFromPhoto is called',
      build: () => TourEditCubit(
        VTService(
          VTAPIMock.createVTApiMock(url),
          FileServiceMock(),
          url,
        ),
        mockTourForEdit,
      ),
      act: (cubit) => cubit.createNewSceneFromPhoto(mockPhoto, name: "Test"),
      expect: () =>
          [isA<TourEditModifyingState>(), isA<TourEditSuccessState>()],
    );

    blocTest<TourEditCubit, TourEditState>(
      'emits TourEditModifyingState and TourEditSuccessState when addPhotosToArea with createOperationFlag=false is called',
      build: () => TourEditCubit(
        VTService(
          VTAPIMock.createVTApiMock(url),
          FileServiceMock(),
          url,
        ),
        mockTourForEdit,
      ),
      act: (cubit) => cubit.addPhotosToArea(mockId, [mockPhoto],
          createOperationFlag: false),
      expect: () =>
          [isA<TourEditModifyingState>(), isA<TourEditSuccessState>()],
    );

    blocTest<TourEditCubit, TourEditState>(
      'emits TourEditModifyingState, TourEditSuccessState and TourEditSuccessState when addPhotosToArea with createOperationFlag=true is called',
      build: () => TourEditCubit(
        VTService(
          VTAPIMock.createVTApiMock(url),
          FileServiceMock(),
          url,
        ),
        mockTourForEdit,
      ),
      act: (cubit) =>
          cubit.addPhotosToArea(mockId, [mockPhoto], createOperationFlag: true),
      expect: () => [
        isA<TourEditModifyingState>(),
        isA<TourEditSuccessState>(),
        isA<TourEditSuccessState>(),
      ],
    );

    blocTest<TourEditCubit, TourEditState>(
      'emits TourEditModifyingState and TourEditSuccessState when createNewArea with createOperationFlag=false is called',
      build: () => TourEditCubit(
        VTService(
          VTAPIMock.createVTApiMock(url),
          FileServiceMock(),
          url,
        ),
        mockTourForEdit,
      ),
      act: (cubit) => cubit.createNewArea(
          images: [mockPhoto], name: "Test", createOperation: false),
      expect: () =>
          [isA<TourEditModifyingState>(), isA<TourEditSuccessState>()],
    );

    blocTest<TourEditCubit, TourEditState>(
      'emits TourEditModifyingState, TourEditSuccessState and TourEditSuccessState when createNewArea with createOperationFlag=true is called',
      build: () => TourEditCubit(
        VTService(
          VTAPIMock.createVTApiMock(url),
          FileServiceMock(),
          url,
        ),
        mockTourForEdit,
      ),
      act: (cubit) => cubit.createNewArea(
          images: [mockPhoto], name: "Test", createOperation: true),
      expect: () => [
        isA<TourEditModifyingState>(),
        isA<TourEditSuccessState>(),
        isA<TourEditSuccessState>()
      ],
    );

    blocTest<TourEditCubit, TourEditState>(
      'emits TourEditSuccessState when createNewArea is called',
      build: () => TourEditCubit(
        VTService(
          VTAPIMock.createVTApiMock(url),
          FileServiceMock(),
          url,
        ),
        mockTourForEdit,
      ),
      act: (cubit) => cubit.createOperation(mockId),
      expect: () => [isA<TourEditSuccessState>()],
    );

    blocTest<TourEditCubit, TourEditState>(
      'emits TourEditSuccessState when setAsPrimaryScene is called',
      build: () => TourEditCubit(
        VTService(
          VTAPIMock.createVTApiMock(url),
          FileServiceMock(),
          url,
        ),
        mockTourForEdit,
      ),
      act: (cubit) => cubit.setAsPrimaryScene(mockId),
      expect: () => [isA<TourEditSuccessState>()],
    );

    blocTest<TourEditCubit, TourEditState>(
      'emits TourEditSuccessState when deleteScene is called',
      build: () => TourEditCubit(
        VTService(
          VTAPIMock.createVTApiMock(url),
          FileServiceMock(),
          url,
        ),
        mockTourForEdit,
      ),
      act: (cubit) => cubit.deleteScene(mockId),
      expect: () => [isA<TourEditSuccessState>()],
    );

    blocTest<TourEditCubit, TourEditState>(
      'emits TourEditShowAreaPhotosState when showAreaPhotos is called',
      build: () => TourEditCubit(
        VTService(
          VTAPIMock.createVTApiMock(url),
          FileServiceMock(),
          url,
        ),
        mockTourForEdit,
      ),
      act: (cubit) => cubit.showAreaPhotos(mockArea),
      expect: () => [isA<TourEditShowAreaPhotosState>()],
    );

    blocTest<TourEditCubit, TourEditState>(
      'emits TourEditState when closeAreaPhotos is called',
      build: () => TourEditCubit(
        VTService(
          VTAPIMock.createVTApiMock(url),
          FileServiceMock(),
          url,
        ),
        mockTourForEdit,
      ),
      act: (cubit) => cubit.closeAreaPhotos(),
      expect: () => [isA<TourEditState>()],
    );

    blocTest<TourEditCubit, TourEditState>(
      'emits TourEditState when clearMessages is called',
      build: () => TourEditCubit(
        VTService(
          VTAPIMock.createVTApiMock(url),
          FileServiceMock(),
          url,
        ),
        mockTourForEdit,
      ),
      act: (cubit) => cubit.clearMessages(),
      expect: () => [isA<TourEditState>()],
    );
  });
}
