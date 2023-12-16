import 'package:ccquarters/login_register/cubit.dart';
import 'package:ccquarters/profile/cubit.dart';
import 'package:ccquarters/virtual_tour/tour_list/gate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
            onTap: () {
              context.read<ProfilePageCubit>().goToEditUserPage();
            },
          ),
          ListTile(
            leading: const Icon(Icons.directions_walk),
            title: const Text('Moje Wirtualne spacery'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => VTListGate(
                        vtService: context.read(),
                      )));
            },
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
