import 'package:ccquarters/main_page/gate.dart';
import 'package:ccquarters/utils/device_type.dart';
import 'package:ccquarters/virtual_tour/gate.dart';
import 'package:flutter/material.dart';
import 'package:side_navigation/side_navigation.dart';

import 'add_house/gate.dart';
import 'profile/profile_gate.dart';

class NavigationGate extends StatefulWidget {
  const NavigationGate({super.key});

  @override
  State<NavigationGate> createState() => _NavigationGateState();
}

class _NavigationGateState extends State<NavigationGate> {
  int _selectedIndex = 0;
  final List<Widget> _pages = <Widget>[
    const VirtualTourGate(
      tourId: 'vu7TKNy0zkPj6jHy6lIq',
      readOnly: false,
    ),
    const AddHouseGate(),
    const ProfileGate(
      login: "",
      isFromSearch: false,
    ),
  ];

  final List<SideNavigationBarItem> _items = <SideNavigationBarItem>[
    const SideNavigationBarItem(
      icon: Icons.home,
      label: "Strona główna",
    ),
    const SideNavigationBarItem(
      icon: Icons.add,
      label: "Dodaj ogłoszenie",
    ),
    const SideNavigationBarItem(
      icon: Icons.person,
      label: "Profil",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    var typeOfDevice = getDeviceType(context);
    final color = Theme.of(context).colorScheme;
    return Scaffold(
      bottomNavigationBar: typeOfDevice == DeviceType.mobile
          ? BottomNavigationBar(
              showSelectedLabels: false,
              showUnselectedLabels: false,
              selectedItemColor: color.primary,
              type: BottomNavigationBarType.fixed,
              iconSize: 40,
              items: _items.map(mapItemToBottomNavigationBarItem).toList(),
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
            )
          : null,
      body: Row(
        children: [
          if (typeOfDevice == DeviceType.web)
            SideNavigationBar(
              selectedIndex: _selectedIndex,
              items: _items,
              theme: SideNavigationBarTheme(
                backgroundColor: color.background,
                togglerTheme: SideNavigationBarTogglerTheme.standard(),
                itemTheme: SideNavigationBarItemTheme(
                  unselectedItemColor: Colors.black,
                  selectedItemColor: color.primary,
                  iconSize: 32.5,
                ),
                dividerTheme: SideNavigationBarDividerTheme.standard(),
              ),
              onTap: _onItemTapped,
            ),
          Expanded(
            child: _pages.elementAt(_selectedIndex),
          )
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}

BottomNavigationBarItem mapItemToBottomNavigationBarItem(
    SideNavigationBarItem item) {
  return BottomNavigationBarItem(
    icon: Icon(item.icon),
    label: item.label,
  );
}
