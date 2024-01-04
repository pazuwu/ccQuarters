import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ccquarters/common/messages/error_message.dart';
import 'package:ccquarters/my_tours/tour_list/cubit.dart';
import 'package:ccquarters/my_tours/tour_list/tour_list.dart';
import 'package:ccquarters/virtual_tour_model/tour_info.dart';

class VTListGate extends StatelessWidget {
  const VTListGate({
    Key? key,
    this.initialTourId,
    this.selectionChanged,
  }) : super(key: key);

  final String? initialTourId;
  final Function(TourInfo)? selectionChanged;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<VTListCubit>(
          create: (context) => VTListCubit(
              vtService: context.read(), state: VTListLoadingState()),
          child: BlocBuilder<VTListCubit, VTListState>(
            builder: (context, state) {
              if (state is VTListLoadingState) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is VTTourProcessingState) {
                return Stack(
                  children: [
                    IgnorePointer(child: TourList(tours: state.tours)),
                    Positioned.fill(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 5.0,
                          sigmaY: 5.0,
                        ),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const CircularProgressIndicator(),
                              const SizedBox(height: 16),
                              Text(state.prcessingText),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              } else if (state is VTListLoadedState) {
                return TourList(
                  initialTourId: initialTourId,
                  tours: state.tours,
                  selectionChanged: selectionChanged,
                );
              } else if (state is VTListErrorState) {
                return ErrorMessage(
                  state.message,
                  tip: state.tip,
                  closeButton: true,
                );
              }

              return Container();
            },
          )),
    );
  }
}
