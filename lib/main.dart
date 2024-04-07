import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'package:glyph_studio/routes/home.dart';
import 'package:glyph_studio/theme.dart';

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeRoute(),
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: "Glyph Studio",
      theme: theme,
      darkTheme: darkTheme,
      routerConfig: _router,
      themeMode: ThemeMode.dark, // TODO: allow setting user preference later
    );
  }
}

void main() {
  runApp(const MyApp());
}
