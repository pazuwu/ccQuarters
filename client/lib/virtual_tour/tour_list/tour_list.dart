import 'package:ccquarters/virtual_tour/gate.dart';
import 'package:ccquarters/virtual_tour/model/tour_info.dart';
import 'package:ccquarters/virtual_tour/tour_list/cubit.dart';
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

  @override
  void initState() {
    super.initState();
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      toolbarHeight: 68,
      leading: IconButton(
        onPressed: () {},
        icon: const Icon(Icons.arrow_back),
      ),
      title: const Text("Moje wirtualne spacery"),
    );
  }

  Widget _buildList(BuildContext context) {
    return ListView.builder(
      itemCount: widget._tours.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            ListTile(
              leading: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.blueGrey.shade700,
                ),
                width: 4,
                height: 24,
              ),
              title: Text(widget._tours[index].name),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => VirtualTourGate(
                        tourId: widget._tours[index].id!,
                        readOnly: false,
                      ))),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: context.read<VTListCubit>().hasUserSeenShowcase(),
      builder: (context, snapshot) => ShowCaseWidget(
        builder: Builder(builder: (context) {
          if (snapshot.hasData && !snapshot.data!) {
            WidgetsBinding.instance.addPostFrameCallback(
                (_) => ShowCaseWidget.of(context).startShowCase([_addHint]));

            context.read<VTListCubit>().setUserSeenShowcase();
          }

          return Scaffold(
            floatingActionButton: Showcase(
              key: _addHint,
              descriptionAlignment: TextAlign.left,
              targetBorderRadius: BorderRadius.circular(16),
              description: "Naciśnij, aby dodać wirtualny spcaer",
              child: FloatingActionButton(
                onPressed: () {
                  context.read<VTListCubit>().createTour(name: "");
                },
                tooltip: "Dodaj wirtualny spacer",
                child: const Icon(Icons.add),
              ),
            ),
            appBar: _buildAppBar(context),
            body: _buildList(context),
          );
        }),
      ),
    );
  }
}
