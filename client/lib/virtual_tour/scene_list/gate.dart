import 'package:cached_network_image/cached_network_image.dart';
import 'package:ccquarters/common/messages/snack_messenger.dart';
import 'package:ccquarters/virtual_tour/model/tour_for_edit.dart';
import 'package:ccquarters/virtual_tour/scene_list/scene_list.dart';
import 'package:ccquarters/virtual_tour/scene_list/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ccquarters/virtual_tour/scene_list/cubit.dart';

class SceneListGate extends StatelessWidget {
  const SceneListGate({
    Key? key,
    required this.tour,
  }) : super(key: key);

  final TourForEdit tour;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: VTScenesCubit(context.read(), tour),
      child: BlocBuilder<VTScenesCubit, VTScenesState>(
        builder: (context, state) {
          SnackMessenger.hide(context);
          if (state is VTScenesLoadingState) {
            SnackMessenger.showLoading(context, state.message);
          } else if (state is VTScenesSuccessState) {
            SnackMessenger.showSuccess(context, state.message);
          } else if (state is VTScenesErrorState) {
            SnackMessenger.showError(context, state.message);
          } else if (state is VTScenesUploadFailedState) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _showPhotosSendingFailedDialog(context, state);
            });
          } else if (state is VTScenesCreateOperationFailedState) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _showOperationSendFailedDialog(context, state);
            });
          }

          if (state is ShowAreaPhotosState) {
            return Scaffold(
              appBar: AppBar(
                title: Text(state.area.name),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    context.read<VTScenesCubit>().closeAreaPhotos();
                  },
                ),
              ),
              body: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 8.0,
                  crossAxisSpacing: 8.0,
                ),
                itemCount: state.photoUrls.length,
                itemBuilder: (context, index) {
                  return CachedNetworkImage(
                    imageUrl: state.photoUrls[index],
                    fit: BoxFit.cover,
                  );
                },
              ),
            );
          }

          return SceneList(tour: state.tour);
        },
      ),
    );
  }

  void _showPhotosSendingFailedDialog(
      BuildContext context, VTScenesUploadFailedState state) {
    showDialog(
      context: context,
      builder: (c) {
        return AlertDialog(
          title: Text(
              "Wystąpił błąd podczas wysyłania części zdjęć (${state.failedImages.length})"),
          content: const Text(
              "Upewnij się, że masz dostęp do Internetu i spróbuj jeszcze raz.\n"
              "Pamiętaj, że brak niektórych zdjęć może negatywnie wpłynąc na jakość utworzonej sceny.\n"
              "Możesz je również dodać później z poziomu listy scen."),
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
                context.read<VTScenesCubit>().addPhotosToArea(
                      state.areaId,
                      state.failedImages,
                    );
              },
              child: const Text("Ponów"),
            ),
          ],
        );
      },
    );
  }

  void _showOperationSendFailedDialog(
      BuildContext context, VTScenesCreateOperationFailedState state) {
    showDialog(
      context: context,
      builder: (c) {
        return AlertDialog(
          title: const Text(
              "Wystąpił błąd podczas próby rozpoczęcia przetwrzania"),
          content: const Text(
              "Upewnij się, że masz dostęp do Internetu i spróbuj jeszcze raz. \n"
              "Przetwarzanie możesz również rozpocząć później z poziomu listy scen."),
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
                context.read<VTScenesCubit>().createOperation(
                      state.areaId,
                      state.attempt,
                    );
              },
              child: const Text("Ponów"),
            ),
          ],
        );
      },
    );
  }
}
