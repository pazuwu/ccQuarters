import 'package:ccquarters/list_of_houses/cubit.dart';
import 'package:ccquarters/list_of_houses/view.dart';
import 'package:ccquarters/model/offer_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListOfHousesGate extends StatelessWidget {
  const ListOfHousesGate({
    super.key,
    this.isSearch = false,
    this.offerType,
  });

  final bool isSearch;
  final OfferType? offerType;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ListOfHousesCubit(
        houseService: context.read(),
        alertService: context.read(),
        offerType: offerType,
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
