import 'package:ccquarters/login_register/cubit.dart';
import 'package:ccquarters/model/user.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:side_navigation/side_navigation.dart';

enum NavigationItemVisibility {
  always,
  whenSignedIn,
  whenSignedOut,
}

class NavigationItem {
  final String path;
  final String label;
  final IconData icon;
  final NavigationItemVisibility isVisible;
  final void Function(BuildContext context)? onTap;

  NavigationItem({
    required this.path,
    required this.label,
    required this.icon,
    this.isVisible = NavigationItemVisibility.always,
    this.onTap,
  });
}

class NavigationShell extends StatefulWidget {
  const NavigationShell({
    Key? key,
    required this.items,
    this.additionalItems = const [],
    required this.path,
    required this.child,
  }) : super(key: key);

  final List<NavigationItem> items;
  final List<NavigationItem> additionalItems;
  final String? path;
  final Widget child;

  @override
  State<NavigationShell> createState() => _NavigationShellState();
}

class _NavigationShellState extends State<NavigationShell> {
  late List<NavigationItem> _visibleItems;
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();

    context.read<AuthCubit>().stream.listen((state) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    _updateAllVisibleItems();

    return MediaQuery.of(context).orientation == Orientation.landscape
        ? _buildSideNavigationBar(context)
        : _buildBottomNavigationBar(context);
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    _updateAllVisibleItems();

    return Column(
      children: [
        Expanded(child: widget.child),
        SizedBox(
          height: 70,
          child: BottomNavigationBar(
            showSelectedLabels: false,
            showUnselectedLabels: false,
            selectedItemColor: Theme.of(context).primaryColor,
            type: BottomNavigationBarType.fixed,
            iconSize: 35,
            items: _visibleItems
                .map((i) =>
                    BottomNavigationBarItem(icon: Icon(i.icon), label: i.label))
                .toList(),
            currentIndex: _selectedIndex,
            onTap: (index) => _onItemTapped(context, index),
          ),
        ),
      ],
    );
  }

  Widget _buildSideNavigationBar(BuildContext context) {
    return Row(
      children: [
        SideNavigationBar(
          header: SideNavigationBarHeader(
            image: Image.asset(
              "assets/logo/logo.png",
              height: 32.5,
            ),
            title: const Text("CCQuarters"),
            subtitle: Container(),
          ),
          selectedIndex: _selectedIndex,
          items: _visibleItems
              .map((i) => SideNavigationBarItem(icon: i.icon, label: i.label))
              .toList(),
          theme: SideNavigationBarTheme(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            togglerTheme: SideNavigationBarTogglerTheme.standard(),
            itemTheme: SideNavigationBarItemTheme(
              unselectedItemColor: Colors.black,
              selectedItemColor: Theme.of(context).primaryColor,
              iconSize: 32.5,
            ),
            dividerTheme: SideNavigationBarDividerTheme.standard(),
          ),
          onTap: (index) => _onItemTapped(context, index),
        ),
        Expanded(child: widget.child),
      ],
    );
  }

  void _onItemTapped(BuildContext context, int index) {
    _visibleItems[index].onTap?.call(context);
    context.go(_visibleItems[index].path);
  }

  void _updateAllVisibleItems() {
    var user = context.read<AuthCubit>().user;

    var allItems = <NavigationItem>[];

    for (var item in widget.items) {
      if (_isItemVisible(item, user)) {
        allItems.add(item);
      }
    }

    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      for (var item in widget.additionalItems) {
        if (_isItemVisible(item, user)) {
          allItems.add(item);
        }
      }
    }

    _visibleItems = allItems;
    _selectedIndex = _visibleItems.indexWhere((i) => i.path == widget.path);
  }

  bool _isItemVisible(NavigationItem item, User? user) {
    return item.isVisible == NavigationItemVisibility.always ||
        (item.isVisible == NavigationItemVisibility.whenSignedIn &&
            user != null) ||
        (item.isVisible == NavigationItemVisibility.whenSignedOut &&
            user == null);
  }
}
