import 'package:ccquarters/environment.dart';
import 'package:ccquarters/login_register/gate.dart';
import 'package:ccquarters/services/auth/service.dart';
import 'package:ccquarters/services/users/service.dart';
import 'package:ccquarters/theme.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppMainGate extends StatelessWidget {
  const AppMainGate({super.key});

  @override
  Widget build(BuildContext context) {  

    return MultiProvider(
      providers: [
        Provider(
          create: (context) =>
              UserService(Dio(), Environment.apiUrl),
        ),
        Provider(
          create: (context) {
            return AuthService(firebaseAuth: FirebaseAuth.instance);
          },
        )
      ],
      child: MaterialApp(
        themeMode: ThemeMode.light,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        home: const SafeArea(
            child: AuthGate(),
          ),
      ),
    );
  }
}
