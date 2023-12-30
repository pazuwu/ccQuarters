import 'package:ccquarters/add_house/gate.dart';
import 'package:ccquarters/alerts/gate.dart';
import 'package:ccquarters/house_details/gate.dart';
import 'package:ccquarters/list_of_houses/filter_query.dart';
import 'package:ccquarters/list_of_houses/gate.dart';
import 'package:ccquarters/login_register/gate.dart';
import 'package:ccquarters/main_page/gate.dart';
import 'package:ccquarters/navigation_bar.dart';
import 'package:ccquarters/profile/gate.dart';
import 'package:ccquarters/virtual_tour/extended_tour_list/extended_tour_list.dart';
import 'package:ccquarters/virtual_tour/tour/gate.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CCQNavigation {
  static RouterConfig<Object> createRouter() {
    return GoRouter(
      initialLocation: '/login',
      routes: [
        ShellRoute(
          builder: (context, state, widget) => Scaffold(
            body: SafeArea(child: widget),
          ),
          routes: [
            GoRoute(
              path: '/login',
              builder: (context, state) => Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: const AuthGate(),
              ),
            ),
            ShellRoute(
                builder: (context, state, widget) => Material(
                        child: NavigationShell(
                      path: state.matchedLocation,
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
                    builder: (context, state) => const Material(
                      child: MainPageGate(),
                    ),
                  ),
                  GoRoute(
                    path: '/new-house',
                    builder: (context, state) => const AddHouseGate(),
                  ),
                  GoRoute(
                    path: '/profile',
                    builder: (context, state) => const ProfileGate(),
                  ),
                  GoRoute(
                    path: '/my-tours',
                    builder: (context, state) => const TourListExtendedGate(),
                  ),
                  GoRoute(
                    path: '/my-alerts',
                    builder: (context, state) => const AlertsGate(),
                  ),
                  GoRoute(
                      path: '/houses',
                      builder: (context, state) => ListOfHousesGate(
                            filter: HouseFilterQuery.fromMap(
                                    state.uri.queryParameters)
                                .toHouseFilter(),
                          ),
                      routes: [
                        GoRoute(
                          path: ':id',
                          builder: (context, state) => HouseDetailsGate(
                              houseId: state.pathParameters['id']!),
                        ),
                      ]),
                ]),
            GoRoute(
              path: '/tours/:id',
              builder: (context, state) => Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: VirtualTourGate(
                  tourId: state.pathParameters['id']!,
                  readOnly: true,
                  showTitle: MediaQuery.of(context).orientation ==
                      Orientation.portrait,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
