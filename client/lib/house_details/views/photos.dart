import 'package:ccquarters/common_widgets/image.dart';
import 'package:ccquarters/utils/consts.dart';
import 'package:ccquarters/utils/device_type.dart';
import 'package:ccquarters/common_widgets/inkwell_with_photo.dart';
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
            getDeviceType(context) == DeviceType.web
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
      BuildContext context, BoxConstraints constraints, bool isMobile) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: isMobile
            ? MediaQuery.of(context).size.height * 0.1
            : MediaQuery.of(context).size.height * 0.5,
        maxWidth: isMobile ? constraints.maxWidth : constraints.maxWidth * 0.2,
      ),
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: Scrollbar(
          controller: _scrollController,
          thumbVisibility: true,
          scrollbarOrientation: isMobile
              ? ScrollbarOrientation.bottom
              : ScrollbarOrientation.left,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              isMobile ? 0 : paddingSizeForScrollBar,
              isMobile ? extraSmallPaddingSize : 0,
              isMobile ? 0 : smallPaddingSize,
              isMobile ? smallPaddingSizeForScrollBar : 0,
            ),
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
                        isMobile
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
                  isMobile: isMobile,
                );
              },
              itemCount: widget.photos.length,
              scrollDirection: isMobile ? Axis.horizontal : Axis.vertical,
            ),
          ),
        ),
      ),
    );
  }

  Container _buildMainPhoto(
      BuildContext context, BoxConstraints constraints, bool isMobile) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.5,
        maxWidth: constraints.maxWidth * (isMobile ? 1 : 0.8),
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
      required this.isFirst,
      required this.isMobile});

  final String photo;
  final Function() onTap;
  final bool isFirst;
  final bool isMobile;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: isMobile
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
