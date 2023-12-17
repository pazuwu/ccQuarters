import 'package:ccquarters/main_page/cubit.dart';
import 'package:ccquarters/model/house.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: constraints.maxHeight,
            child: Column(
              children: [
                const SizedBox(
                  height: 16,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: FakeSearchBox(
                    color: color,
                    onTap: () => context.read<MainPageCubit>().search(),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Expanded(
                  child: AnnouncementsContainer(
                    title: "Do wynajęcia",
                    pagingController: _pagingControllerForHousesToRent,
                    getHouses: (pageNumber, pageCount) async => await context
                        .read<MainPageCubit>()
                        .getHousesToRent(pageNumber, pageCount),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Expanded(
                  child: AnnouncementsContainer(
                    title: "Do kupienia",
                    pagingController: _pagingControllerForHousesToBuy,
                    getHouses: (pageNumber, pageCount) async => await context
                        .read<MainPageCubit>()
                        .getHousesToBuy(pageNumber, pageCount),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
              ],
            ),
          ),
        );
      },
    ));
  }
}
