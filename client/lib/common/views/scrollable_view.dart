import 'package:flutter/material.dart';

class ScrollableView extends StatelessWidget {
  ScrollableView({super.key, required this.view});

  final Widget view;
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return MediaQuery.of(context).size.height < 600
        ? Scrollbar(
            controller: _scrollController,
            thumbVisibility: true,
            child: SingleChildScrollView(
              controller: _scrollController,
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxHeight: 600,
                ),
                child: view,
              ),
            ),
          )
        : view;
  }
}
