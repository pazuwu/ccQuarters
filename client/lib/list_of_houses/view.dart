import 'package:ccquarters/list_of_houses/cubit.dart';
import 'package:ccquarters/list_of_houses/filters/filters.dart';
import 'package:ccquarters/list_of_houses/item.dart';
import 'package:ccquarters/model/filter.dart';
import 'package:ccquarters/model/house.dart';
import 'package:ccquarters/utils/consts.dart';
import 'package:ccquarters/utils/device_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ListOfHouses extends StatefulWidget {
  const ListOfHouses({super.key});

  @override
  State<ListOfHouses> createState() => _ListOfHousesState();
}

class _ListOfHousesState extends State<ListOfHouses> {
  final PagingController<int, House> _pagingController =
      PagingController(firstPageKey: 0);
  final _numberOfPostsPerRequest = 10;

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      List<House> houses = await context
          .read<ListOfHousesCubit>()
          .getHouses(pageKey, _numberOfPostsPerRequest);
      final isLastPage = houses.length < _numberOfPostsPerRequest;
      if (isLastPage) {
        _pagingController.appendLastPage(houses);
      } else {
        var nextPageKey = pageKey + 1;
        _pagingController.appendPage(houses, nextPageKey);
      }
    } catch (e) {
      _pagingController.error = e;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _pagingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => _pagingController.refresh(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (getDeviceType(context) == DeviceType.web)
            Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.25,
              ),
              child: FilterForm(
                filters: context.read<ListOfHousesCubit>().filter,
                onSave: (HouseFilter filter) {
                  context.read<ListOfHousesCubit>().saveFilter(filter);
                  _pagingController.refresh();
                },
              ),
            ),
          Container(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width *
                    (getDeviceType(context) == DeviceType.web ? 0.5 : 1)),
            child: Padding(
              padding: const EdgeInsets.only(
                left: largePaddingSize,
                right: largePaddingSize,
              ),
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: SizedBox(
                      child: Filters(
                        filters: context.read<ListOfHousesCubit>().filter,
                        onSave: (HouseFilter filter) {
                          context.read<ListOfHousesCubit>().saveFilter(filter);
                          _pagingController.refresh();
                        },
                      ),
                    ),
                  ),
                  SliverFillRemaining(
                    child: PagedListView<int, House>(
                      pagingController: _pagingController,
                      builderDelegate: PagedChildBuilderDelegate<House>(
                        itemBuilder: (context, item, index) => LayoutBuilder(
                          builder: (context, constraints) => HouseListTile(
                            house: item,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
