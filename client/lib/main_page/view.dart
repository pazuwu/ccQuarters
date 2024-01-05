import 'package:ccquarters/list_of_houses/model/houses_extra.dart';
import 'package:ccquarters/main_page/cubit.dart';
import 'package:ccquarters/model/house/house.dart';
import 'package:ccquarters/model/house/offer_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'announcements/container.dart';
import 'search/search_box.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final PagingController<int, House> _pagingControllerForHousesToRent =
      PagingController(firstPageKey: 0);
  final PagingController<int, House> _pagingControllerForHousesToBuy =
      PagingController(firstPageKey: 0);

  @override
  void dispose() {
    super.dispose();
    _pagingControllerForHousesToRent.dispose();
    _pagingControllerForHousesToBuy.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return RefreshIndicator(onRefresh: () async {
      _pagingControllerForHousesToRent.refresh();
      _pagingControllerForHousesToBuy.refresh();
    }, child: LayoutBuilder(
      builder: (context, constraints) {
        return BackButtonListener(
          onBackButtonPressed: () async {
            return !(await _buildDialogWithQuestionIfUserWantsToLeaveApp() ??
                false);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: SizedBox(
              height: constraints.maxHeight,
              child: Column(
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  _buildFakeSearchBox(color, context),
                  const SizedBox(
                    height: 16,
                  ),
                  _buildHousesToRent(context),
                  const SizedBox(
                    height: 16,
                  ),
                  _buildHousesToBuy(context),
                  const SizedBox(
                    height: 16,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ));
  }

  Future<bool?> _buildDialogWithQuestionIfUserWantsToLeaveApp() async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => BackButtonListener(
        onBackButtonPressed: () async {
          Navigator.of(context).pop(false);
          return true;
        },
        child: AlertDialog(
          title: const Text("Czy na pewno chcesz wyjść z aplikacji?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Nie"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text("Tak"),
            ),
          ],
        ),
      ),
    );
  }

  Padding _buildFakeSearchBox(ColorScheme color, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: FakeSearchBox(
        color: color,
        onTap: () => context.go(
          '/houses',
          extra: HousesExtra(isSearch: true),
        ),
      ),
    );
  }

  Expanded _buildHousesToRent(BuildContext context) {
    return Expanded(
      child: AnnouncementsContainer(
        title: "Do wynajęcia",
        pagingController: _pagingControllerForHousesToRent,
        getHouses: (pageNumber, pageCount) async => await context
            .read<MainPageCubit>()
            .getHousesToRent(pageNumber, pageCount),
        offerType: OfferType.rent,
      ),
    );
  }

  Expanded _buildHousesToBuy(BuildContext context) {
    return Expanded(
      child: AnnouncementsContainer(
        title: "Na sprzedaż",
        pagingController: _pagingControllerForHousesToBuy,
        getHouses: (pageNumber, pageCount) async => await context
            .read<MainPageCubit>()
            .getHousesToBuy(pageNumber, pageCount),
        offerType: OfferType.sell,
      ),
    );
  }
}
