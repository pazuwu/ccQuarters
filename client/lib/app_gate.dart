import 'package:ccquarters/environment.dart';
import 'package:ccquarters/login_register/cubit.dart';
import 'package:ccquarters/navigation.dart';
import 'package:ccquarters/services/alerts/service.dart';
import 'package:ccquarters/services/auth/authorized_dio.dart';
import 'package:ccquarters/services/auth/service.dart';
import 'package:ccquarters/services/file_service/file_service.dart';
import 'package:ccquarters/services/houses/service.dart';
import 'package:ccquarters/services/users/service.dart';
import 'package:ccquarters/theme.dart';
import 'package:ccquarters/virtual_tour/service/service.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        routerConfig: CCQNavigation.router,
      ),
    );
  }
}
