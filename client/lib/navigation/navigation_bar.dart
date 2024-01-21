// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:side_navigation/side_navigation.dart';

import 'package:ccquarters/login_register/cubit.dart';
import 'package:ccquarters/navigation/history_navigator.dart';

enum NavigationItemVisibility {
  always,
  whenSignedIn,
  whenSignedOut,
}

class NavigationItem {
  final String path;
  final String label;
  final String? parentPath;
  final IconData icon;
  final NavigationItemVisibility isVisible;
  final void Function(BuildContext context)? onTap;

  NavigationItem({
    required this.path,
    this.parentPath,
    required this.label,
    required this.icon,
    this.isVisible = NavigationItemVisibility.always,
    this.onTap,
  });
}

class NavigationShell extends StatelessWidget {
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
  Widget build(BuildContext context) {
    var visibleItems = _getOnlyVisibleItems(context);
    var selectedIndex = visibleItems.indexWhere((i) => i.path == path);

    return _NavigationShellPresenter(
      selectedIndex: selectedIndex == -1 ? 0 : selectedIndex,
      visibleItems: visibleItems,
      dontShowSelection: selectedIndex == -1,
      child: child,
    );
  }

  List<NavigationItem> _getOnlyVisibleItems(BuildContext context) {
    var isUserLoggedIn = context.read<AuthCubit>().isUserLoggedIn;

    var visibleItems = <NavigationItem>[];

    for (var item in items) {
      if (_isItemVisible(item, isUserLoggedIn)) {
        visibleItems.add(item);
      }
    }

    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      for (var item in additionalItems) {
        if (_isItemVisible(item, isUserLoggedIn)) {
          visibleItems.add(item);
        }
      }
    }

    return visibleItems;
  }

  bool _isItemVisible(NavigationItem item, bool isUserLoggedIn) {
    return item.isVisible == NavigationItemVisibility.always ||
        (item.isVisible == NavigationItemVisibility.whenSignedIn &&
            isUserLoggedIn) ||
        (item.isVisible == NavigationItemVisibility.whenSignedOut &&
            !isUserLoggedIn);
  }
}

class _NavigationShellPresenter extends StatelessWidget {
  const _NavigationShellPresenter({
    Key? key,
    required this.visibleItems,
    required this.selectedIndex,
    required this.dontShowSelection,
    required this.child,
  }) : super(key: key);

  final List<NavigationItem> visibleItems;
  final int selectedIndex;
  final bool dontShowSelection;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape
        ? _buildSideNavigationBar(context)
        : _buildBottomNavigationBar(context);
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: dontShowSelection
            ? Colors.grey.shade600
            : Theme.of(context).primaryColor,
        type: BottomNavigationBarType.fixed,
        iconSize: 35,
        items: visibleItems
            .map((i) => BottomNavigationBarItem(
                  icon: Icon(i.icon),
                  label: i.label,
                ))
            .toList(),
        currentIndex: selectedIndex,
        onTap: (index) => _onItemTapped(context, index),
      ),
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
          selectedIndex: selectedIndex,
          items: visibleItems
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
    visibleItems[index].onTap?.call(context);
    context.go(visibleItems[index].path);
  }
}
