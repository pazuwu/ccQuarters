import 'package:ccquarters/list_of_houses/cubit.dart';
import 'package:ccquarters/list_of_houses/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListOfHousesGate extends StatelessWidget {
  const ListOfHousesGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ogłoszenia na wynajem"),
      ),
      body: BlocProvider(
        create: (_) => ListOfHousesCubit(
          houseService: context.read(),
        ),
        child: BlocBuilder<ListOfHousesCubit, ListOfHousesState>(
          builder: (context, state) {
            return const ListOfHouses();
          },
        ),
      ),
    );
  }
}
