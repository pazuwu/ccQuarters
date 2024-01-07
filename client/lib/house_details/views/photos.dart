import 'package:ccquarters/common/images/image.dart';
import 'package:ccquarters/common/consts.dart';
import 'package:ccquarters/common/images/inkwell_with_photo.dart';
import 'package:ccquarters/common/views/show_gallery.dart';
import 'package:flutter/material.dart';

class Photos extends StatefulWidget {
  const Photos({super.key, required this.photos});

  final List<String> photos;
  @override
  State<Photos> createState() => _PhotosState();
}

class _PhotosState extends State<Photos> {
  final _scrollController = ScrollController();
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(largePaddingSize),
      child: LayoutBuilder(
        builder: (context, constraints) =>
            MediaQuery.of(context).orientation == Orientation.landscape
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPhotoList(context, constraints, false),
                      _buildMainPhoto(context, constraints, false),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildMainPhoto(context, constraints, true),
                      _buildPhotoList(context, constraints, true),
                    ],
                  ),
      ),
    );
  }

  Container _buildPhotoList(
      BuildContext context, BoxConstraints constraints, bool isPortrait) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: isPortrait
            ? MediaQuery.of(context).size.height * 0.1
            : MediaQuery.of(context).size.height * 0.5,
        maxWidth:
            isPortrait ? constraints.maxWidth : constraints.maxWidth * 0.2,
      ),
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: Scrollbar(
          controller: _scrollController,
          thumbVisibility: true,
          scrollbarOrientation: isPortrait
              ? ScrollbarOrientation.bottom
              : ScrollbarOrientation.left,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              isPortrait ? 0 : paddingSizeForScrollBar,
              isPortrait ? extraSmallPaddingSize : 0,
              isPortrait ? 0 : smallPaddingSize,
              isPortrait ? smallPaddingSizeForScrollBar : 0,
            ),
            child: SingleChildScrollView(
              controller: _scrollController,
              scrollDirection: isPortrait ? Axis.horizontal : Axis.vertical,
              child: Flex(
                mainAxisSize: MainAxisSize.min,
                direction: isPortrait ? Axis.horizontal : Axis.vertical,
                children: [
                  for (int index = 0; index < widget.photos.length; index++)
                    _buildPhotoTile(index, isPortrait, context, constraints)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  PhotoTile _buildPhotoTile(int index, bool isPortrait, BuildContext context,
      BoxConstraints constraints) {
    return PhotoTile(
      photo: widget.photos[index],
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
        _scrollController.animateTo(
            isPortrait
                ? index *
                    (MediaQuery.of(context).size.height * 0.1 -
                        smallPaddingSizeForScrollBar +
                        extraSmallPaddingSize)
                : index *
                    (constraints.maxWidth * 0.2 -
                        paddingSizeForScrollBar +
                        smallPaddingSize),
            duration: const Duration(milliseconds: 400),
            curve: Curves.ease);
      },
      isFirst: index == 0,
      isPortrait: isPortrait,
    );
  }

  Container _buildMainPhoto(
      BuildContext context, BoxConstraints constraints, bool isPortrait) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.5,
        maxWidth: constraints.maxWidth * (isPortrait ? 1 : 0.8),
      ),
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(widget.photos[_selectedIndex]),
        ),
      ),
      child: MainPhoto(
        onTap: () {
          showGallery(
            context,
            urls: widget.photos,
            initialIndex: _selectedIndex,
          );
        },
        photo: widget.photos[_selectedIndex],
      ),
    );
  }
}

class PhotoTile extends StatelessWidget {
  const PhotoTile(
      {super.key,
      required this.photo,
      required this.onTap,
      required this.isFirst,
      required this.isPortrait});

  final String photo;
  final Function() onTap;
  final bool isFirst;
  final bool isPortrait;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: isPortrait
          ? EdgeInsets.only(left: isFirst ? 0 : extraSmallPaddingSize)
          : EdgeInsets.only(top: isFirst ? 0 : smallPaddingSize),
      child: InkWellWithPhoto(
        onTap: onTap,
        imageWidget: AspectRatio(
          aspectRatio: 1,
          child: ImageWidget(
            imageUrl: photo,
            fit: BoxFit.cover,
            borderRadius: BorderRadius.zero,
          ),
        ),
      ),
    );
  }
}

class MainPhoto extends StatelessWidget {
  const MainPhoto({super.key, required this.photo, required this.onTap});

  final String photo;
  final Function() onTap;
  @override
  Widget build(BuildContext context) {
    return InkWellWithPhoto(
      onTap: onTap,
      imageWidget: ImageWidget(
        imageUrl: photo,
        fit: BoxFit.cover,
        borderRadius: BorderRadius.zero,
      ),
      fit: StackFit.expand,
    );
  }
}
