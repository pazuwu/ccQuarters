import 'package:ccquarters/login_register/cubit.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:side_navigation/side_navigation.dart';

class NavigationItem {
  final String path;
  final String label;
  final IconData icon;

  NavigationItem({
    required this.path,
    required this.label,
    required this.icon,
  });
}

class NavigationShell extends StatelessWidget {
  NavigationShell({
    Key? key,
    required this.items,
    this.additionalItems = const [],
    required this.path,
    required this.child,
  })  : _selectedIndex = _computeIndex(path, items, additionalItems),
        super(key: key);

  final List<NavigationItem> items;
  final List<NavigationItem> additionalItems;
  final String? path;
  final Widget child;
  final int _selectedIndex;

  @override
  Widget build(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape
        ? _buildSideNavigationBar(context)
        : _buildBottomNavigationBar(context);
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return Column(
      children: [
        Expanded(child: child),
        SizedBox(
          height: 70,
          child: BottomNavigationBar(
            showSelectedLabels: false,
            showUnselectedLabels: false,
            selectedItemColor: Theme.of(context).primaryColor,
            type: BottomNavigationBarType.fixed,
            iconSize: 35,
            items: _getAllVisibleItems(context, false)
                .map((i) =>
                    BottomNavigationBarItem(icon: Icon(i.icon), label: i.label))
                .toList(),
            currentIndex:
                _selectedIndex > items.length - 1 ? 0 : _selectedIndex,
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
          selectedIndex: _selectedIndex,
          items: _getAllVisibleItems(context, true)
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
        Expanded(child: child),
      ],
    );
  }

  void _onItemTapped(BuildContext context, int index) {
    if (index < items.length) {
      context.go(items[index].path);
    } else if (index - items.length < additionalItems.length) {
      context.go(additionalItems[index - items.length].path);
    }
  }

  List<NavigationItem> _getAllVisibleItems(
      BuildContext context, bool isLandscape) {
    var user = context.read<AuthCubit>().user;
    var allItems =
        isLandscape && user != null ? items + additionalItems : items;

    return allItems;
  }

  static int _computeIndex(String? path, List<NavigationItem> items,
      List<NavigationItem> additionalItems) {
    var selectedIndex = items.indexWhere((i) => i.path == path);

    if (selectedIndex == -1) {
      selectedIndex =
          additionalItems.indexWhere((i) => i.path == path) + items.length;
    }

    if (selectedIndex == -1) {
      selectedIndex = 0;
    }

    return selectedIndex;
  }
}
