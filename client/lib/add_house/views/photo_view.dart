import 'package:ccquarters/add_house/cubit.dart';
import 'package:ccquarters/common/images/image.dart';
import 'package:ccquarters/model/houses/photo.dart';
import 'package:ccquarters/common/images/inkwell_with_photo.dart';
import 'package:ccquarters/common/views/view_with_buttons.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PhotoView extends StatefulWidget {
  const PhotoView(
      {super.key,
      required this.oldPhotos,
      required this.newPhotos,
      required this.deletedPhotos,
      required this.editMode});

  final List<Photo> oldPhotos;
  final List<Uint8List> newPhotos;
  final List<Photo> deletedPhotos;
  final bool editMode;

  @override
  State<PhotoView> createState() => _PhotoViewState();
}

class _PhotoViewState extends State<PhotoView> {
  int? _selectedIndex;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = null;
        });
      },
      child: ViewWithButtons(
        inBetweenWidget: _buildPageContent(context),
        goBackOnPressed: () {
          context.read<AddHouseFormCubit>().savePhotos(
              widget.newPhotos, widget.oldPhotos, widget.deletedPhotos);
          if (MediaQuery.of(context).orientation == Orientation.landscape) {
            context.read<AddHouseFormCubit>().goToLocationForm();
          } else {
            context.read<AddHouseFormCubit>().goToMap();
          }
        },
        nextOnPressed: () {
          context.read<AddHouseFormCubit>().savePhotos(
              widget.newPhotos, widget.oldPhotos, widget.deletedPhotos);
          context.read<AddHouseFormCubit>().goToVirtualTourForm();
        },
        hasScrollBody: true,
        isLastPage: false,
      ),
    );
  }

  Widget _buildPageContent(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          _buildPhotosGrid(context),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildPhotosGrid(BuildContext context) {
    var photosCount = widget.oldPhotos.length + widget.newPhotos.length;
    return Expanded(
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount:
              MediaQuery.of(context).orientation == Orientation.portrait
                  ? 3
                  : 4,
        ),
        itemCount: photosCount + 1,
        itemBuilder: (context, index) {
          if (index < widget.oldPhotos.length) {
            return _buildPhotoGridTileForOldPhotos(index);
          } else if (index == photosCount) {
            return _buildAddGridTile(context);
          } else {
            return _buildPhotoGridTile(index);
          }
        },
      ),
    );
  }

  GridTile _buildAddGridTile(BuildContext context) {
    return GridTile(
      onTap: () async {
        var images = await _getFromGallery();
        if (images.isNotEmpty) {
          var imagesInBytes = <Uint8List>[];
          for (var image in images) {
            if (image.bytes != null) imagesInBytes.add(image.bytes!);
          }
          setState(() => widget.newPhotos.addAll(imagesInBytes));
        }
      },
      child: Icon(
        Icons.add_a_photo_outlined,
        size: MediaQuery.of(context).orientation == Orientation.portrait
            ? 56
            : 96,
      ),
    );
  }

  GridTile _buildPhotoGridTileForOldPhotos(int index) {
    return GridTile(
      onTap: () async {
        if (index == _selectedIndex) {
          setState(() {
            _selectedIndex = null;
            widget.deletedPhotos.add(widget.oldPhotos.removeAt(index));
          });
        } else {
          setState(() {
            _selectedIndex = index;
          });
        }
      },
      canBeRemoved: index == _selectedIndex,
      child: AspectRatio(
        aspectRatio: 1,
        child: ImageWidget(
          imageUrl: widget.oldPhotos[index].url,
          fit: BoxFit.cover,
          borderRadius: BorderRadius.zero,
        ),
      ),
    );
  }

  GridTile _buildPhotoGridTile(int index) {
    return GridTile(
      onTap: () async {
        if (index == _selectedIndex) {
          setState(() {
            _selectedIndex = null;
            widget.newPhotos.removeAt(index - widget.oldPhotos.length);
          });
        } else {
          setState(() {
            _selectedIndex = index;
          });
        }
      },
      canBeRemoved: index == _selectedIndex,
      child: AspectRatio(
        aspectRatio: 1,
        child: Image.memory(
          widget.newPhotos[index - widget.oldPhotos.length],
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Future<List<PlatformFile>> _getFromGallery() async {
    var res = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'jpeg'],
      withData: true,
      allowCompression: true,
    );

    return res?.files ?? [];
  }
}

class GridTile extends StatelessWidget {
  const GridTile({
    super.key,
    required this.onTap,
    required this.child,
    this.canBeRemoved,
  });

  final Function() onTap;
  final Widget child;
  final bool? canBeRemoved;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Card(
          shape: const BeveledRectangleBorder(),
          borderOnForeground: true,
          elevation: 0,
          color: Colors.grey.shade100,
          clipBehavior: Clip.antiAlias,
          child: InkWellWithPhoto(
            onTap: onTap,
            imageWidget: Center(child: child),
            inkWellChild: canBeRemoved ?? false
                ? Center(
                    child: Container(
                      width: constraints.maxWidth,
                      height: constraints.maxHeight,
                      color: Colors.grey.withOpacity(0.2),
                      child: Icon(
                        Icons.delete,
                        size: MediaQuery.of(context).orientation ==
                                Orientation.portrait
                            ? 64
                            : 96,
                      ),
                    ),
                  )
                : null,
          ),
        );
      },
    );
  }
}
