import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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

class NavigationShell extends StatefulWidget {
  const NavigationShell({
    Key? key,
    required this.items,
    this.additionalItems = const [],
    required this.child,
  }) : super(key: key);

  final List<NavigationItem> items;
  final List<NavigationItem> additionalItems;
  final Widget child;

  @override
  State<NavigationShell> createState() => _NavigationShellState();
}

class _NavigationShellState extends State<NavigationShell> {
  int _selectedIndex = 0;
  int? _selectedAdditionalIndex;

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).orientation == Orientation.portrait &&
        _selectedIndex >= widget.items.length &&
        _selectedAdditionalIndex == null) {
      setState(() {
        _selectedAdditionalIndex = _selectedIndex;
        _selectedIndex = widget.items.length - 1;
      });
    } else if (MediaQuery.of(context).orientation == Orientation.landscape &&
        _selectedAdditionalIndex != null) {
      setState(() {
        _selectedIndex = _selectedAdditionalIndex!;
        _selectedAdditionalIndex = null;
      });
    }

    return MediaQuery.of(context).orientation == Orientation.landscape
        ? _buildSideNavigationBar(context)
        : _buildBottomNavigationBar();
  }

  Widget _buildBottomNavigationBar() {
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
            items: widget.items
                .map((i) =>
                    BottomNavigationBarItem(icon: Icon(i.icon), label: i.label))
                .toList(),
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
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
          items: widget.items
                  .map((i) =>
                      SideNavigationBarItem(icon: i.icon, label: i.label))
                  .toList() +
              widget.additionalItems
                  .map((i) =>
                      SideNavigationBarItem(icon: i.icon, label: i.label))
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
          onTap: _onItemTapped,
        ),
        Expanded(child: widget.child),
      ],
    );
  }

  void _onItemTapped(int index) {
    if (_selectedAdditionalIndex != null) {
      index = widget.items.length - 1;
    }

    setState(() {
      _selectedIndex = index;
    });

    if (index < widget.items.length) {
      context.go(widget.items[index].path);
    } else if (index - widget.items.length < widget.additionalItems.length) {
      context.go(widget.additionalItems[index - widget.items.length].path);
    }
  }
}
