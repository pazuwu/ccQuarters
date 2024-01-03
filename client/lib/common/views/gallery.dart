import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view_gallery.dart';

class GalleryParameters {
  final List<String> imageUrls;
  final List<Uint8List> memoryPhotos;
  final int initialIndex;

  GalleryParameters({
    this.imageUrls = const [],
    this.memoryPhotos = const [],
    required this.initialIndex,
  });
}

class Gallery extends StatefulWidget {
  const Gallery({
    Key? key,
    this.imageUrls = const [],
    this.memoryPhotos = const [],
    required this.initialIndex,
  }) : super(key: key);

  final List<String> imageUrls;
  final List<Uint8List> memoryPhotos;
  final int initialIndex;

  @override
  State<Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();

    RawKeyboard.instance.addListener(_keyboardCallback);
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          color: Colors.white,
          icon: const Icon(Icons.arrow_back_outlined),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.transparent,
      ),
      body: BackButtonListener(
        onBackButtonPressed: () async {
          Navigator.of(context).pop();
          return true;
        },
        child: IconButtonTheme(
          data: const IconButtonThemeData(
              style: ButtonStyle(
            iconColor: MaterialStatePropertyAll(Colors.white),
            iconSize: MaterialStatePropertyAll(32),
            visualDensity: VisualDensity.compact,
          )),
          child: Stack(
            children: [
              PhotoViewGallery.builder(
                scrollPhysics: const ClampingScrollPhysics(),
                pageController: _pageController,
                builder: (BuildContext context, int index) {
                  return index >= widget.memoryPhotos.length
                      ? PhotoViewGalleryPageOptions(
                          imageProvider: CachedNetworkImageProvider(
                              widget.imageUrls[index]),
                        )
                      : PhotoViewGalleryPageOptions(
                          imageProvider:
                              MemoryImage(widget.memoryPhotos[index]),
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
              if (kIsWeb)
                Positioned.fill(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(width: 12),
                      Container(
                        decoration: const BoxDecoration(boxShadow: [
                          BoxShadow(
                            color: Colors.black54,
                            blurRadius: 48,
                          ),
                        ]),
                        child: IconButton(
                          onPressed: () {
                            _pageController.previousPage(
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeInOut,
                            );
                          },
                          icon: const Icon(Icons.arrow_left),
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          _pageController.nextPage(
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeInOut);
                        },
                        icon: const Icon(Icons.arrow_right),
                      ),
                      const SizedBox(width: 12),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _keyboardCallback(RawKeyEvent value) {
    if (value.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
    } else if (value.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
    }
  }
}
