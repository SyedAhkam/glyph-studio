import "package:flutter/material.dart";
import "package:glyph_studio/gen/fonts.gen.dart";

const grey = Color(0xD51B1D1F);
const nothingRed = Color(0xFFC8102E);
const nothingCreamyWhite = Color(0xFFD7D8D8);
const nothingLightSurface = Color(0xFFE7E9E9);
const plainWhite = Colors.white;

const textTheme = TextTheme(
  displaySmall: TextStyle(fontFamily: FontFamily.ndot),
  headlineMedium: TextStyle(fontFamily: FontFamily.ndot),
  headlineSmall: TextStyle(fontFamily: FontFamily.ndot),
  bodyLarge: TextStyle(fontFamily: FontFamily.ndot),
  titleMedium: TextStyle(fontFamily: FontFamily.ndot),
);

const dialogTheme = DialogTheme(
  surfaceTintColor: Colors.transparent,
);

const inputDecorationTheme = InputDecorationTheme(
    labelStyle: TextStyle(fontFamily: 'Roboto', color: plainWhite));

const snackBarTheme = SnackBarThemeData(
    backgroundColor: grey, contentTextStyle: TextStyle(color: plainWhite));

const floatingActionButtonTheme = FloatingActionButtonThemeData(
  backgroundColor: nothingRed,
  foregroundColor: plainWhite,
);

final lightTheme = ThemeData(
  useMaterial3: true,
  textTheme: textTheme,
  dialogTheme: dialogTheme,
  snackBarTheme: snackBarTheme,
  floatingActionButtonTheme: floatingActionButtonTheme,
  colorScheme: const ColorScheme.light(
      background: nothingCreamyWhite,
      surface: nothingLightSurface,
      secondary: nothingRed,
      tertiary: nothingRed,
      surfaceTint: nothingRed),
  brightness: Brightness.light,
);

final darkTheme = ThemeData(
  useMaterial3: true,
  textTheme: textTheme,
  dialogTheme: dialogTheme,
  inputDecorationTheme: inputDecorationTheme,
  snackBarTheme: snackBarTheme,
  floatingActionButtonTheme: floatingActionButtonTheme,
  colorScheme: const ColorScheme.dark(
      background: Colors.black,
      surface: grey,
      secondary: nothingRed,
      tertiary: nothingRed,
      surfaceTint: nothingRed),
  brightness: Brightness.dark,
);
