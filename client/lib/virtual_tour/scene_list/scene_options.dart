import 'package:ccquarters/common_widgets/always_visible_label.dart';
import 'package:ccquarters/common_widgets/show_form.dart';
import 'package:ccquarters/virtual_tour/model/scene.dart';
import 'package:ccquarters/virtual_tour/scene_list/cubit.dart';
import 'package:ccquarters/virtual_tour/scene_list/scene_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SceneOptions extends StatefulWidget {
  const SceneOptions({
    Key? key,
    required this.scene,
    this.iconsHeight = 16,
    this.width = 36,
  }) : super(key: key);

  final Scene scene;
  final double iconsHeight;
  final double? width;

  @override
  State<SceneOptions> createState() => _SceneOptionsState();
}

class _SceneOptionsState extends State<SceneOptions> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return AlwaysVisibleLabel(
      stretch: false,
      borderRadius: BorderRadius.circular(24),
      background: Colors.transparent,
      padding: EdgeInsets.zero,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: widget.width ?? double.infinity),
        child: AnimatedSize(
          alignment: Alignment.topRight,
          reverseDuration: const Duration(milliseconds: 200),
          duration: const Duration(milliseconds: 200),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            color: expanded ? Colors.black54 : Colors.transparent,
            child: Column(
              children: [
                _buildExpandingButton(context),
                AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    transitionBuilder: (child, animation) {
                      return child;
                    },
                    child: expanded
                        ? _buildExapndedToolbar(context)
                        : Container()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExapndedToolbar(BuildContext context) {
    return Column(
      children: [
        IconButton(
          visualDensity: VisualDensity.compact,
          padding: EdgeInsets.zero,
          iconSize: widget.iconsHeight,
          onPressed: () async {
            setState(() {
              expanded = !expanded;
            });
            await showForm<SceneFormModel>(
              context: context,
              builder: (context) => SceneForm(
                scene: widget.scene,
              ),
            );
          },
          icon: const Icon(
            Icons.edit,
            color: Colors.white,
          ),
        ),
        IconButton(
          visualDensity: VisualDensity.compact,
          padding: EdgeInsets.zero,
          iconSize: widget.iconsHeight,
          onPressed: () {
            setState(() {
              expanded = !expanded;
            });
            _deleteScene(context);
          },
          icon: const Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
        IconButton(
          iconSize: widget.iconsHeight,
          onPressed: () {
            setState(() {
              expanded = !expanded;
            });
            context.read<VTScenesCubit>().setAsPrimaryScene(widget.scene.id!);
          },
          icon: const Icon(
            Icons.looks_one,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  void _deleteScene(BuildContext context) {
    showDialog(
      context: context,
      builder: (c) {
        return AlertDialog(
          title: const Text("Usuwanie sceny"),
          content:
              Text("Czy na pewno chcesz usunąć scenę '${widget.scene.name}'?"),
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
                context.read<VTScenesCubit>().deleteScene(widget.scene.id!);
              },
              child: const Text("Usuń"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildExpandingButton(BuildContext context) {
    return IconButton(
      iconSize: widget.iconsHeight,
      visualDensity: VisualDensity.compact,
      onPressed: () {
        setState(() {
          expanded = !expanded;
        });
      },
      icon: Icon(
        expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
        color: Colors.white,
        shadows: const [Shadow(blurRadius: 32, color: Colors.black54)],
      ),
    );
  }
}
