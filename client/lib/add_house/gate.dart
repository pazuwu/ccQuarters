import 'package:ccquarters/add_house/cubit.dart';
import 'package:ccquarters/add_house/views/details_view.dart';
import 'package:ccquarters/add_house/views/location_view.dart';
import 'package:ccquarters/add_house/views/map_view.dart';
import 'package:ccquarters/add_house/views/photo_view.dart';
import 'package:ccquarters/add_house/views/choose_type_and_details_view.dart';
import 'package:ccquarters/house_details/gate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddHouseGate extends StatelessWidget {
  const AddHouseGate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AddHouseFormCubit(
        houseService: context.read(),
        vtService: context.read(),
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
            return PhotoView(
                photos: state.photos,
                createVirtualTour: state.createVirtualTour);
          } else if (state is SendingFinishedState) {
            _buildSendingFinishedView(context, state);
          } else if (state is ErrorState) {
            return Center(
              child: Column(
                children: [
                  Text(state.message),
                  TextButton(
                    child: const Text("Powtórz wysyłanie"),
                    onPressed: () =>
                        context.read<AddHouseFormCubit>().sendData(),
                  )
                ],
              ),
            );
          } else if (state is SendingDataState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Container();
        },
      ),
    );
  }

  Widget _buildSendingFinishedView(
      BuildContext context, SendingFinishedState state) {
    Future.delayed(
      const Duration(seconds: 2),
      () {
        context.read<AddHouseFormCubit>().clear();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => HouseDetailsGate(
              houseId: state.houseId,
            ),
          ),
        );
      },
    );

    return const Scaffold(
      body: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Ogłoszenie zostało dodane",
              textScaler: TextScaler.linear(1.5),
            ),
            Icon(Icons.done)
          ],
        ),
      ),
    );
  }
}
