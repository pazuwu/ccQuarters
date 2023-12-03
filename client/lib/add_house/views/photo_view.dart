import 'package:ccquarters/add_house/cubit.dart';
import 'package:ccquarters/common_widgets/icon_360.dart';
import 'package:ccquarters/utils/device_type.dart';
import 'package:ccquarters/common_widgets/inkwell_with_photo.dart';
import 'package:ccquarters/common_widgets/view_with_header_and_buttons.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PhotoView extends StatefulWidget {
  const PhotoView(
      {super.key, required this.photos, required this.createVirtualTour});

  final List<Uint8List> photos;
  final bool createVirtualTour;

  @override
  State<PhotoView> createState() => _PhotoViewState();
}

class _PhotoViewState extends State<PhotoView> {
  int? _selectedIndex;
  bool _virtualTourIsEnabled = true;

  @override
  void initState() {
    super.initState();
    _virtualTourIsEnabled = widget.createVirtualTour;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = null;
        });
      },
      child: ViewWithHeader(
        title: "Dodaj zdjęcia",
        inBetweenWidget: _buildPageContent(context),
        goBackOnPressed: () {
          context.read<AddHouseFormCubit>().savePhotos(widget.photos);
          if (getDeviceType(context) == DeviceType.web) {
            context.read<AddHouseFormCubit>().goToLocationForm();
          } else {
            context.read<AddHouseFormCubit>().goToMap();
          }
        },
        nextOnPressed: () {
          context.read<AddHouseFormCubit>().savePhotos(widget.photos);
          context.read<AddHouseFormCubit>().sendData();
        },
        hasScrollBody: true,
      ),
    );
  }

  Widget _buildPageContent(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          _buildPhotosGrid(context),
          const SizedBox(height: 16),
          _buildDivider(context),
          _buildVirtualTourSwitch(context),
          _buildDivider(context),
        ],
      ),
    );
  }

  Widget _buildVirtualTourSwitch(BuildContext context) {
    return ListTile(
      leading: Icon360(
        color: _virtualTourIsEnabled ? Colors.blueGrey : Colors.grey,
      ),
      title: Text(
        "Wirtualny spacer",
        style: TextStyle(
          color: _virtualTourIsEnabled ? Colors.black : Colors.grey,
        ),
      ),
      trailing: Switch(
        value: _virtualTourIsEnabled,
        onChanged: (value) {
          setState(() {
            context.read<AddHouseFormCubit>().saveCreateVirtualTour(value);
            _virtualTourIsEnabled = value;
          });
        },
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return const Divider(
      endIndent: 10,
      indent: 10,
      color: Colors.black,
      thickness: 1,
    );
  }

  Widget _buildPhotosGrid(BuildContext context) {
    return Expanded(
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount:
              getDeviceTypeForGrid(context) == DeviceType.mobile ? 3 : 4,
        ),
        itemCount: widget.photos.length + 1,
        itemBuilder: (context, index) {
          if (index == widget.photos.length) {
            return _buildAddGridTile(context);
          } else {
            return _buildPhotoGridTIle(index);
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
          setState(() => widget.photos.addAll(imagesInBytes));
        }
      },
      child: Icon(
        Icons.add_a_photo_outlined,
        size: getDeviceTypeForGrid(context) == DeviceType.mobile ? 64 : 96,
      ),
    );
  }

  GridTile _buildPhotoGridTIle(int index) {
    return GridTile(
      onTap: () async {
        if (index == _selectedIndex) {
          setState(() {
            _selectedIndex = null;
            widget.photos.removeAt(index);
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
        child: Image.memory(widget.photos[index], fit: BoxFit.cover),
      ),
    );
  }

  Future<List<PlatformFile>> _getFromGallery() async {
    var res = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'jpeg'],
      withData: true,
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
          shape: const RoundedRectangleBorder(),
          borderOnForeground: true,
          elevation: 0,
          color: Colors.grey.shade200,
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
                        size: getDeviceTypeForGrid(context) == DeviceType.mobile
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
