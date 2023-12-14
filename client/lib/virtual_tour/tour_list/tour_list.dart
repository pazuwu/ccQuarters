import 'package:ccquarters/virtual_tour/model/tour_info.dart';
import 'package:ccquarters/virtual_tour/tour/gate.dart';
import 'package:ccquarters/virtual_tour/tour_list/cubit.dart';
import 'package:ccquarters/virtual_tour/tour_list/new_tour_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showcaseview/showcaseview.dart';

class TourList extends StatefulWidget {
  const TourList({required List<TourInfo> tours, super.key}) : _tours = tours;

  final List<TourInfo> _tours;

  @override
  State<TourList> createState() => _TourListState();
}

class _TourListState extends State<TourList> {
  final GlobalKey _addHint = GlobalKey();

  final List<TourInfo> _chosenTours = [];

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      toolbarHeight: 68,
      title: const Text("Moje wirtualne spacery"),
    );
  }

  Widget? _buildBottomNavigationBar(BuildContext context) {
    return _chosenTours.isEmpty
        ? null
        : BottomAppBar(
            shape: AutomaticNotchedShape(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16))),
            color: Colors.blueGrey.shade50,
            child: SizedBox(
              height: 72,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: IconButton(
                      padding: const EdgeInsets.all(0.0),
                      onPressed: () => _deleteTours(context),
                      icon: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.delete),
                          SizedBox(height: 4),
                          Text("Usuń"),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  void _handleTileTap(int index) {
    if (_chosenTours.isNotEmpty) {
      if (_chosenTours.contains(widget._tours[index])) {
        setState(() {
          _chosenTours.remove(widget._tours[index]);
        });
        return;
      }
      setState(() {
        _chosenTours.add(widget._tours[index]);
      });
      return;
    }

    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => VirtualTourGate(
              tourId: widget._tours[index].id,
              readOnly: false,
            )));
  }

  void _handleTileLongPress(int index) {
    if (_chosenTours.isEmpty) {
      setState(() {
        _chosenTours.add(widget._tours[index]);
      });
    }
  }

  Widget _buildTileIndicator(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.blueGrey.shade700,
      ),
      width: 4,
      height: 24,
    );
  }

  Widget _buildTileCheckbox(BuildContext context, int index) {
    return Checkbox(
      value: _chosenTours.contains(widget._tours[index]),
      onChanged: (value) {
        if (value != null && value) {
          setState(() {
            _chosenTours.add(widget._tours[index]);
          });
        } else {
          setState(() {
            _chosenTours.remove(widget._tours[index]);
          });
        }
      },
    );
  }

  Widget _buildList(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await context.read<VTListCubit>().loadTours();
      },
      child: ListView.builder(
        itemCount: widget._tours.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              ListTile(
                onLongPress: () => _handleTileLongPress(index),
                leading: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_chosenTours.isEmpty)
                      _buildTileIndicator(context)
                    else
                      _buildTileCheckbox(context, index),
                  ],
                ),
                title: Text(widget._tours[index].name),
                onTap: () => _handleTileTap(index),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                ),
              ),
              Divider(
                indent: 8,
                endIndent: 8,
                height: 1,
                color: Colors.blueGrey.shade50,
              )
            ],
          );
        },
      ),
    );
  }

  void _deleteTours(BuildContext context) {
    showDialog(
      context: context,
      builder: (c) {
        return AlertDialog(
          title: const Text("Usuwanie wirtualnych spacerów"),
          content: const Text(
              "Czy na pewno chcesz usunąć wybrane wirtualne spacery?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(c).pop();
              },
              child: const Text("Anuluj"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(c).pop();
                context.read<VTListCubit>().deleteTours(_chosenTours);
              },
              child: const Text("Usuń"),
            ),
          ],
        );
      },
    );
  }

  void _handleShowcase(AsyncSnapshot<bool> snapshot) {
    if (snapshot.hasData && !snapshot.data!) {
      WidgetsBinding.instance.addPostFrameCallback(
          (_) => ShowCaseWidget.of(context).startShowCase([_addHint]));

      context.read<VTListCubit>().setUserSeenShowcase();
    }
  }

  void _createTour(BuildContext context) {
    showModalBottomSheet<String>(
      context: context,
      enableDrag: true,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return const NewTourDialog();
      },
    ).then(
        (tourName) => context.read<VTListCubit>().createTour(name: tourName!));
  }

  Widget _buildFloatingActionButtons(BuildContext context) {
    return Showcase(
      key: _addHint,
      descriptionAlignment: TextAlign.left,
      targetBorderRadius: BorderRadius.circular(16),
      description: "Naciśnij, aby dodać wirtualny spcaer",
      child: FloatingActionButton(
        onPressed: () => _createTour(context),
        tooltip: "Dodaj wirtualny spacer",
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: context.read<VTListCubit>().hasUserSeenShowcase(),
      builder: (context, snapshot) => ShowCaseWidget(
        builder: Builder(builder: (context) {
          _handleShowcase(snapshot);

          return Scaffold(
            appBar: _buildAppBar(context),
            body: _buildList(context),
            bottomNavigationBar: _buildBottomNavigationBar(context),
            floatingActionButton: _buildFloatingActionButtons(context),
          );
        }),
      ),
    );
  }
}
