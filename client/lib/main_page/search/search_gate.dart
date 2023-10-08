import 'package:ccquarters/main_page/cubit.dart';
import 'package:ccquarters/main_page/search/search_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchGate extends StatefulWidget {
  const SearchGate({
    Key? key,
  }) : super(key: key);

  @override
  State<SearchGate> createState() => _SearchGateState();
}

class _SearchGateState extends State<SearchGate> {
  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 68,
          leading: IconButton(
            onPressed: () => context.read<MainPageCubit>().goBack(),
            icon: const Icon(Icons.arrow_back),
          ),
          title: SearchBox(
            color: color,
            controller: controller,
          ),
        ),
        body: Container());
  }
}
