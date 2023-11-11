import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:ccquarters/utils/always_visible_label.dart';
import 'package:ccquarters/utils/icon_360.dart';
import 'package:ccquarters/utils/inkwell_with_photo.dart';
import 'package:ccquarters/virtual_tour/scene_list/cubit.dart';
import 'package:ccquarters/virtual_tour/scene_list/import_type_dialog.dart';
import 'package:ccquarters/virtual_tour/model/scene.dart';
import 'package:ccquarters/virtual_tour/model/tour.dart';
import 'package:ccquarters/virtual_tour/service/service.dart';
import 'package:ccquarters/virtual_tour/viewer/tour_viewer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SceneList extends StatelessWidget {
  const SceneList({
    Key? key,
    required this.tour,
  }) : super(key: key);

  final Tour tour;

  void _showScene(BuildContext context, Scene scene) {
    var vtService = context.read<VTService>();

    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return TourViewer(
        readOnly: false,
        tour: tour,
        service: vtService,
        currentScene: scene,
      );
    }));
  }

  Future<ImportType?> _showChooseImportTypeDialog(BuildContext context) {
    return showModalBottomSheet<ImportType>(
      context: context,
      enableDrag: true,
      showDragHandle: true,
      builder: (BuildContext context) {
        return const ImportTypeDialog();
      },
    );
  }

  void _importHandler(BuildContext context, VTScenesCubit cubit) async {
    var importType = await _showChooseImportTypeDialog(context);

    if (importType == ImportType.photos360) {
      FilePickerResult? result =
          await FilePicker.platform.pickFiles(type: FileType.image);

      if (result?.files.single.path != null) {
        await cubit.createNewSceneFromPhoto(result!.files.single.path!);
      }
    } else if (importType == ImportType.photos) {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.image,
      );

      if (result != null) {
        await cubit.createNewAreaFromPhotos(result.paths);
      }
    }
  }

  Widget _buildAddNew(BuildContext context) {
    return Card(
        child: InkWell(
      onTap: () => _importHandler(context, context.read()),
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

  Widget _buildSceneTile(BuildContext context, Scene scene) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24.0),
      child: Card(
        shadowColor: Colors.grey.shade200,
        child: InkWellWithPhoto(
          onTap: () {
            _showScene(context, scene);
          },
          imageWidget: Stack(
            children: [
              ConstrainedBox(
                constraints:
                    const BoxConstraints(maxHeight: 250, minHeight: 250),
                child: scene.photo360 != null
                    ? Image.memory(
                        scene.photo360!,
                        fit: BoxFit.cover,
                      )
                    : CachedNetworkImage(
                        fadeInDuration: const Duration(milliseconds: 700),
                        placeholder: (context, text) {
                          return const Center(
                              child: CircularProgressIndicator());
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
      ),
    );
  }

  Widget _buildSingleScenesRow(BuildContext context, int index) {
    return Row(
      children: [
        Expanded(child: _buildSceneTile(context, tour.scenes[2 * index])),
        if (2 * index + 1 < tour.scenes.length)
          const SizedBox(
            width: 4.0,
          ),
        if (2 * index + 1 < tour.scenes.length)
          Expanded(child: _buildSceneTile(context, tour.scenes[2 * index + 1])),
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

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: VTScenesCubit(context.read(), tour),
      child: SafeArea(
        child: Scaffold(
          body: ConstrainedBox(
            constraints: BoxConstraints.loose(const Size.fromWidth(600)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: BlocBuilder<VTScenesCubit, VTScenesState>(
                  builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 8.0,
                    ),
                    _buildAddNew(context),
                    const SizedBox(
                      height: 8.0,
                    ),
                    if (state is VTScenesUploadingState)
                      _buildProgress(state.progress),
                    const SizedBox(
                      height: 8.0,
                    ),
                    Expanded(
                      child: ListView.separated(
                          separatorBuilder: (context, index) {
                            return const SizedBox(
                              height: 8.0,
                            );
                          },
                          itemCount: (tour.scenes.length / 2).ceil(),
                          itemBuilder: (context, index) {
                            return _buildSingleScenesRow(context, index);
                          }),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
