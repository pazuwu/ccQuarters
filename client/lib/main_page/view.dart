import 'package:ccquarters/main_page/cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'announcements/container.dart';
import 'search/search_box.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return RefreshIndicator(
      onRefresh: () {
        return Future.delayed(const Duration(seconds: 1));
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FakeSearchBox(
                color: color,
                onTap: () => context.read<MainPageCubit>().search(),
              ),
              const AnnouncementsContainer(
                title: "Do wynajęcia",
              ),
              const AnnouncementsContainer(
                title: "Do kupienia",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
