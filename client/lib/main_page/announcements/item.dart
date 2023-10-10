import 'package:flutter/material.dart';

import '../../utils/consts.dart';

class AnnouncementItem extends StatefulWidget {
  const AnnouncementItem(
      {super.key,
      required this.prize,
      required this.image,
      required this.url,
      required this.height});

  final double prize;
  final Image image;
  final String url;
  final double height;

  @override
  State<AnnouncementItem> createState() => _AnnouncementItemState();
}

class _AnnouncementItemState extends State<AnnouncementItem> {
  double opacity = 0; // Początkowa wartość przejrzystości

  void changeOpacity(bool isHovered) {
    setState(() {
      opacity = isHovered
          ? 0.05
          : 0; // Ustaw nową wartość przejrzystości na podstawie najechania
    });
  }

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Card(
        shadowColor: Theme.of(context).colorScheme.secondary,
        elevation: elevation,
        margin: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: Stack(
            children: [
              Column(
                children: [
                  widget.image,
                  Text("${widget.prize.toStringAsFixed(2)} zł",
                      style: labelStyle),
                ],
              ),
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {},
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}