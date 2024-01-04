import 'package:ccquarters/common/messages/error_message.dart';
import 'package:ccquarters/common/messages/message.dart';
import 'package:ccquarters/list_of_houses/cubit.dart';
import 'package:ccquarters/filters/filters.dart';
import 'package:ccquarters/list_of_houses/model/filter_query.dart';
import 'package:ccquarters/list_of_houses/views/item.dart';
import 'package:ccquarters/main_page/search/search_box.dart';
import 'package:ccquarters/model/house/filter.dart';
import 'package:ccquarters/model/house/house.dart';
import 'package:ccquarters/common/consts.dart';
import 'package:ccquarters/model/house/offer_type.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
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
  late bool _isSearch;

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    _isSearch = widget.isSearch;
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
    return BackButtonListener(
      onBackButtonPressed: () async {
        _goBack();
        return true;
      },
      child: RefreshIndicator(
        onRefresh: () async => _pagingController.refresh(),
        child: LayoutBuilder(
          builder: (context, constraints) => Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (constraints.maxWidth > constraints.maxHeight &&
                  MediaQuery.of(context).orientation == Orientation.landscape)
                _buildFiltersColumn(context),
              Expanded(
                child: _buildList(
                    context,
                    constraints.maxWidth > constraints.maxHeight
                        ? Orientation.landscape
                        : Orientation.portrait),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _updateUrl(BuildContext context) {
    var filter = context.read<ListOfHousesCubit>().filter;
    var query = HouseFilterQuery.fromHouseFilter(filter).toMap();
    context.go(Uri(path: '/houses', queryParameters: query).toString());
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
          _updateUrl(context);
          _pagingController.refresh();
        },
      ),
    );
  }

  Widget _buildList(BuildContext context, Orientation orientation) {
    return Column(
      children: [
        _buildAppBarSliver(context),
        _buildFiltersSliver(context, orientation == Orientation.landscape),
        Expanded(
          child: _buildListSliver(),
        ),
      ],
    );
  }

  Widget _buildAppBarSliver(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 16,
        ),
        Row(
          children: [
            if (!kIsWeb) _buildBackButton(context),
            _buildAppBarMainWidget(context),
            if (!_isSearch) _buildSearchButton(),
          ],
        ),
      ],
    );
  }

  IconButton _buildBackButton(BuildContext context) {
    return IconButton(
      onPressed: _goBack,
      icon: const Icon(Icons.arrow_back),
    );
  }

  _goBack() {
    if (widget.isSearch) {
      context.go('/home');
    } else {
      if (_isSearch) {
        setState(() {
          if (_controller.text.isNotEmpty) {
            context.read<ListOfHousesCubit>().saveSearch("");
            _controller.clear();
            _pagingController.refresh();
          }
          _isSearch = false;
        });
      } else {
        context.go('/home');
      }
    }
  }

  Expanded _buildAppBarMainWidget(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 6.0,
        ),
        child: _isSearch
            ? SearchBox(
                color: Theme.of(context).colorScheme,
                controller: _controller,
                onSubmitted: (value) {
                  context.read<ListOfHousesCubit>().saveSearch(value);
                  _updateUrl(context);
                  _pagingController.refresh();
                },
              )
            : Row(
                children: [
                  Text(
                    _getTitle(),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
      ),
    );
  }

  IconButton _buildSearchButton() {
    return IconButton(
      onPressed: () {
        setState(() {
          _isSearch = true;
        });
      },
      icon: const Icon(Icons.search),
    );
  }

  Widget _buildFiltersSliver(BuildContext context, bool onlySort) {
    return Padding(
      padding: const EdgeInsets.only(
        left: largePaddingSize,
        right: largePaddingSize,
      ),
      child: SizedBox(
        child: Filters(
          onlySort: onlySort,
          filters: context.read<ListOfHousesCubit>().filter,
          onSave: (HouseFilter filter) {
            setState(() {
              context.read<ListOfHousesCubit>().saveFilter(filter);
              _updateUrl(context);
            });
            _pagingController.refresh();
          },
        ),
      ),
    );
  }

  Widget _buildListSliver() {
    return Padding(
      padding: const EdgeInsets.only(
        left: largePaddingSize,
        right: largePaddingSize,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) => PagedGridView<int, House>(
          pagingController: _pagingController,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 1.2,
            mainAxisSpacing: 16.0,
            crossAxisSpacing: 16.0,
            crossAxisCount:
                constraints.maxHeight > constraints.maxWidth ? 1 : 2,
          ),
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
            itemBuilder: (context, item, index) => HouseListTile(
              house: item,
            ),
          ),
        ),
      ),
    );
  }

  String _getTitle() {
    var title = "Ogłoszenia";
    var offerType = context.read<ListOfHousesCubit>().filter.offerType;

    if (offerType != null) {
      switch (offerType) {
        case OfferType.rent:
          title += " na wynajem";
          break;
        case OfferType.sell:
          title += " na sprzedaż";
          break;
      }
    }

    return title;
  }
}
