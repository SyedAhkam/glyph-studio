import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:nothing_glyph_interface/nothing_glyph_interface.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:glyph_studio/routes/home.dart';
import 'package:glyph_studio/routes/oss.dart';
import 'package:glyph_studio/theme.dart';

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => HomeRoute(),
    ),
    GoRoute(
      path: '/oss',
      builder: (context, state) => const OSSRoute(),
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(builder: (context, orientation, screenType) {
      return MaterialApp.router(
        title: "Glyph Studio",
        theme: theme,
        darkTheme: darkTheme,
        routerConfig: _router,
        themeMode: ThemeMode.dark, // TODO: allow setting user preference later
      );
    });
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  GetIt.I.registerSingleton(NothingGlyphInterface());

  runApp(const ProviderScope(child: MyApp()));
}
