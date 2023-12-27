import 'package:ccquarters/common/messages/error_message.dart';
import 'package:ccquarters/common/images/image.dart';
import 'package:ccquarters/common/images/inkwell_with_photo.dart';
import 'package:ccquarters/common/messages/message.dart';
import 'package:ccquarters/house_details/gate.dart';
import 'package:ccquarters/model/house.dart';
import 'package:flutter/material.dart';
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
        noItemsFoundIndicatorBuilder: (context) => const Message(
          title: "W tej zakładce nie masz\n jeszcze żadnych ogłoszeń",
          icon: Icons.home,
          adjustToLandscape: true,
          padding: EdgeInsets.all(8.0),
        ),
        firstPageErrorIndicatorBuilder: (context) => const ErrorMessage(
          "Nie udało się pobrać ogłoszeń",
          tip: "Sprawdź połączenie z internetem i spróbuj ponownie",
        ),
        newPageErrorIndicatorBuilder: (context) => const ErrorMessage(
          "Nie udało się pobrać ogłoszeń",
          tip: "Sprawdź połączenie z internetem i spróbuj ponownie",
        ),
        itemBuilder: (context, house, index) => Padding(
          padding: const EdgeInsets.all(1.5),
          child: InkWellWithPhoto(
            imageWidget: ImageWidget(
              imageUrl: house.photo.url,
              borderRadius: const BorderRadius.all(Radius.zero),
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => HouseDetailsGate(
                    houseId: house.id,
                  ),
                ),
              );
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
