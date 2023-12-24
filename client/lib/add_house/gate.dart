import 'package:ccquarters/add_house/cubit.dart';
import 'package:ccquarters/add_house/states.dart';
import 'package:ccquarters/add_house/views/stepper.dart';
import 'package:ccquarters/house_details/cubit.dart';
import 'package:ccquarters/house_details/gate.dart';
import 'package:ccquarters/model/new_house.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddHouseGate extends StatelessWidget {
  const AddHouseGate({super.key, this.house});

  final NewHouse? house;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AddHouseFormCubit(
        houseService: context.read(),
        vtService: context.read(),
        house: house,
      ),
      child: BlocBuilder<AddHouseFormCubit, HouseFormState>(
        builder: (context, state) {
          if (state is StepperPageState) {
            return ViewsWithStepper(
              state: state,
              editMode: house != null,
            );
          } else if (state is SendingFinishedState) {
            return _buildSendingFinishedView(context, state);
          } else if (state is ErrorState) {
            return Scaffold(
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        state.message,
                        textAlign: TextAlign.center,
                      ),
                      TextButton(
                        child: const Text("Powtórz wysyłanie"),
                        onPressed: () => house == null
                            ? context.read<AddHouseFormCubit>().sendData()
                            : context.read<AddHouseFormCubit>().updateHouse(),
                      )
                    ],
                  ),
                ),
              ),
            );
          } else if (state is SendingDataState) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
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
        if (house != null) {
          context.read<HouseDetailsCubit>().loadHouseDetails();
        } else {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => HouseDetailsGate(
                houseId: state.houseId,
              ),
            ),
          );
        }
      },
    );

    return Scaffold(
      body: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              house != null
                  ? "Ogłoszenie zostało zaktualizowane"
                  : "Ogłoszenie zostało dodane",
              textScaler: const TextScaler.linear(1.3),
            ),
            const Icon(Icons.done)
          ],
        ),
      ),
    );
  }
}
