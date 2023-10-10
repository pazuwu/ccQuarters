import 'dart:math';
import 'package:flutter/material.dart';
import 'item.dart';

class AnnouncementList extends StatelessWidget {
  const AnnouncementList({super.key});

  @override
  Widget build(BuildContext context) {
    final r = Random();
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(8.0),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) => LayoutBuilder(
              builder: (context, constraints) => AnnouncementItem(
                    prize: r.nextDouble() * 1000000,
                    image: Image.network(
                      index % 2 == 0
                          ? "https://picsum.photos/512"
                          : "https://picsum.photos/216/300",
                      height: constraints.maxHeight * 0.85,
                      fit: BoxFit.fitHeight,
                    ),
                    url: "https://picsum.photos/216/300",
                    height: constraints.maxHeight * 0.85,
                  )),
          itemCount: 30,
        ),
      ),
    );
  }
}
