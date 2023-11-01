import 'package:ccquarters/virtual_tour/model/geo_point.dart';
import 'package:ccquarters/virtual_tour/model/scene.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:panorama_viewer/panorama_viewer.dart';

import 'package:ccquarters/utils/always_visible_label.dart';
import 'package:ccquarters/virtual_tour/cubit.dart';
import 'package:ccquarters/virtual_tour/model/link.dart';
import 'package:ccquarters/virtual_tour/scene_link_form.dart';

enum SceneEditingMode { delete, add, edit, move }

class SceneViewer extends StatefulWidget {
  const SceneViewer({
    Key? key,
    this.editable = false,
    required this.scene,
    required this.cubit,
  }) : super(key: key);

  final bool editable;
  final Scene scene;
  final VirtualTourCubit cubit;

  @override
  State<SceneViewer> createState() => _SceneViewerState();
}

class _SceneViewerState extends State<SceneViewer> {
  SceneEditingMode editingMode = SceneEditingMode.move;

  final List<Link> _links = [];

  Widget _buildAlwaysVisibleButton(
      {VoidCallback? onPressed, Color? color, required IconData icon}) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon),
      style: ButtonStyle(
        shape: MaterialStateProperty.all(const CircleBorder()),
        backgroundColor: MaterialStateProperty.all(Colors.black38),
        foregroundColor: MaterialStateProperty.all(color ?? Colors.white),
      ),
    );
  }

  Widget _buildHotspotButton(BuildContext context, Link link,
      {String? text, required icon, VoidCallback? onPressed}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (editingMode == SceneEditingMode.delete)
          _buildAlwaysVisibleButton(
            onPressed: () {
              setState(() {
                _links.remove(link);
              });
            },
            color: Colors.red,
            icon: Icons.delete,
          )
        else if (editingMode == SceneEditingMode.edit)
          _buildAlwaysVisibleButton(
            onPressed: () {
              _editLink(link);
            },
            icon: Icons.edit,
            color: Colors.white,
          )
        else
          _buildAlwaysVisibleButton(
            onPressed: onPressed,
            icon: icon,
          ),
        const SizedBox(
          height: 3.0,
        ),
        text != null ? AlwaysVisibleTextLabel(text: text) : Container(),
      ],
    );
  }

  IconData _mapEditingModeToIcon(SceneEditingMode mode) {
    switch (mode) {
      case SceneEditingMode.delete:
        return Icons.delete;
      case SceneEditingMode.add:
        return Icons.add;
      case SceneEditingMode.edit:
        return Icons.edit;
      case SceneEditingMode.move:
        return FontAwesomeIcons.upDownLeftRight;
    }
  }

  Widget _buildChangeMode(BuildContext context, SceneEditingMode mode) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: IconButton.filled(
          isSelected: editingMode == mode,
          onPressed: () {
            setState(() {
              editingMode = mode;
            });
          },
          icon: Icon(_mapEditingModeToIcon(mode))),
    );
  }

  Widget _buildToolbar(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      for (var mode in SceneEditingMode.values) _buildChangeMode(context, mode)
    ]);
  }

  Hotspot _buildHotspot(BuildContext context, Link link) {
    return Hotspot(
      latitude: link.position.latitude,
      longitude: link.position.longitude,
      width: 90,
      height: 75,
      widget: _buildHotspotButton(
        onPressed: () {},
        context,
        link,
        text: "next spot",
        icon: Icons.arrow_upward,
      ),
    );
  }

  List<Hotspot> _buildHotSpots(BuildContext context) {
    return [for (var link in _links) _buildHotspot(context, link)];
  }

  void _editLink(Link link) async {
    await showModalBottomSheet(
      useSafeArea: true,
      isDismissible: false,
      isScrollControlled: true,
      enableDrag: true,
      showDragHandle: true,
      context: context,
      builder: (context) => Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: const SceneLinkForm(
          formType: SceneLinkFormType.edit,
        ),
      ),
    );
  }

  void _addNewLink(double longitude, double latitude) async {
    await showModalBottomSheet(
      useSafeArea: true,
      isDismissible: false,
      isScrollControlled: true,
      enableDrag: true,
      showDragHandle: true,
      context: context,
      builder: (context) => Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: const SceneLinkForm(
          formType: SceneLinkFormType.create,
        ),
      ),
    );

    var newLink = await widget.cubit.addNewLink(
      Link(
        destinationId: "",
        text: "",
        position: GeoPoint(latitude: latitude, longitude: longitude),
      ),
    );

    if (newLink != null) {
      _links.add(newLink);
    }
  }

  void _onTap(double longitude, double latitude, double tilt) {
    if (editingMode == SceneEditingMode.add) {
      _addNewLink(longitude, latitude);
    }
  }

  Widget _buildAddHint(BuildContext context) {
    return AnimatedOpacity(
      opacity: editingMode == SceneEditingMode.add ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 500),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: const AlwaysVisibleTextLabel(
              text: "Naciśnij miejsce, w którym chcesz dodać łącznik",
              fontSize: 16),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: _buildAlwaysVisibleButton(
            icon: Icons.arrow_back,
            onPressed: () {
              Navigator.of(context).pop();
            }),
        backgroundColor: Colors.transparent,
        title: _buildAddHint(context),
      ),
      floatingActionButton: _buildToolbar(context),
      body: PanoramaViewer(
        onTap: _onTap,
        hotspots: _buildHotSpots(context),
        minZoom: 1,
        sensitivity: 1.5,
        child: Image.network(widget.scene.photo360Url!,
            loadingBuilder: (context, widget, chunkEvent) {
          return const Center(child: CircularProgressIndicator());
        }),
      ),
    );
  }
}
