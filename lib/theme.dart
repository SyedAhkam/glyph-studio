import "package:flutter/material.dart";

const textTheme = TextTheme(
  displaySmall: TextStyle(fontFamily: "Ndot"),
);

final theme = ThemeData(useMaterial3: true, textTheme: textTheme);

final darkTheme =
    theme.copyWith(textTheme: textTheme, colorScheme: const ColorScheme.dark());
