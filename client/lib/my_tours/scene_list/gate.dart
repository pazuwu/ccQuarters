import 'package:cached_network_image/cached_network_image.dart';
import 'package:ccquarters/common/images/inkwell_with_photo.dart';
import 'package:ccquarters/common/messages/snack_messenger.dart';
import 'package:ccquarters/common/views/show_gallery.dart';
import 'package:ccquarters/my_tours/scene_list/scene_list.dart';
import 'package:ccquarters/my_tours/scene_list/states.dart';
import 'package:ccquarters/model/virtual_tours/tour_for_edit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ccquarters/my_tours/scene_list/cubit.dart';

class SceneListGate extends StatelessWidget {
  const SceneListGate({
    Key? key,
    required this.tour,
  }) : super(key: key);

  final TourForEdit tour;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: TourEditCubit(
        context.read(),
        tour,
      ),
      child: BlocBuilder<TourEditCubit, TourEditState>(
        builder: (context, state) {
          if (state is TourEditModifyingState) {
            SnackMessenger.showLoading(context, state.message);
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.read<TourEditCubit>().clearMessages();
            });
          } else if (state is TourEditSuccessState) {
            SnackMessenger.showSuccess(context, state.message);
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.read<TourEditCubit>().clearMessages();
            });
          } else if (state is TourEditErrorState) {
            SnackMessenger.showError(context, state.message);
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.read<TourEditCubit>().clearMessages();
            });
          } else if (state is TourEditUploadingFailedState) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _showPhotosSendingFailedDialog(context, state);
              context.read<TourEditCubit>().clearMessages();
            });
          } else if (state is TourEditCreateOperationFailedState) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _showOperationSendFailedDialog(context, state);
              context.read<TourEditCubit>().clearMessages();
            });
          }

          if (state is TourEditShowAreaPhotosState) {
            return Scaffold(
              appBar: AppBar(
                title: Text(state.area.name),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    context.read<TourEditCubit>().closeAreaPhotos();
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
                  return InkWellWithPhoto(
                    fit: StackFit.expand,
                    onTap: () {
                      showGallery(
                        context,
                        urls: state.photoUrls,
                        initialIndex: index,
                      );
                    },
                    imageWidget: CachedNetworkImage(
                      imageUrl: state.photoUrls[index],
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
            );
          }

          return SceneList(
            tour: state.tour,
          );
        },
      ),
    );
  }

  void _showPhotosSendingFailedDialog(
      BuildContext context, TourEditUploadingFailedState state) {
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
                context.read<TourEditCubit>().addPhotosToArea(
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
      BuildContext context, TourEditCreateOperationFailedState state) {
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
                context.read<TourEditCubit>().createOperation(
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
