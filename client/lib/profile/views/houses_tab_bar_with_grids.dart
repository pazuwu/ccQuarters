import 'package:ccquarters/model/house/house.dart';
import 'package:ccquarters/profile/cubit.dart';
import 'package:ccquarters/profile/views/photos_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class HousesTabBarViewWithGrids extends StatelessWidget {
  const HousesTabBarViewWithGrids({
    super.key,
    required this.tabController,
    required this.pagingControllerForMyHouses,
    required this.pagingControllerForLikedHouses,
  });

  final TabController? tabController;
  final PagingController<int, House> pagingControllerForMyHouses;
  final PagingController<int, House> pagingControllerForLikedHouses;

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: tabController,
      children: [
        PhotosGrid(
          getHouses: (pageNumber, pageCount) async => await context
              .read<ProfilePageCubit>()
              .getMyHouses(pageNumber, pageCount),
          pagingController: pagingControllerForMyHouses,
        ),
        PhotosGrid(
          getHouses: (pageNumber, pageCount) async => await context
              .read<ProfilePageCubit>()
              .getLikedHouses(pageNumber, pageCount),
          pagingController: pagingControllerForLikedHouses,
        ),
      ],
    );
  }
}

class HousesAndLikedHousesTabBar extends StatelessWidget {
  const HousesAndLikedHousesTabBar({super.key, required this.tabController});

  final TabController? tabController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TabBar(
        controller: tabController,
        labelColor: Theme.of(context).colorScheme.primary,
        unselectedLabelColor: Colors.grey[700],
        tabs: const [
          Tab(
            text: 'Wystawione',
          ),
          Tab(
            text: 'Obserwowane',
          ),
        ],
      ),
    );
  }
}
