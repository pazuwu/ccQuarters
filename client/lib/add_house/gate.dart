import 'package:ccquarters/add_house/cubit.dart';
import 'package:ccquarters/add_house/states.dart';
import 'package:ccquarters/add_house/views/stepper.dart';
import 'package:ccquarters/common/messages/error_message.dart';
import 'package:ccquarters/common/messages/message.dart';
import 'package:ccquarters/common/views/loading_view.dart';
import 'package:ccquarters/house_details/cubit.dart';
import 'package:ccquarters/house_details/gate.dart';
import 'package:ccquarters/model/house/new_house.dart';
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
          } else {
            return BackButtonListener(
              onBackButtonPressed: () async {
                context.read<AddHouseFormCubit>().clear();
                return true;
              },
              child: _getInfoView(state, context),
            );
          }
        },
      ),
    );
  }

  Widget _getInfoView(HouseFormState state, BuildContext context) {
    if (state is SendingFinishedState) {
      return _buildSendingFinishedView(context, state);
    } else if (state is ErrorState) {
      return ErrorMessage(
        state.message,
        actionButton: true,
        actionButtonTitle: "Powtórz wysyłanie",
        onAction: () => () => house == null
            ? context.read<AddHouseFormCubit>().sendData()
            : context.read<AddHouseFormCubit>().updateHouse(),
      );
    } else if (state is SendingDataState) {
      return const LoadingView();
    }

    return Container();
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

    return Message(
      title: house != null
          ? "Ogłoszenie zostało zaktualizowane"
          : "Ogłoszenie zostało dodane",
      imageWidget: Image.asset("assets/graphics/check.png"),
    );
  }
}
