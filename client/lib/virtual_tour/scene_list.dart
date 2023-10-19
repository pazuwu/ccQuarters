import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
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

  void _showRoom(BuildContext context, Scene room) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return SceneViewer(
        editable: true,
        sceneUrl: room.url,
      );
    }));
  }

  Widget _buildAddNew(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 150),
      child: Card(
          child: InkWell(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            FaIcon(
              FontAwesomeIcons.personShelter,
              size: 100,
              color: Theme.of(context).colorScheme.primary,
            ),
            Text(
              'Dodaj nowy pokój',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ]),
        ),
      )),
    );
  }

  Widget _buildRoomTile(BuildContext context, Scene room) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24.0),
      child: Card(
        shadowColor: Colors.grey.shade200,
        child: InkWell(
          onTap: () {
            _showRoom(context, room);
          },
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 300),
              child: CachedNetworkImage(
                  fadeInDuration: const Duration(milliseconds: 700),
                  placeholder: (context, text) {
                    return const Center(child: CircularProgressIndicator());
                  },
                  imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            )),
                      ),
                  imageUrl:
                      'https://picsum.photos/1000/2000?=${Random().nextDouble()}'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                room.name,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _buildSingleRoomsRow(BuildContext context, int index) {
    return Row(
      children: [
        Expanded(child: _buildRoomTile(context, rooms[2 * index])),
        const SizedBox(
          width: 4.0,
        ),
        if (2 * index + 1 < rooms.length)
          _buildRoomTile(context, rooms[2 * index + 1]),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ConstrainedBox(
        constraints: BoxConstraints.loose(const Size.fromWidth(600)),
        child: ListView.separated(
            separatorBuilder: (context, index) {
              return const SizedBox(
                height: 8,
              );
            },
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            itemCount: (rooms.length / 2).ceil() + 1,
            itemBuilder: (context, index) {
              if (index == 0) return _buildAddNew(context);

              return _buildSingleRoomsRow(context, index - 1);
            }),
      ),
    );
  }
}
