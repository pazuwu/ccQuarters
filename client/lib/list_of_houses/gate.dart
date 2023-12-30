import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ccquarters/list_of_houses/cubit.dart';
import 'package:ccquarters/list_of_houses/view.dart';
import 'package:ccquarters/model/filter.dart';

class ListOfHousesGate extends StatelessWidget {
  const ListOfHousesGate({
    Key? key,
    this.isSearch = false,
    this.filter,
  }) : super(key: key);

  final bool isSearch;
  final HouseFilter? filter;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ListOfHousesCubit(
        houseService: context.read(),
        alertService: context.read(),
        filter: filter,
      ),
      child: BlocBuilder<ListOfHousesCubit, ListOfHousesState>(
        builder: (context, state) {
          return ListOfHouses(
            isSearch: isSearch,
          );
        },
      ),
    );
  }
}
