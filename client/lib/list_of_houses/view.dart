import 'package:ccquarters/common/messages/error_message.dart';
import 'package:ccquarters/common/messages/message.dart';
import 'package:ccquarters/list_of_houses/cubit.dart';
import 'package:ccquarters/filters/filters.dart';
import 'package:ccquarters/list_of_houses/item.dart';
import 'package:ccquarters/main_page/cubit.dart';
import 'package:ccquarters/main_page/search/search_box.dart';
import 'package:ccquarters/model/filter.dart';
import 'package:ccquarters/model/house.dart';
import 'package:ccquarters/common/consts.dart';
import 'package:ccquarters/common/device_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ListOfHouses extends StatefulWidget {
  const ListOfHouses({super.key, required this.isSearch});

  final bool isSearch;
  @override
  State<ListOfHouses> createState() => _ListOfHousesState();
}

class _ListOfHousesState extends State<ListOfHouses> {
  final PagingController<int, House> _pagingController =
      PagingController(firstPageKey: 0);
  final _controller = TextEditingController();

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
      var houses = await context
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
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: () async => _pagingController.refresh(),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (getDeviceType(context) == DeviceType.web)
                _buildFiltersColumn(context),
              _buildList(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFiltersColumn(BuildContext context) {
    return Container(
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
    );
  }

  Widget _buildList(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width *
              (getDeviceType(context) == DeviceType.web ? 0.5 : 1)),
      child: CustomScrollView(
        slivers: [
          _buildAppBarSliver(context),
          _buildFiltersSliver(context),
          _buildListSliver(),
        ],
      ),
    );
  }

  SliverToBoxAdapter _buildAppBarSliver(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          const SizedBox(
            height: 16,
          ),
          Row(
            children: [
              IconButton(
                onPressed: () => widget.isSearch
                    ? context.read<MainPageCubit>().goBack()
                    : Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 6.0,
                  ),
                  child: widget.isSearch
                      ? SearchBox(
                          color: Theme.of(context).colorScheme,
                          controller: _controller,
                          onSubmitted: (value) {
                            context.read<ListOfHousesCubit>().saveSearch(value);
                            _pagingController.refresh();
                          },
                        )
                      : Text(
                          "Ogłoszenia na wynajem",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  SliverToBoxAdapter _buildFiltersSliver(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(
          left: largePaddingSize,
          right: largePaddingSize,
        ),
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
    );
  }

  SliverFillRemaining _buildListSliver() {
    return SliverFillRemaining(
      child: Padding(
        padding: const EdgeInsets.only(
          left: largePaddingSize,
          right: largePaddingSize,
        ),
        child: PagedListView<int, House>(
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<House>(
            noItemsFoundIndicatorBuilder: (context) => const Message(
              title: "Niestety nie znaleziono dla \nCiebie żadnych ogłoszeń",
              subtitle: "Spróbuj ponownie później",
              imageWidget: Icon(Icons.home),
              adjustToLandscape: true,
              padding: EdgeInsets.all(8.0),
            ),
            firstPageErrorIndicatorBuilder: (context) => ErrorMessage(
              "Nie udało się pobrać ogłoszeń",
              tip: "Sprawdź połączenie z internetem i spróbuj ponownie",
            ),
            newPageErrorIndicatorBuilder: (context) => ErrorMessage(
              "Nie udało się pobrać ogłoszeń",
              tip: "Sprawdź połączenie z internetem i spróbuj ponownie",
            ),
            itemBuilder: (context, item, index) => LayoutBuilder(
              builder: (context, constraints) => HouseListTile(
                house: item,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
