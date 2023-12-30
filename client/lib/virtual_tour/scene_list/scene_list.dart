import 'package:ccquarters/common/messages/delete_dialog.dart';
import 'package:ccquarters/common/widgets/icon_360.dart';
import 'package:ccquarters/common/widgets/icon_option_combo.dart';
import 'package:ccquarters/virtual_tour/model/area.dart';
import 'package:ccquarters/virtual_tour/model/tour_for_edit.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ccquarters/common/widgets/always_visible_label.dart';
import 'package:ccquarters/common/images/inkwell_with_photo.dart';
import 'package:ccquarters/common/views/show_form.dart';
import 'package:ccquarters/virtual_tour/model/scene.dart';
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

  final TourForEdit tour;
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
        await cubit.createNewArea(
          images: result.files.map((e) => e.bytes!).toList(),
          name: sceneFormModel.name,
          createOperation: !sceneFormModel.draft,
        );
      }
    }
  }

  void _addPhotosToArea(
      BuildContext context, VTScenesCubit cubit, Area area) async {
    var photos = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      withData: true,
      allowCompression: true,
      type: FileType.image,
    );

    if (photos != null) {
      cubit.addPhotosToArea(
        area.id!,
        photos.files.map((e) => e.bytes!).toList(),
        createOperationFlag: false,
      );
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
              tooltip: "Dodaj scenę",
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
                    tooltip: "Edytuj scenę",
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
                    tooltip: "Usuń scenę",
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
                    tooltip: "Ustaw jako scenę startową",
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

  Widget _buildList(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < (widget.tour.scenes.length / 2).ceil(); i++) ...[
            _buildSingleScenesRow(context, i),
            const SizedBox(
              height: 8.0,
            ),
          ],
          if (widget.tour.areas.isNotEmpty) ...[
            const SizedBox(
              height: 16,
            ),
            Text(
              "W trakcie przetwarzania",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(
              height: 24,
            ),
            for (var i = 0; i < widget.tour.areas.length; i++) ...[
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: widget.tour.areas[i].operationId == null
                      ? Colors.amber.shade50
                      : Colors.blueGrey.shade50,
                ),
                child: ListTile(
                  leading: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.blueGrey.shade700,
                    ),
                    width: 4,
                    height: 24,
                  ),
                  title: Row(
                    children: [
                      Flexible(child: Text(widget.tour.areas[i].name)),
                      const SizedBox(
                        width: 8,
                      ),
                    ],
                  ),
                  subtitle: widget.tour.areas[i].operationId == null
                      ? RichText(
                          text: TextSpan(
                          children: [
                            TextSpan(
                              text:
                                  'Przetwarzanie sceny nie zostało jeszcze rozpoczęte. \n',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium
                                  ?.copyWith(color: Colors.grey.shade600),
                            ),
                            TextSpan(
                              text:
                                  'Kliknij tutaj, aby rozpocząć przetwarzanie.',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium
                                  ?.copyWith(color: Colors.blue),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  context.read<VTScenesCubit>().createOperation(
                                        widget.tour.areas[i].id!,
                                      );
                                },
                            ),
                          ],
                        ))
                      : null,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.tour.areas[i].operationId == null)
                        IconButton(
                          onPressed: () {
                            _addPhotosToArea(
                                context, context.read(), widget.tour.areas[i]);
                          },
                          icon: const Icon(Icons.add_photo_alternate_outlined),
                          tooltip: "Dodaj więcej zdjęć",
                        ),
                      IconButton(
                        onPressed: () {
                          context
                              .read<VTScenesCubit>()
                              .showAreaPhotos(widget.tour.areas[i]);
                        },
                        icon: const Icon(Icons.photo_library_outlined),
                        tooltip: "Podgląd zdjęć",
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              )
            ],
            const SizedBox(
              width: 8,
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: widget.showTitle ? AppBar(title: Text(widget.tour.name)) : null,
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              Expanded(
                child: _buildList(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
