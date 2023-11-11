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

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
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
