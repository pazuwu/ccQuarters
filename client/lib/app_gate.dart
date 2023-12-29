import 'package:ccquarters/add_house/gate.dart';
import 'package:ccquarters/alerts/gate.dart';
import 'package:ccquarters/environment.dart';
import 'package:ccquarters/login_register/cubit.dart';
import 'package:ccquarters/login_register/gate.dart';
import 'package:ccquarters/main_page/gate.dart';
import 'package:ccquarters/navigation_bar.dart';
import 'package:ccquarters/profile/gate.dart';
import 'package:ccquarters/services/alerts/service.dart';
import 'package:ccquarters/services/auth/authorized_dio.dart';
import 'package:ccquarters/services/auth/service.dart';
import 'package:ccquarters/services/file_service/file_service.dart';
import 'package:ccquarters/services/houses/service.dart';
import 'package:ccquarters/services/users/service.dart';
import 'package:ccquarters/theme.dart';
import 'package:ccquarters/virtual_tour/extended_tour_list/extended_tour_list.dart';
import 'package:ccquarters/virtual_tour/service/service.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AppMainGate extends StatelessWidget {
  const AppMainGate({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<BaseAuthService>(
          create: (context) => AuthService(firebaseAuth: FirebaseAuth.instance),
        ),
        Provider<Dio>(
          create: (context) => AuthorizedDio(context.read()).create(),
        ),
        Provider<FileService>(create: (context) => CacheManagerFileService()),
        Provider<UserService>(
          create: (context) =>
              UserService(context.read(), "${Environment.apiUrl}/users"),
        ),
        Provider(
          create: (context) =>
              UserService(context.read(), "${Environment.apiUrl}/users"),
        ),
        Provider(
          create: (context) =>
              HouseService(context.read(), "${Environment.apiUrl}/houses"),
        ),
        Provider(
          create: (context) =>
              AlertService(context.read(), "${Environment.apiUrl}/alerts"),
        ),
        Provider(
          create: (context) =>
              VTService(context.read(), context.read(), Environment.vtApiUrl),
        ),
        BlocProvider(
          create: (context) => AuthCubit(
            authService: context.read(),
            userService: context.read(),
          ),
        )
      ],
      child: MaterialApp.router(
        themeMode: ThemeMode.light,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        routerConfig: GoRouter(
          initialLocation: '/home',
          routes: [
            GoRoute(
              path: '/login',
              builder: (context, state) => Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: const SafeArea(
                  child: AuthGate(),
                ),
              ),
            ),
            ShellRoute(
                builder: (context, state, widget) => Material(
                        child: NavigationShell(
                      items: [
                        NavigationItem(
                          icon: Icons.home,
                          label: "Strona główna",
                          path: '/home',
                        ),
                        NavigationItem(
                          icon: Icons.add,
                          label: "Dodaj ogłoszenie",
                          path: '/new-house',
                        ),
                        NavigationItem(
                          icon: Icons.person,
                          label: "Profil",
                          path: '/profile',
                        ),
                      ],
                      additionalItems: [
                        NavigationItem(
                          icon: Icons.notifications,
                          label: "Moje alerty",
                          path: '/my-alerts',
                        ),
                        NavigationItem(
                          icon: Icons.directions_walk_outlined,
                          label: "Moje wirtualne spacery",
                          path: '/my-tours',
                        ),
                      ],
                      child: widget,
                    )),
                routes: [
                  GoRoute(
                    path: '/home',
                    builder: (context, state) =>
                        const Material(child: MainPageGate()),
                  ),
                  GoRoute(
                    path: '/new-house',
                    builder: (context, state) => const AddHouseGate(),
                  ),
                  GoRoute(
                    path: '/profile',
                    builder: (context, state) =>
                        ProfileGate(user: context.read<AuthCubit>().user),
                  ),
                  GoRoute(
                    path: '/my-tours',
                    builder: (context, state) => const TourListExtendedGate(),
                  ),
                  GoRoute(
                    path: '/my-alerts',
                    builder: (context, state) => const AlertsGate(),
                  )
                ]),
          ],
        ),
      ),
    );
  }
}
