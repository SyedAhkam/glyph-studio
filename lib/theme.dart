import "package:flutter/material.dart";
import "package:glyph_studio/gen/fonts.gen.dart";

const textTheme = TextTheme(
    displaySmall: TextStyle(fontFamily: FontFamily.ndot),
    headlineMedium: TextStyle(fontFamily: FontFamily.ndot),
    headlineSmall: TextStyle(fontFamily: FontFamily.ndot));

final theme = ThemeData(useMaterial3: true, textTheme: textTheme);

final darkTheme = ThemeData(
    useMaterial3: true,
    textTheme: textTheme,
    colorScheme: const ColorScheme.dark(
      background: Colors.black,
      surface: Color(0xD51B1D1F), // greyish
    ),
    brightness: Brightness.dark);
