import 'package:ccquarters/login_register/cubit.dart';
import 'package:ccquarters/model/house/house.dart';
import 'package:ccquarters/model/user/user.dart';
import 'package:ccquarters/profile/cubit.dart';
import 'package:ccquarters/profile/views/houses_tab_bar_with_grids.dart';
import 'package:ccquarters/profile/views/profile_drawer.dart';
import 'package:ccquarters/profile/views/profile_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class Profile extends StatefulWidget {
  const Profile({
    super.key,
    required this.user,
  });

  final User user;

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  TabController? _tabController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final PagingController<int, House> _pagingControllerForMyHouses =
      PagingController(firstPageKey: 0);
  final PagingController<int, House> _pagingControllerForLikedHouses =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController?.dispose();
    _pagingControllerForMyHouses.dispose();
    _pagingControllerForLikedHouses.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: const ProfileDrawer(),
      body: RefreshIndicator(
        onRefresh: () async {
          _pagingControllerForLikedHouses.refresh();
          _pagingControllerForMyHouses.refresh();
        },
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width *
                  (MediaQuery.of(context).orientation == Orientation.landscape
                      ? 0.5
                      : 1),
            ),
            child: _buildScrollView(),
          ),
        ),
      ),
    );
  }

  CustomScrollView _buildScrollView() {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileInfo(user: widget.user),
              _buildButtons(context),
            ],
          ),
        ),
        SliverToBoxAdapter(
          child: HousesAndLikedHousesTabBar(
            tabController: _tabController,
          ),
        ),
        SliverFillRemaining(
          child: HousesTabBarViewWithGrids(
            pagingControllerForLikedHouses: _pagingControllerForLikedHouses,
            pagingControllerForMyHouses: _pagingControllerForMyHouses,
            tabController: _tabController,
          ),
        ),
      ],
    );
  }

  Widget _buildButtons(BuildContext context) {
    return (MediaQuery.of(context).orientation == Orientation.portrait)
        ? IconButton(
            onPressed: () => _scaffoldKey.currentState!.openEndDrawer(),
            icon: const Icon(Icons.menu_rounded),
          )
        : Row(
            children: [
              IconButton(
                onPressed: () {
                  context.read<ProfilePageCubit>().goToEditUserPage();
                },
                icon: const Icon(Icons.edit),
                tooltip: "Edytuj profil",
              ),
              IconButton(
                onPressed: () {
                  context.read<AuthCubit>().signOut();
                  context.go('/login');
                },
                icon: const Icon(Icons.logout),
                tooltip: "Wyloguj się",
              ),
            ],
          );
  }
}
