import 'dart:io';

import 'package:ccquarters/navigation_gate.dart';
import 'package:ccquarters/utils/consts.dart';
import 'package:flutter/material.dart';

void main() async {
  HttpOverrides.global = CCQHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blueGrey,
          accentColor: Colors.blueGrey[50],
          cardColor: Colors.white,
          backgroundColor: Colors.white,
          errorColor: Colors.red,
          brightness: Brightness.light,
        ),
        inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.blueGrey[50],
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(formBorderRadius),
              borderSide: BorderSide(
                color: Colors.blueGrey[200]!,
                width: inputDecorationBorderSide,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(formBorderRadius),
              borderSide: const BorderSide(
                color: Colors.blueGrey,
                width: inputDecorationBorderSide,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(formBorderRadius),
              borderSide: BorderSide(
                color: Colors.blueGrey.shade300,
                width: inputDecorationBorderSide,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(formBorderRadius),
              borderSide: const BorderSide(
                color: Colors.red,
                width: inputDecorationBorderSide,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(formBorderRadius),
              borderSide: BorderSide(
                color: Colors.red[200]!,
                width: inputDecorationBorderSide,
              ),
            ),
            errorStyle: const TextStyle(
              color: Colors.red,
            ),
            labelStyle: const TextStyle(
              color: Colors.black,
            )),
        useMaterial3: true,
      ),
      home: const SafeArea(child: NavigationGate()),
    );
  }
}

class CCQHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
