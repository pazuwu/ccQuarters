import 'package:ccquarters/house_details/views/view.dart';
import 'package:ccquarters/login_register/cubit.dart';
import 'package:ccquarters/model/house.dart';
import 'package:ccquarters/model/user.dart';
import 'package:ccquarters/utils/consts.dart';
import 'package:ccquarters/common_widgets/image.dart';
import 'package:ccquarters/common_widgets/inkwell_with_photo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Profile extends StatefulWidget {
  const Profile({super.key, required this.user});

  final User user;

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  TabController? _tabController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: const ProfileDrawer(),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width *
                (MediaQuery.of(context).orientation == Orientation.landscape
                    ? 0.5
                    : 1),
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProfileInfo(user: widget.user),
                  _buildButtons(context),
                ],
              ),
              HousesAndLikedHousesTabBar(
                tabController: _tabController,
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    PhotosGrid(),
                    PhotosGrid(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Row(
      children: [
        if (MediaQuery.of(context).orientation == Orientation.portrait)
          IconButton(
              onPressed: () => _scaffoldKey.currentState!.openEndDrawer(),
              icon: const Icon(Icons.menu_rounded)),
        if (MediaQuery.of(context).orientation == Orientation.landscape)
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.edit),
            tooltip: "Edytuj profil",
          ),
        if (MediaQuery.of(context).orientation == Orientation.landscape)
          IconButton(
            onPressed: () {
              context.read<AuthCubit>().signOut();
            },
            icon: const Icon(Icons.logout),
            tooltip: "Wyloguj się",
          ),
      ],
    );
  }
}

class ProfileDrawer extends StatelessWidget {
  const ProfileDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          ListTile(
            title: const Text('CCQuarters'),
            titleTextStyle: const TextStyle(
                fontSize: 24, color: Colors.white, fontWeight: FontWeight.w500),
            tileColor: Theme.of(context).primaryColor,
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Edytuj profil'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: Text(context.read<AuthCubit>().user == null
                ? "Zaloguj się lub zarejestruj"
                : 'Wyloguj się'),
            onTap: () {
              context.read<AuthCubit>().signOut();
            },
          ),
        ],
      ),
    );
  }
}

class ProfileInfo extends StatelessWidget {
  const ProfileInfo({super.key, required this.user});

  final User user;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: paddingSize),
        child: Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            TableRow(
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    return SizedBox(
                      height: constraints.maxWidth * 0.8,
                      child: Padding(
                        padding: const EdgeInsets.all(largePaddingSize),
                        child: user.photoUrl != null
                            ? ImageWidget(
                                imageUrl: user.photoUrl!,
                                shape: BoxShape.circle,
                              )
                            : const Icon(Icons.person),
                      ),
                    );
                  },
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (user.name != null && user.surname != null)
                      Text(
                        "${user.name!} ${user.surname!}",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    if (user.company != null)
                      Text(
                        user.company!,
                        style: user.name != null && user.surname != null
                            ? TextStyle(
                                color: Colors.grey[800],
                                fontSize: 18,
                                fontWeight: FontWeight.w600)
                            : Theme.of(context).textTheme.headlineSmall,
                      ),
                    Text(
                      "Jesteś z nami od ${_getTimeSinceRegistration(user)}!",
                      textScaler: const TextScaler.linear(1.2),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getTimeSinceRegistration(User user) {
    var daysSinceRegistration =
        DateTime.now().difference(user.registrationDate).inDays;

    if (daysSinceRegistration == 0) {
      return "dzisiaj";
    } else if (daysSinceRegistration == 1) {
      return "wczoraj";
    } else if (daysSinceRegistration < 30) {
      return "$daysSinceRegistration dni";
    } else if (daysSinceRegistration < 60) {
      return "miesiąca";
    } else if (daysSinceRegistration < 365) {
      return "${(daysSinceRegistration / 30).floor()} miesięcy";
    } else {
      return "${(daysSinceRegistration / 365).floor()} lat";
    }
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

class PhotosGrid extends StatelessWidget {
  PhotosGrid({super.key});

  final houses = [
    House(Location(), HouseDetails(), User(), []),
    House(Location(), HouseDetails(), User(), []),
    House(Location(), HouseDetails(), User(), []),
    House(Location(), HouseDetails(), User(), []),
    House(Location(), HouseDetails(), User(), []),
    House(Location(), HouseDetails(), User(), []),
    House(Location(), HouseDetails(), User(), []),
    House(Location(), HouseDetails(), User(), []),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: houses.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.all(1.5),
        child: InkWellWithPhoto(
          imageWidget: ImageWidget(
              imageUrl: houses[index].photos.first,
              borderRadius: const BorderRadius.all(Radius.zero)),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DetailsView(
                  house: House(Location(), HouseDetails(), User(), []),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
