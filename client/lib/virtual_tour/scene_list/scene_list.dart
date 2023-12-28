import 'package:ccquarters/common/messages/delete_dialog.dart';
import 'package:ccquarters/common/widgets/icon_360.dart';
import 'package:ccquarters/common/widgets/icon_option_combo.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ccquarters/common/widgets/always_visible_label.dart';
import 'package:ccquarters/common/images/inkwell_with_photo.dart';
import 'package:ccquarters/common/views/show_form.dart';
import 'package:ccquarters/virtual_tour/model/scene.dart';
import 'package:ccquarters/virtual_tour/model/tour.dart';
import 'package:ccquarters/virtual_tour/scene_list/cubit.dart';
import 'package:ccquarters/virtual_tour/scene_list/scene_form.dart';
import 'package:ccquarters/virtual_tour/service/service.dart';
import 'package:ccquarters/virtual_tour/viewer/tour_viewer.dart';

class SceneList extends StatefulWidget {
  const SceneList({
    Key? key,
    required this.tour,
    this.showTitle = false,
  }) : super(key: key);

  final Tour tour;
  final bool showTitle;

  @override
  State<SceneList> createState() => _SceneListState();
}

class _SceneListState extends State<SceneList> {
  void _showScene(BuildContext context, Scene scene) {
    var vtService = context.read<VTService>();

    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return TourViewer(
        readOnly: false,
        tour: widget.tour,
        service: vtService,
        currentScene: scene,
      );
    }));
  }

  Future<SceneFormModel?> _showChooseImportTypeDialog(BuildContext context) {
    return showForm<SceneFormModel>(
      context: context,
      builder: (BuildContext context) {
        return const SceneForm();
      },
    );
  }

  void _importHandler(BuildContext context, VTScenesCubit cubit) async {
    var sceneFormModel = await _showChooseImportTypeDialog(context);

    if (sceneFormModel == null) return;

    if (sceneFormModel.importType == ImportType.photos360) {
      FilePickerResult? result = await FilePicker.platform
          .pickFiles(type: FileType.image, withData: true);

      if (result?.files.single.bytes != null) {
        await cubit.createNewSceneFromPhoto(result!.files.single.bytes!,
            name: sceneFormModel.name);
      }
    } else if (sceneFormModel.importType == ImportType.photos) {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        withData: true,
        type: FileType.image,
      );

      if (result != null) {
        await cubit.createNewAreaFromPhotos(result.paths,
            name: sceneFormModel.name);
      }
    }
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 16.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Sceny',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            IconButton(
              onPressed: () => _importHandler(context, context.read()),
              icon: Icon(
                Icons.add,
                color: Colors.blueGrey.shade500,
                size: 28,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 24.0,
        ),
      ],
    );
  }

  Widget _buildSceneTile(BuildContext context, Scene scene) {
    return Card(
      margin: const EdgeInsets.all(0.0),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Stack(
        children: [
          InkWellWithPhoto(
            onTap: () {
              _showScene(context, scene);
            },
            imageWidget: Stack(
              children: [
                ConstrainedBox(
                  constraints:
                      const BoxConstraints(maxHeight: 250, minHeight: 250),
                  child: scene.photo360 != null
                      ? SizedBox.expand(
                          child: Image.memory(
                            scene.photo360!,
                            fit: BoxFit.cover,
                          ),
                        )
                      : const Icon360(),
                ),
                Positioned.fill(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(child: Container()),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: AlwaysVisibleTextLabel(
                          text: scene.name,
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
          Positioned(
            top: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: IconOptionCombo(
                children: [
                  IconButton(
                    onPressed: () async {
                      await showForm<SceneFormModel>(
                        context: context,
                        builder: (context) => SceneForm(
                          scene: scene,
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      showDeleteDialog(
                        context,
                        "sceny",
                        "scenę '${scene.name}'",
                        () => context
                            .read<VTScenesCubit>()
                            .deleteScene(scene.id!),
                      );
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      context
                          .read<VTScenesCubit>()
                          .setAsPrimaryScene(scene.id!);
                    },
                    icon: const Icon(
                      Icons.looks_one,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (scene.id == widget.tour.primarySceneId)
            const Positioned(
              top: 0,
              left: 0,
              child: Padding(
                padding: EdgeInsets.all(12.0),
                child: Icon(
                  shadows: [Shadow(blurRadius: 32, color: Colors.black54)],
                  Icons.looks_one,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSingleScenesRow(BuildContext context, int index) {
    return Row(
      children: [
        Expanded(
          child: _buildSceneTile(
            context,
            widget.tour.scenes[2 * index],
          ),
        ),
        if (2 * index + 1 < widget.tour.scenes.length)
          const SizedBox(
            width: 8.0,
          ),
        if (2 * index + 1 < widget.tour.scenes.length)
          Expanded(
            child: _buildSceneTile(
              context,
              widget.tour.scenes[2 * index + 1],
            ),
          ),
      ],
    );
  }

  Widget _buildProgress(double progress) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text("Trwa dodawanie zdjęć..."),
        Row(
          children: [
            LinearProgressIndicator(
              backgroundColor: Colors.blueGrey.shade200,
              value: progress,
            ),
            const SizedBox(
              width: 8.0,
            ),
            Text("${(progress * 100).toStringAsFixed(2)}%"),
          ],
        ),
      ],
    );
  }

  Widget _buildList(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (context, index) {
        return const SizedBox(
          height: 8.0,
        );
      },
      itemCount: (widget.tour.scenes.length / 2).ceil(),
      itemBuilder: (context, index) {
        return _buildSingleScenesRow(context, index);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: widget.showTitle ? AppBar(title: Text(widget.tour.name)) : null,
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
          child: BlocBuilder<VTScenesCubit, VTScenesState>(
              builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                if (state is VTScenesUploadingState)
                  _buildProgress(state.progress),
                Expanded(
                  child: _buildList(context),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
