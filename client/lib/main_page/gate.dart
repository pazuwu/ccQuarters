import 'package:ccquarters/main_page/cubit.dart';
import 'package:ccquarters/main_page/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainPageGate extends StatefulWidget {
  const MainPageGate({super.key});

  @override
  State<MainPageGate> createState() => _MainPageGateState();
}

class _MainPageGateState extends State<MainPageGate> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MainPageCubit(context.read()),
      child: BlocBuilder<MainPageCubit, MainPageState>(
        builder: (context, state) {
          return const MainPage();
        },
      ),
    );
  }
}
