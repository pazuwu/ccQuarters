import 'package:ccquarters/utils/consts.dart';
import 'package:ccquarters/utils/inkwell_with_photo.dart';
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
      padding: const EdgeInsets.all(paddingSize),
      child: LayoutBuilder(
        builder: (context, constraints) => Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPhotoList(context, constraints),
            _buildMainPhoto(context, constraints),
          ],
        ),
      ),
    );
  }

  Container _buildPhotoList(BuildContext context, BoxConstraints constraints) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.5,
        maxWidth: constraints.maxWidth * 0.2,
      ),
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: Scrollbar(
          thumbVisibility: true,
          scrollbarOrientation: ScrollbarOrientation.left,
          child: Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: ListView.builder(
              controller: _scrollController,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return PhotoTile(
                  photo: widget.photos[index],
                  onTap: () {
                    setState(() {
                      _selectedIndex = index;
                    });
                    _scrollController.animateTo(
                        index *
                            (constraints.maxWidth * 0.2 -
                                12.0 +
                                smallPaddingSize),
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.ease);
                  },
                  isLast: index == widget.photos.length - 1,
                );
              },
              itemCount: widget.photos.length,
              scrollDirection: Axis.vertical,
            ),
          ),
        ),
      ),
    );
  }

  Container _buildMainPhoto(BuildContext context, BoxConstraints constraints) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.5,
        maxWidth: constraints.maxWidth * 0.8,
      ),
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(widget.photos[_selectedIndex]),
        ),
      ),
      child: MainPhoto(
        onTap: () {},
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
      required this.isLast});

  final String photo;
  final Function() onTap;
  final bool isLast;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          0, 0, smallPaddingSize, isLast ? 0 : smallPaddingSize),
      child: InkWellWithPhoto(
        onTap: onTap,
        imageWidget: AspectRatio(
          aspectRatio: 1,
          child: Image.network(
            photo,
            fit: BoxFit.cover,
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
      imageWidget: Image.network(
        photo,
        fit: BoxFit.cover,
      ),
      fit: StackFit.expand,
    );
  }
}
