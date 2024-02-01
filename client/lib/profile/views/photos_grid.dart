import 'dart:math';

import 'package:ccquarters/common/images/asset_image.dart';
import 'package:ccquarters/common/messages/error_message.dart';
import 'package:ccquarters/common/images/image.dart';
import 'package:ccquarters/common/images/inkwell_with_photo.dart';
import 'package:ccquarters/common/messages/message.dart';
import 'package:ccquarters/model/houses/house.dart';
import 'package:flutter/material.dart';
import 'package:ccquarters/navigation/history_navigator.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class PhotosGrid extends StatefulWidget {
  const PhotosGrid(
      {super.key, required this.getHouses, required this.pagingController});

  final Future<List<House>> Function(int, int) getHouses;
  final PagingController<int, House> pagingController;

  @override
  State<PhotosGrid> createState() => _PhotosGridState();
}

class _PhotosGridState extends State<PhotosGrid> {
  final _numberOfPostsPerRequest = 10;

  @override
  void initState() {
    widget.pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      List<House> houses =
          await widget.getHouses(pageKey, _numberOfPostsPerRequest);

      if (!mounted) {
        return;
      }

      final isLastPage = houses.length < _numberOfPostsPerRequest;
      if (isLastPage) {
        widget.pagingController.appendLastPage(houses);
      } else {
        var nextPageKey = pageKey + 1;
        widget.pagingController.appendPage(houses, nextPageKey);
      }
    } catch (e) {
      widget.pagingController.error = e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PagedGridView<int, House>(
      pagingController: widget.pagingController,
      builderDelegate: PagedChildBuilderDelegate<House>(
        noItemsFoundIndicatorBuilder: (context) => Message(
          title: "W tej zakładce nie masz\n jeszcze żadnych ogłoszeń",
          imageWidget: Icon(
            Icons.home,
            size: min(MediaQuery.of(context).size.height,
                    MediaQuery.of(context).size.width) *
                0.25,
            color: Theme.of(context).primaryColor,
          ),
          adjustToLandscape: true,
          padding: const EdgeInsets.all(8.0),
        ),
        firstPageErrorIndicatorBuilder: (context) => ErrorMessage(
          "Nie udało się pobrać ogłoszeń",
          tip: "Sprawdź połączenie z internetem i spróbuj ponownie",
        ),
        newPageErrorIndicatorBuilder: (context) => ErrorMessage(
          "Nie udało się pobrać ogłoszeń",
          tip: "Sprawdź połączenie z internetem i spróbuj ponownie",
        ),
        itemBuilder: (context, house, index) => Padding(
          padding: const EdgeInsets.all(1.5),
          child: InkWellWithPhoto(
            imageWidget: house.photoUrl != null
                ? ImageWidget(
                    imageUrl: house.photoUrl!,
                    borderRadius: const BorderRadius.all(Radius.zero),
                  )
                : AssetImageWidget(
                    imagePath: house.getFilenameDependOnBuildingType(),
                    fit: BoxFit.contain,
                    borderRadius: const BorderRadius.all(Radius.zero),
                  ),
            onTap: () {
              context.go('/houses/${house.id}');
            },
          ),
        ),
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1,
      ),
    );
  }
}
