import 'dart:math';

import 'package:ccquarters/main_page/cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    return Column(
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
    );
  }
}

class AnnouncementsContainer extends StatelessWidget {
  const AnnouncementsContainer({super.key, required this.title});

  final String title;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
        child: Shadow(
          color: Theme.of(context).colorScheme,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              // color: Theme.of(context).colorScheme.surface,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                    child: Text(
                      title,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                const AnnouncementList(),
                SeeMoreButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AnnouncementList extends StatelessWidget {
  const AnnouncementList({super.key});

  @override
  Widget build(BuildContext context) {
    final r = Random();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 20),
        height: 200,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) => AnnouncementItem(
              prize: r.nextDouble() * 1000000,
              image: Image.network("https://picsum.photos/256")),
          itemCount: 30,
        ),
      ),
    );
  }
}

class AnnouncementItem extends StatelessWidget {
  const AnnouncementItem({super.key, required this.prize, required this.image});

  final double prize;
  final Image image;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      width: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).colorScheme.surface,
      ),
      child: Column(
        children: [
          image,
          Text("${prize.toStringAsFixed(2)} zł"),
        ],
      ),
    );
  }
}

class SeeMoreButton extends StatelessWidget {
  const SeeMoreButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextButton(
          onPressed: () {},
          child: const Text(
            "Zobacz wszystkie",
            style: textButtonStyle,
          ),
        ),
      ),
    );
  }
}

const TextStyle textButtonStyle =
    TextStyle(fontSize: 18, fontWeight: FontWeight.w600);
