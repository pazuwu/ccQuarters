import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:showcaseview/showcaseview.dart';

import 'package:ccquarters/common/views/show_form.dart';
import 'package:ccquarters/virtual_tour_model/tour_info.dart';
import 'package:ccquarters/my_tours/tour_list/cubit.dart';
import 'package:ccquarters/my_tours/tour_list/tour_form.dart';

class TourList extends StatefulWidget {
  const TourList({
    super.key,
    required tours,
    this.selectionChanged,
  }) : _tours = tours;

  final List<TourInfo> _tours;
  final Function(TourInfo)? selectionChanged;

  @override
  State<TourList> createState() => _TourListState();
}

class _TourListState extends State<TourList> {
  final GlobalKey _addHint = GlobalKey();

  final HashSet<String> _chosenTourIds = HashSet();
  bool _isMultiSelecting = false;
  String? _selectedTourId;

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      leading: MediaQuery.of(context).orientation == Orientation.portrait
          ? IconButton(
              onPressed: () {
                context.go('/profile');
              },
              icon: const Icon(Icons.arrow_back_ios),
            )
          : null,
      toolbarHeight: 68,
      title: const Text("Moje wirtualne spacery"),
      actions: [
        if (_isMultiSelecting)
          IconButton(
              onPressed: () {
                setState(() {
                  _isMultiSelecting = false;
                  _chosenTourIds.clear();
                });
              },
              icon: const Icon(Icons.close))
      ],
    );
  }

  Widget? _buildBottomNavigationBar(BuildContext context) {
    return _chosenTourIds.isEmpty
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
                  if (_chosenTourIds.length == 1)
                    Expanded(
                      child: IconButton(
                        padding: const EdgeInsets.all(0.0),
                        onPressed: () {
                          _editTour(
                              context,
                              widget._tours.firstWhere((element) =>
                                  element.id == _chosenTourIds.first));
                        },
                        icon: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.edit),
                            SizedBox(height: 4),
                            Text("Zmień nazwę"),
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
    if (widget.selectionChanged != null) {
      setState(() {
        _selectedTourId = widget._tours[index].id;
      });
      widget.selectionChanged!(widget._tours[index]);
      return;
    }

    if (_isMultiSelecting) {
      if (_chosenTourIds.contains(widget._tours[index].id)) {
        setState(() {
          _chosenTourIds.remove(widget._tours[index].id);
        });
        return;
      }
      setState(() {
        _chosenTourIds.add(widget._tours[index].id);
      });
      return;
    }
  }

  void _handleTileLongPress(int index) {
    if (_chosenTourIds.isEmpty) {
      setState(() {
        _isMultiSelecting = true;
        _chosenTourIds.add(widget._tours[index].id);
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
      value: _chosenTourIds.contains(widget._tours[index].id),
      onChanged: (value) {
        if (value != null && value) {
          setState(() {
            _chosenTourIds.add(widget._tours[index].id);
          });
        } else {
          setState(() {
            _chosenTourIds.remove(widget._tours[index].id);
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
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
            child: ListTile(
              visualDensity: VisualDensity.compact,
              selectedTileColor: Colors.blueGrey.shade50,
              selected: _chosenTourIds.contains(widget._tours[index].id) ||
                  _selectedTourId == widget._tours[index].id,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: Colors.blueGrey.shade600,
                  width: 1,
                ),
              ),
              onLongPress: () => _handleTileLongPress(index),
              leading: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_isMultiSelecting)
                    _buildTileCheckbox(context, index)
                  else
                    _buildTileIndicator(context),
                ],
              ),
              title: Text(widget._tours[index].name),
              onTap: () => _handleTileTap(index),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 14,
              ),
            ),
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
                context
                    .read<VTListCubit>()
                    .deleteTours(_chosenTourIds.toList());
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

  void _editTour(BuildContext context, TourInfo tourInfo) {
    showForm<String>(
      context: context,
      builder: (BuildContext context) {
        return TourForm(
          tourInfo: tourInfo,
        );
      },
    ).then((tourName) =>
        context.read<VTListCubit>().updateTour(tourInfo.id, tourName!));
  }

  void _createTour(BuildContext context) {
    showForm<String>(
      context: context,
      builder: (BuildContext context) {
        return const TourForm();
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
