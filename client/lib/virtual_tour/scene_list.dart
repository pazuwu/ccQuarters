import 'dart:math';

import 'package:ccquarters/utils/always_visible_label.dart';
import 'package:ccquarters/utils/icon_360.dart';
import 'package:ccquarters/utils/image.dart';
import 'package:ccquarters/utils/inkwell_with_photo.dart';
import 'package:ccquarters/virtual_tour/import_type_dialog.dart';
import 'package:ccquarters/virtual_tour/scene.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:ccquarters/virtual_tour/scene_viewer.dart';

class SceneList extends StatelessWidget {
  const SceneList({
    Key? key,
    required this.rooms,
  }) : super(key: key);

  final List<Scene> rooms;

  void _showScene(BuildContext context, Scene room) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return SceneViewer(
        editable: true,
        sceneUrl: room.url,
      );
    }));
  }

  Future<void> _showChooseImportTypeDialog(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      enableDrag: true,
      showDragHandle: true,
      builder: (BuildContext context) {
        return const ImportTypeDialog();
      },
    );
  }

  Widget _buildAddNew(BuildContext context) {
    return Card(
        child: InkWell(
      onTap: () {
        _showChooseImportTypeDialog(context);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            FaIcon(
              FontAwesomeIcons.personShelter,
              size: 50,
              color: Theme.of(context).colorScheme.primary,
            ),
            Text(
              'Dodaj nowy pokój',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
    ));
  }

  Widget _buildRoomTile(BuildContext context, Scene room) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24.0),
      child: Card(
        shadowColor: Colors.grey.shade200,
        child: InkWellWithPhoto(
          onTap: () {
            _showScene(context, room);
          },
          imageWidget: Stack(
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 250),
                child: ImageWidget(
                  imageUrl:
                      'https://picsum.photos/1000/2000?=${Random().nextDouble()}',
                ),
              ),
              Positioned.fill(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const AlwaysVisibleLabel(
                      background: Colors.black54,
                      padding: EdgeInsets.all(0.0),
                      child: Icon360(
                        color: Colors.white,
                      ),
                    ),
                    Expanded(child: Container()),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AlwaysVisibleTextLabel(
                        text: room.name,
                        fontSize:
                            Theme.of(context).textTheme.labelLarge?.fontSize,
                        fontWeight: FontWeight.w500,
                        background: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSingleRoomsRow(BuildContext context, int index) {
    return Row(
      children: [
        Expanded(child: _buildRoomTile(context, rooms[2 * index])),
        if (2 * index + 1 < rooms.length)
          const SizedBox(
            width: 4.0,
          ),
        if (2 * index + 1 < rooms.length)
          Expanded(child: _buildRoomTile(context, rooms[2 * index + 1])),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ConstrainedBox(
        constraints: BoxConstraints.loose(const Size.fromWidth(600)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 8.0,
              ),
              _buildAddNew(context),
              const SizedBox(
                height: 8.0,
              ),
              Expanded(
                child: ListView.separated(
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        height: 8,
                      );
                    },
                    itemCount: (rooms.length / 2).ceil(),
                    itemBuilder: (context, index) {
                      return _buildSingleRoomsRow(context, index);
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
