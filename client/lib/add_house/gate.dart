import 'package:ccquarters/add_house/cubit.dart';
import 'package:ccquarters/add_house/views/details_view.dart';
import 'package:ccquarters/add_house/views/location_view.dart';
import 'package:ccquarters/add_house/views/map_view.dart';
import 'package:ccquarters/add_house/views/photo_view.dart';
import 'package:ccquarters/add_house/views/choose_type_and_details_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddHouseGate extends StatelessWidget {
  const AddHouseGate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AddHouseFormCubit(
        houseService: context.read(),
      ),
      child: BlocBuilder<AddHouseFormCubit, HouseFormState>(
        builder: (context, state) {
          if (state is ChooseTypeFormState) {
            return ChooseTypeMainView(
              details: state.houseDetails,
              offerType: state.offerType,
              buildingType: state.buildingType,
            );
          } else if (state is MobileDetailsFormState) {
            return DetailsFormView(
              details: state.houseDetails,
              buildingType: state.buildingType,
              formKey: GlobalKey<FormState>(),
            );
          } else if (state is LocationFormState) {
            return LocationFormView(
              location: state.location,
              buildingType: state.buildingType,
            );
          } else if (state is MapState) {
            return const MapView();
          } else if (state is PhotosFormState) {
            return PhotoView(photos: state.photos);
          } else if (state is SummaryState) {
            return Center(
              child: Text(state.message),
            );
          } else if (state is SendingData) {
            return const CircularProgressIndicator();
          }

          return Container();
        },
      ),
    );
  }
}
