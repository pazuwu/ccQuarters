import 'package:ccquarters/list_of_houses/filter_query.dart';
import 'package:ccquarters/main_page/announcements/item.dart';
import 'package:ccquarters/model/house.dart';
import 'package:ccquarters/common/consts.dart';
import 'package:ccquarters/model/offer_type.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'list.dart';

class AnnouncementsContainer extends StatelessWidget {
  AnnouncementsContainer({
    super.key,
    required this.title,
    required this.pagingController,
    required this.getHouses,
    required this.offerType,
  });

  final String title;
  final ScrollController _scrollController = ScrollController();
  final PagingController<int, House> pagingController;
  final Future<List<House>?> Function(int, int) getHouses;
  final OfferType offerType;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ListLabel(
            title: title,
            offerType: offerType,
          ),
          Expanded(
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 8.0),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      _scrollController.animateTo(
                        _scrollController.offset -
                            HouseItem.getMaxItemWidth(context),
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.decelerate,
                      );
                    },
                    visualDensity: VisualDensity.compact,
                    constraints:
                        const BoxConstraints(minHeight: double.infinity),
                    icon: Icon(
                      Icons.arrow_left_rounded,
                      size: HouseItem.getMaxItemWidth(context) * 0.1,
                    ),
                  ),
                ),
                Expanded(
                  child: AnnouncementList(
                    scrollController: _scrollController,
                    pagingController: pagingController,
                    getHouses: getHouses,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 8.0),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      _scrollController.animateTo(
                        _scrollController.offset +
                            HouseItem.getMaxItemWidth(context),
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.decelerate,
                      );
                    },
                    constraints:
                        const BoxConstraints(minHeight: double.infinity),
                    icon: Icon(
                      Icons.arrow_right_rounded,
                      size: HouseItem.getMaxItemWidth(context) * 0.1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ListLabel extends StatelessWidget {
  const ListLabel({
    super.key,
    required this.title,
    required this.offerType,
  });

  final String title;
  final OfferType offerType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 1.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(8.0),
        onTap: () {
          context.go(Uri(
                  path: '/houses',
                  queryParameters:
                      HouseFilterQuery(offerType: offerType).toMap())
              .toString());
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 1.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const Icon(Icons.arrow_forward),
            ],
          ),
        ),
      ),
    );
  }
}
