import 'package:ccquarters/virtual_tour/scene_list.dart';
import 'package:ccquarters/virtual_tour/service/service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ccquarters/virtual_tour/cubit.dart';
import 'package:provider/provider.dart';

class VirtualTourGate extends StatelessWidget {
  const VirtualTourGate({
    Key? key,
    required this.houseId,
  }) : super(key: key);

  final String houseId;

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => VTService(dio: Dio(), url: ""),
      child: BlocProvider.value(
          value: VirtualTourCubit(
              initialState: VTLoadingState(houseId: houseId),
              service: context.read()),
          child: BlocBuilder<VirtualTourCubit, VTState>(
            builder: (context, state) {
              if (state is VTLoadingState) {
                return const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      Text("Trwa ładowanie wirtualnego spaceru..."),
                    ],
                  ),
                );
              }

              if (state is VTLoadedState) {
                return SceneList(scenes: state.virtualTour.scenes);
              }

              if (state is VTErrorState) {
                return Center(
                  child: Text(state.text),
                );
              }

              return const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                        "Wystąpił błąd poczas ładowania wirtualnego spaceru. "),
                    Text("Przepraszamy za utrudnienia"),
                  ],
                ),
              );
            },
          )),
    );
  }
}
