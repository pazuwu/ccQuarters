import 'package:ccquarters/add_house/cubit.dart';
import 'package:ccquarters/add_house/states.dart';
import 'package:ccquarters/add_house/views/choose_type_and_details_view.dart';
import 'package:ccquarters/add_house/views/details_view.dart';
import 'package:ccquarters/add_house/views/location_view.dart';
import 'package:ccquarters/add_house/views/map_view.dart';
import 'package:ccquarters/add_house/views/photo_view.dart';
import 'package:ccquarters/add_house/views/virtual_tour_view.dart';
import 'package:ccquarters/house_details/cubit.dart';
import 'package:ccquarters/navigation/history_navigator.dart';
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
  final _virtualTourFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    activeStep = _getStepIndex();
    return BackButtonListener(
      onBackButtonPressed: _goBack,
      child: Scaffold(
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
            if (!widget.editMode)
              Column(
                children: [
                  const SizedBox(height: 8),
                  _buildHeader(),
                ],
              ),
            const SizedBox(height: 12),
            _buildStepper(context),
            Divider(
              color: Colors.blueGrey.shade300,
              thickness: 1,
              height: 1,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _buildView(widget.state),
            ),
          ],
        ),
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
    } else if (state is PortraitDetailsFormState) {
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
      );
    } else if (state is VirtualTourFormState) {
      return VirtualTourFormView(
        usedVirtualTour: state.usedVirtualTour,
        editMode: widget.editMode,
        formKey: _virtualTourFormKey,
      );
    }

    return Container();
  }

  Widget _buildStepper(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: EasyStepper(
        padding: EdgeInsetsGeometryTween(
          begin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          end: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        )
            .animate(CurvedAnimation(
              parent: ModalRoute.of(context)!.animation!,
              curve: Curves.easeInOut,
            ))
            .value,
        steppingEnabled: widget.editMode,
        activeStep: activeStep,
        lineStyle: LineStyle(
          lineLength: 90,
          lineSpace: 0,
          lineType: LineType.normal,
          defaultLineColor: Colors.grey.shade300,
          finishedLineColor: Colors.blueGrey,
          lineThickness: 1.5,
        ),
        unreachedStepBackgroundColor: Colors.blueGrey,
        activeStepTextColor: Colors.black87,
        finishedStepTextColor: Colors.black87,
        internalPadding: 50,
        showLoadingAnimation: false,
        stepAnimationDuration: const Duration(milliseconds: 200),
        stepRadius: 8,
        steps: _getSteps(
            MediaQuery.of(context).orientation == Orientation.portrait),
        onStepReached: (index) => _goToChoosenPage(index, widget.state),
      ),
    );
  }

  int _getStepIndex() {
    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    if (widget.state is ChooseTypeFormState) {
      return _getChooseTypeIndex();
    } else if (widget.state is PortraitDetailsFormState) {
      return _getDetailsIndex();
    } else if (widget.state is LocationFormState) {
      return _getLocationIndex(isPortrait);
    } else if (widget.state is MapState) {
      return _getMapIndex();
    } else if (widget.state is PhotosFormState) {
      return _getPhotosIndex(isPortrait);
    } else if (widget.state is VirtualTourFormState) {
      return _getVirtualTourIndex(isPortrait);
    }

    return 0;
  }

  Future<bool> _goBack() async {
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    if (activeStep == _getChooseTypeIndex()) {
      context.goBack();
    } else if (activeStep == _getDetailsIndex()) {
      context.read<AddHouseFormCubit>().goToChooseTypeForm();
    } else if (activeStep == _getLocationIndex(isPortrait)) {
      context.read<AddHouseFormCubit>().goToDetailsForm();
    } else if (activeStep == _getMapIndex()) {
      context.read<AddHouseFormCubit>().goToLocationForm();
    } else if (activeStep == _getPhotosIndex(isPortrait)) {
      context.read<AddHouseFormCubit>().goToMap();
    } else if (activeStep == _getVirtualTourIndex(isPortrait)) {
      context.read<AddHouseFormCubit>().goToPhotosForm();
    }

    return true;
  }

  void _goToChoosenPage(int index, StepperPageState state) {
    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    if (!_validateAndSaveData(state, isPortrait)) return;

    if (index == _getChooseTypeIndex()) {
      context.read<AddHouseFormCubit>().goToChooseTypeForm();
    } else if (isPortrait && index == _getDetailsIndex()) {
      context.read<AddHouseFormCubit>().goToDetailsForm();
    } else if (index == _getLocationIndex(isPortrait)) {
      context.read<AddHouseFormCubit>().goToLocationForm();
    } else if (isPortrait && index == _getMapIndex()) {
      context.read<AddHouseFormCubit>().goToMap();
    } else if (index == _getPhotosIndex(isPortrait)) {
      context.read<AddHouseFormCubit>().goToPhotosForm();
    } else if (index == _getVirtualTourIndex(isPortrait)) {
      context.read<AddHouseFormCubit>().goToVirtualTourForm();
    }
  }

  bool _validateAndSaveData(StepperPageState state, bool isPortrait) {
    if (state is ChooseTypeFormState) {
      if (!isPortrait && _detailsFormKey.currentState!.validate()) {
        _detailsFormKey.currentState!.save();
        context.read<AddHouseFormCubit>().saveDetails(state.houseDetails);
      } else if (!isPortrait) {
        return false;
      }
    } else if (state is PortraitDetailsFormState) {
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
    } else if (state is VirtualTourFormState) {
      if (_virtualTourFormKey.currentState!.validate()) {
        _virtualTourFormKey.currentState!.save();
      } else {
        return false;
      }
    }

    return true;
  }

  List<EasyStep> _getSteps(bool isPortrait) {
    return [
      _buildStep("Wybierz typ", _getChooseTypeIndex(), false),
      if (isPortrait)
        _buildStep("Uzupełnij szczegóły", _getDetailsIndex(), true),
      _buildStep("Lokalizacja", _getLocationIndex(isPortrait), !isPortrait),
      if (isPortrait) _buildStep("Mapa", _getMapIndex(), true),
      _buildStep("Zdjęcia", _getPhotosIndex(isPortrait), false),
      _buildStep("Wirtualny spacer", _getVirtualTourIndex(isPortrait), true),
    ];
  }

  int _getChooseTypeIndex() => 0;
  int _getDetailsIndex() => 1;
  int _getLocationIndex(bool isPortrait) => isPortrait ? 2 : 1;
  int _getMapIndex() => 3;
  int _getPhotosIndex(bool isPortrait) => isPortrait ? 4 : 2;
  int _getVirtualTourIndex(bool isPortrait) => isPortrait ? 5 : 3;

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

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.blueGrey,
        ),
        height: 64,
        child: Row(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(
                Icons.newspaper,
                color: Colors.white,
              ),
            ),
            Text(
              "Nowe ogłoszenie",
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
