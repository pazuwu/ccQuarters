import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'package:ccquarters/common/consts.dart';
import 'package:ccquarters/common/images/image.dart';

class Gallery extends StatefulWidget {
  const Gallery({
    Key? key,
    this.imageUrls = const [],
    this.memoryPhotos = const [],
    required this.width,
    required this.initialIndex,
  }) : super(key: key);

  final List<String> imageUrls;
  final List<Uint8List> memoryPhotos;
  final double width;
  final int initialIndex;

  @override
  State<Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  static const double _photoTileHeight = 100;
  static const double _photoTileWidth = 100;
  final ItemScrollController _itemScrollController = ItemScrollController();
  late PageController _pageController = PageController();
  late int lastPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);

    _pageController.addListener(() {
      if (_pageController.page == null) return;

      var roundedPage = _pageController.page!.round();

      if (_pageController.page != null) {
        _itemScrollController.scrollTo(
          alignment: 0.5,
          index: roundedPage,
          duration: const Duration(milliseconds: 200),
        );
      }

      lastPage = roundedPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          color: Colors.white,
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          PhotoViewGallery.builder(
            scrollPhysics: const BouncingScrollPhysics(),
            pageController: _pageController,
            builder: (BuildContext context, int index) {
              return index >= widget.memoryPhotos.length
                  ? PhotoViewGalleryPageOptions(
                      imageProvider:
                          CachedNetworkImageProvider(widget.imageUrls[index]),
                    )
                  : PhotoViewGalleryPageOptions(
                      imageProvider: MemoryImage(widget.memoryPhotos[index]),
                    );
            },
            itemCount: widget.memoryPhotos.length + widget.imageUrls.length,
            loadingBuilder: (context, event) => const Center(
              child: SizedBox(
                width: 20.0,
                height: 20.0,
                child: CircularProgressIndicator(),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: _buildPhotoList(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoList(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints.tightFor(height: _photoTileHeight),
      child: ScrollablePositionedList.builder(
        initialScrollIndex: widget.initialIndex,
        itemScrollController: _itemScrollController,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return _buildPhotoTile(context, index);
        },
        itemCount: widget.memoryPhotos.length + widget.imageUrls.length,
        scrollDirection: Axis.horizontal,
      ),
    );
  }

  Widget _buildPhotoTile(BuildContext context, int index) {
    return ConstrainedBox(
      constraints: const BoxConstraints.tightFor(width: _photoTileWidth),
      child: Padding(
        padding: EdgeInsets.only(left: index == 0 ? 0 : extraSmallPaddingSize),
        child: AspectRatio(
          aspectRatio: 1,
          child: index >= widget.memoryPhotos.length
              ? ImageWidget(
                  imageUrl: widget.imageUrls[index],
                  fit: BoxFit.cover,
                  borderRadius: BorderRadius.zero,
                )
              : Image.memory(widget.memoryPhotos[index]),
        ),
      ),
    );
  }
}
