import 'package:ccquarters/login_register/cubit.dart';
import 'package:ccquarters/main_page/gate.dart';
import 'package:ccquarters/utils/device_type.dart';
import 'package:ccquarters/virtual_tour/tour_list/gate.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:side_navigation/side_navigation.dart';

import 'add_house/gate.dart';
import 'profile/gate.dart';

class NavigationGate extends StatefulWidget {
  const NavigationGate({super.key});

  @override
  State<NavigationGate> createState() => _NavigationGateState();
}

class _NavigationGateState extends State<NavigationGate> {
  int _selectedIndex = 0;
  final List<Widget> _pages = <Widget>[
    const MainPageGate(),
    const AddHouseGate(),
    const ProfileGate(),
    const VTListGate(),
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
          ? _buildBottomNavigationBar(color)
          : null,
      body: Row(
        children: [
          if (typeOfDevice == DeviceType.web)
            _buildSideNavigationBar(context, color),
          Expanded(
            child: _selectedIndex == 2
                ? ProfileGate(
                    user: context.read<AuthCubit>().user,
                  )
                : _pages.elementAt(_selectedIndex),
          )
        ],
      ),
    );
  }

  SizedBox _buildBottomNavigationBar(ColorScheme color) {
    return SizedBox(
      height: 70,
      child: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: color.primary,
        type: BottomNavigationBarType.fixed,
        iconSize: 35,
        items: _items.map(mapItemToBottomNavigationBarItem).toList(),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  SideNavigationBar _buildSideNavigationBar(
      BuildContext context, ColorScheme color) {
    return SideNavigationBar(
      selectedIndex: _selectedIndex,
      items: _items + _addWebTabItems(context),
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
    );
  }

  void _onItemTapped(int index) {
    if (index == 4 && context.read<AuthCubit>().user == null) {
      context.read<AuthCubit>().signOut();
      return;
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  List<SideNavigationBarItem> _addWebTabItems(BuildContext context) {
    return !kIsWeb
        ? []
        : [
            if (context.read<AuthCubit>().user != null)
              const SideNavigationBarItem(
                  icon: Icons.directions_walk_outlined,
                  label: "Moje wirtualne spacery"),
            if (context.read<AuthCubit>().user == null)
              const SideNavigationBarItem(
                icon: Icons.logout,
                label: "Zaloguj się lub zarejestruj",
              ),
          ];
  }
}

BottomNavigationBarItem mapItemToBottomNavigationBarItem(
    SideNavigationBarItem item) {
  return BottomNavigationBarItem(
    icon: Icon(item.icon),
    label: item.label,
  );
}
