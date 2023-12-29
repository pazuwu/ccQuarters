import 'dart:io';

import 'package:ccquarters/app_gate.dart';
import 'package:ccquarters/environment.dart';
import 'package:ccquarters/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

void main() async {
  await appSetup();
  runApp(const MyApp());
}

Future appSetup() async {
  usePathUrlStrategy();
  await dotenv.load(fileName: Environment.filename);
  HttpOverrides.global = CCQHttpOverrides();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppMainGate();
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
