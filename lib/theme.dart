import "package:flutter/material.dart";
import "package:glyph_studio/gen/fonts.gen.dart";

const textTheme = TextTheme(
  displaySmall: TextStyle(fontFamily: FontFamily.ndot),
  headlineMedium: TextStyle(fontFamily: FontFamily.ndot),
  headlineSmall: TextStyle(fontFamily: FontFamily.ndot),
  bodyLarge: TextStyle(fontFamily: FontFamily.ndot),
  titleMedium: TextStyle(fontFamily: FontFamily.ndot),
);

const dialogTheme = DialogTheme(
  // colors same as surface
  backgroundColor: Color(0xD51B1D1F),
  surfaceTintColor: Color(0xD51B1D1F),
);

const inputDecorationTheme = InputDecorationTheme(
    labelStyle: TextStyle(fontFamily: 'Roboto', color: Colors.white));

const snackBarTheme = SnackBarThemeData(
    backgroundColor: Color(0xD51B1D1F),
    contentTextStyle: TextStyle(color: Colors.white));

const floatingActionButtonTheme = FloatingActionButtonThemeData(
  backgroundColor: Color(0xFFC8102E),
  foregroundColor: Colors.white,
);

final theme = ThemeData(useMaterial3: true, textTheme: textTheme);

final darkTheme = ThemeData(
    useMaterial3: true,
    textTheme: textTheme,
    dialogTheme: dialogTheme,
    inputDecorationTheme: inputDecorationTheme,
    snackBarTheme: snackBarTheme,
    floatingActionButtonTheme: floatingActionButtonTheme,
    colorScheme: const ColorScheme.dark(
        background: Colors.black,
        surface: Color(0xD51B1D1F), // greyish
        secondary: Color(0xFFC8102E),
        tertiary: Color(0xFFC8102E)),
    brightness: Brightness.dark);
