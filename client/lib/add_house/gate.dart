import 'package:ccquarters/add_house/cubit.dart';
import 'package:ccquarters/add_house/views/stepper.dart';
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
              steppingEnabled: house != null,
            );
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
