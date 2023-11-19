import 'package:ccquarters/utils/consts.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData light = ThemeData(
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
  );

  static ThemeData dark = ThemeData(
    primaryColor: Colors.black,
    primaryColorLight: Colors.black,
    brightness: Brightness.dark,
    primaryColorDark: Colors.black,
    indicatorColor: Colors.white,
    canvasColor: Colors.black,
    appBarTheme: const AppBarTheme(),
  );
}
