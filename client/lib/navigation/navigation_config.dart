import 'package:ccquarters/add_house/gate.dart';
import 'package:ccquarters/alerts/gate.dart';
import 'package:ccquarters/common/messages/error_message.dart';
import 'package:ccquarters/common/views/gallery.dart';
import 'package:ccquarters/common/views/require_sign_in.dart';
import 'package:ccquarters/common/views/scrollable_view.dart';
import 'package:ccquarters/house_details/gate.dart';
import 'package:ccquarters/list_of_houses/model/filter_query.dart';
import 'package:ccquarters/list_of_houses/gate.dart';
import 'package:ccquarters/list_of_houses/model/houses_extra.dart';
import 'package:ccquarters/login_register/cubit.dart';
import 'package:ccquarters/login_register/gate.dart';
import 'package:ccquarters/main_page/gate.dart';
import 'package:ccquarters/navigation/history_navigator.dart';
import 'package:ccquarters/navigation/navigation_bar.dart';
import 'package:ccquarters/profile/gate.dart';
import 'package:ccquarters/my_tours/my_tours_gate.dart';
import 'package:ccquarters/tours/gate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CCQNavigationConfig {
  static final RouterConfig<Object> _router = GoRouter(
    initialLocation: '/home',
    routes: [
      ShellRoute(
        builder: (context, state, widget) => BackButtonListener(
          onBackButtonPressed: () async {
            context.goBack();
            return true;
          },
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: SafeArea(
              child: ScrollableView(
                child: AuthGate(
                  child: widget,
                ),
              ),
            ),
          ),
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
                        isVisible: NavigationItemVisibility.whenSignedIn,
                      ),
                      NavigationItem(
                        icon: Icons.directions_walk_outlined,
                        label: "Moje wirtualne spacery",
                        path: '/my-tours',
                        isVisible: NavigationItemVisibility.whenSignedIn,
                      ),
                      NavigationItem(
                          icon: Icons.login,
                          label: "Zaloguj się",
                          path: '/login',
                          isVisible: NavigationItemVisibility.whenSignedOut,
                          onTap: (context) =>
                              context.read<AuthCubit>().signOut()),
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
                  builder: (context, state) => const RequireSignIn(
                    child: AddHouseGate(),
                  ),
                ),
                GoRoute(
                  path: '/profile',
                  builder: (context, state) => const RequireSignIn(
                    child: ProfileGate(),
                  ),
                ),
                GoRoute(
                  path: '/my-tours',
                  builder: (context, state) => RequireSignIn(
                    child: MyToursGate(
                      openedTourId: state.uri.queryParameters['id'],
                    ),
                  ),
                ),
                GoRoute(
                  path: '/my-alerts',
                  builder: (context, state) => const RequireSignIn(
                    child: AlertsGate(),
                  ),
                ),
                GoRoute(
                    path: '/houses',
                    builder: (context, state) => ListOfHousesGate(
                          filter: HouseFilterQuery.fromMap(
                            state.uri.queryParameters,
                          ).toHouseFilter(),
                          isSearch: state.extra is HousesExtra &&
                              (state.extra as HousesExtra).isSearch,
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
              child: TourViewerGate(
                tourId: state.pathParameters['id']!,
                currentSceneId: state.uri.queryParameters['sceneId'],
              ),
            ),
          ),
          GoRoute(
            path: '/gallery',
            builder: (context, state) {
              if (state.extra is GalleryParameters) {
                final params = state.extra as GalleryParameters;
                return Gallery(
                  imageUrls: params.imageUrls,
                  memoryPhotos: params.memoryPhotos,
                  initialIndex: params.initialIndex,
                );
              }

              return ErrorMessage(
                'Strona o podanym adresie nie istnieje',
                tip: 'Upewnij się, że link, który wpisałeś jest poprawny',
              );
            },
          ),
        ],
      ),
    ],
  );

  static RouterConfig<Object> get router => _router;
}
