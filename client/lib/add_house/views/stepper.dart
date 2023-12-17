import 'package:ccquarters/add_house/cubit.dart';
import 'package:ccquarters/add_house/states.dart';
import 'package:ccquarters/add_house/views/choose_type_and_details_view.dart';
import 'package:ccquarters/add_house/views/details_view.dart';
import 'package:ccquarters/add_house/views/location_view.dart';
import 'package:ccquarters/add_house/views/map_view.dart';
import 'package:ccquarters/add_house/views/photo_view.dart';
import 'package:ccquarters/house_details/cubit.dart';
import 'package:ccquarters/utils/consts.dart';
import 'package:ccquarters/utils/device_type.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ViewsWithStepper extends StatefulWidget {
  const ViewsWithStepper({
    Key? key,
    required this.state,
    required this.editMode,
  }) : super(key: key);

  final StepperPageState state;
  final bool editMode;
  @override
  State<ViewsWithStepper> createState() => _ViewsWithStepperState();
}

class _ViewsWithStepperState extends State<ViewsWithStepper> {
  int activeStep = 0;
  final _detailsFormKey = GlobalKey<FormState>();
  final _locationFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    activeStep = _getStepIndex();
    return Scaffold(
      appBar: widget.editMode
          ? AppBar(
              title: const Text("Edytuj ogłoszenie"),
              leading: BackButton(
                onPressed:
                    context.read<HouseDetailsCubit>().goBackToHouseDetails,
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    if (_validateAndSaveData(widget.state, false)) {
                      context.read<AddHouseFormCubit>().updateHouse();
                    }
                  },
                  icon: const Icon(Icons.check),
                )
              ],
            )
          : null,
      body: Column(
        children: [
          _buildStepper(context),
          Expanded(
            child: _buildView(widget.state),
          ),
        ],
      ),
    );
  }

  Widget _buildView(StepperPageState state) {
    if (state is ChooseTypeFormState) {
      return ChooseTypeMainView(
        details: state.houseDetails,
        offerType: state.offerType,
        buildingType: state.buildingType,
        detailsFormKey: _detailsFormKey,
      );
    } else if (state is MobileDetailsFormState) {
      return DetailsFormView(
        details: state.houseDetails,
        buildingType: state.buildingType,
        formKey: _detailsFormKey,
      );
    } else if (state is LocationFormState) {
      return LocationFormView(
        location: state.location,
        buildingType: state.buildingType,
        formKey: _locationFormKey,
      );
    } else if (state is MapState) {
      return const MapView();
    } else if (state is PhotosFormState) {
      return PhotoView(
        oldPhotos: state.oldPhotos,
        newPhotos: state.newPhotos,
        deletedPhotos: state.deletedPhotos,
        editMode: widget.editMode,
        createVirtualTour: state.createVirtualTour,
      );
    }

    return Container();
  }

  Widget _buildStepper(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        smallPaddingSize,
        largePaddingSize,
        smallPaddingSize,
        0,
      ),
      color: Colors.grey[200],
      child: EasyStepper(
        steppingEnabled: widget.editMode,
        activeStep: activeStep,
        lineStyle: const LineStyle(
          lineLength: 70,
          lineSpace: 0,
          lineType: LineType.normal,
          defaultLineColor: Colors.white,
          finishedLineColor: Colors.blueGrey,
          lineThickness: 1.5,
        ),
        activeStepTextColor: Colors.black87,
        finishedStepTextColor: Colors.black87,
        internalPadding: 50,
        showLoadingAnimation: false,
        stepRadius: 8,
        showStepBorder: false,
        steps: _getSteps(getDeviceType(context) == DeviceType.mobile),
        onStepReached: (index) => _goToChoosenPage(index, widget.state),
      ),
    );
  }

  int _getStepIndex() {
    var isMobile = getDeviceType(context) == DeviceType.mobile;

    if (widget.state is ChooseTypeFormState) {
      return _getChooseTypeIndex();
    } else if (widget.state is MobileDetailsFormState) {
      return _getDetailsIndex();
    } else if (widget.state is LocationFormState) {
      return _getLocationIndex(isMobile);
    } else if (widget.state is MapState) {
      return _getMapIndex();
    } else if (widget.state is PhotosFormState) {
      return _getPhotosIndex(isMobile);
    }

    return 0;
  }

  void _goToChoosenPage(int index, StepperPageState state) {
    var isMobile = getDeviceType(context) == DeviceType.mobile;

    if (!_validateAndSaveData(state, isMobile)) return;

    if (index == _getChooseTypeIndex()) {
      context.read<AddHouseFormCubit>().goToChooseTypeForm();
    } else if (index == _getDetailsIndex()) {
      context.read<AddHouseFormCubit>().goToDetailsForm();
    } else if (index == _getLocationIndex(isMobile)) {
      context.read<AddHouseFormCubit>().goToLocationForm();
    } else if (index == _getMapIndex()) {
      context.read<AddHouseFormCubit>().goToMap();
    } else if (index == _getPhotosIndex(isMobile)) {
      context.read<AddHouseFormCubit>().goToPhotosForm();
    }
  }

  bool _validateAndSaveData(StepperPageState state, bool isMobile) {
    if (state is ChooseTypeFormState) {
      if (!isMobile && _detailsFormKey.currentState!.validate()) {
        _detailsFormKey.currentState!.save();
        context.read<AddHouseFormCubit>().saveDetails(state.houseDetails);
      } else if (!isMobile) {
        return false;
      }
    } else if (state is MobileDetailsFormState) {
      if (_detailsFormKey.currentState!.validate()) {
        _detailsFormKey.currentState!.save();
        context.read<AddHouseFormCubit>().saveDetails(state.houseDetails);
      } else {
        return false;
      }
    } else if (state is LocationFormState) {
      if (_locationFormKey.currentState!.validate()) {
        _locationFormKey.currentState!.save();
        context.read<AddHouseFormCubit>().saveLocation(state.location);
      } else {
        return false;
      }
    } else if (state is PhotosFormState) {
      context.read<AddHouseFormCubit>().savePhotos(
            state.newPhotos,
            state.oldPhotos,
            state.deletedPhotos,
          );
    }

    return true;
  }

  List<EasyStep> _getSteps(bool isMobile) {
    return [
      _buildStep("Wybierz typ", _getChooseTypeIndex(), false),
      if (isMobile) _buildStep("Uzupełnij szczegóły", _getDetailsIndex(), true),
      _buildStep("Lokalizacja", _getLocationIndex(isMobile), !isMobile),
      if (isMobile) _buildStep("Mapa", _getMapIndex(), true),
      _buildStep("Zdjęcia", _getPhotosIndex(isMobile), false),
      _buildStep("Wysyłanie", _getSendingIndex(isMobile), true),
    ];
  }

  int _getChooseTypeIndex() => 0;
  int _getDetailsIndex() => 1;
  int _getLocationIndex(bool isMobile) => isMobile ? 2 : 1;
  int _getMapIndex() => 3;
  int _getPhotosIndex(bool isMobile) => isMobile ? 4 : 2;
  int _getSendingIndex(bool isMobile) => isMobile ? 5 : 3;

  EasyStep _buildStep(String title, int index, bool topTitle) {
    return EasyStep(
      customStep: CircleAvatar(
        radius: 10,
        backgroundColor: Colors.white,
        child: CircleAvatar(
          radius: 7,
          backgroundColor: activeStep >= index ? Colors.blueGrey : Colors.white,
        ),
      ),
      title: title,
      topTitle: topTitle,
    );
  }
}
