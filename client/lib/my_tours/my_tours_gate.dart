import 'package:ccquarters/my_tours/scene_list/gate.dart';
import 'package:flutter/material.dart';
import 'package:ccquarters/navigation/history_navigator.dart';

import 'package:ccquarters/my_tours/tour_list/gate.dart';
import 'package:ccquarters/tours/tour_loader/gate.dart';

class MyToursGate extends StatefulWidget {
  const MyToursGate({
    Key? key,
    required this.openedTourId,
  }) : super(key: key);

  final String? openedTourId;

  @override
  State<MyToursGate> createState() => _MyToursGateState();
}

class _MyToursGateState extends State<MyToursGate> {
  late Widget _toursList;
  late Widget _sceneList;
  String? _openedTourId;

  @override
  void initState() {
    super.initState();
    _openedTourId = widget.openedTourId;
    _sceneList = widget.openedTourId != null
        ? TourLoaderGate(
            tourId: widget.openedTourId!,
            tourForEditBuilder: (context, tour) => SceneListGate(
              tour: tour,
            ),
          )
        : Container();
    _toursList = VTListGate(
      initialTourId: _openedTourId,
      selectionChanged: (tourInfo) => context.go(
        Uri(
          path: '/my-tours',
          queryParameters: {'id': tourInfo.id},
        ).toString(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_openedTourId != widget.openedTourId) {
      _rebuildSceneList(context);
    }

    return MediaQuery.of(context).orientation == Orientation.portrait
        ? _buildPortrait(context)
        : _buildLandscape(context);
  }

  void _rebuildSceneList(BuildContext context) {
    setState(() {
      _openedTourId = widget.openedTourId;
      _sceneList = widget.openedTourId != null
          ? TourLoaderGate(
              tourId: widget.openedTourId!,
              tourForEditBuilder: (context, tour) => SceneListGate(
                tour: tour,
              ),
            )
          : Container();
    });
  }

  Widget _buildPortrait(BuildContext context) {
    return _openedTourId == null ? _toursList : _sceneList;
  }

  Widget _buildLandscape(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: _toursList,
          ),
        ),
        VerticalDivider(
          indent: 16,
          endIndent: 16,
          width: 1,
          thickness: 2.0,
          color: Colors.blueGrey.shade50,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: _sceneList,
          ),
        ),
      ],
    );
  }
}

class TourListLandscape extends StatefulWidget {
  const TourListLandscape({
    Key? key,
    required this.sceneWidget,
  }) : super(key: key);

  final Widget sceneWidget;

  @override
  State<TourListLandscape> createState() => _TourListLandscapeState();
}

class _TourListLandscapeState extends State<TourListLandscape> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: VTListGate(
              selectionChanged: (tourInfo) => context.go(
                Uri(
                  path: '/my-tours',
                  queryParameters: {'id': tourInfo.id},
                ).toString(),
              ),
            ),
          ),
        ),
        VerticalDivider(
          indent: 16,
          endIndent: 16,
          width: 1,
          thickness: 2.0,
          color: Colors.blueGrey.shade50,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: widget.sceneWidget,
          ),
        ),
      ],
    );
  }
}
