import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:nothing_glyph_interface/nothing_glyph_interface.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:glyph_studio/glyph_player.dart';
import 'package:glyph_studio/routes/prefs.dart';
import 'package:glyph_studio/state/providers.dart';
import 'package:glyph_studio/routes/home.dart';
import 'package:glyph_studio/routes/oss.dart';
import 'package:glyph_studio/routes/flows/flow_create.dart';
import 'package:glyph_studio/routes/flows/flow_list.dart';
import 'package:glyph_studio/theme.dart';

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => HomeRoute(),
    ),
    GoRoute(
      path: '/flows',
      builder: (context, state) => FlowListRoute(),
    ),
    GoRoute(
      path: '/flows/create',
      builder: (context, state) => FlowCreateRoute(),
    ),
    GoRoute(
      path: '/prefs',
      builder: (context, state) => const PrefsRoute(),
    ),
    GoRoute(
      path: '/oss',
      builder: (context, state) => const OSSRoute(),
    ),
  ],
);

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, ref) {
    var appPrefs = ref.watch(appPrefsProvider);

    return ResponsiveSizer(builder: (context, orientation, screenType) {
      return MaterialApp.router(
        title: "Glyph Studio",
        theme: lightTheme,
        darkTheme: darkTheme,
        routerConfig: _router,
        themeMode: appPrefs.value?.themeMode ??
            ThemeMode.dark, // FIXME: can cause flickers in light mode
      );
    });
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Register Glyph player as singleton
  GetIt.I.registerSingleton(GlyphPlayer(NothingGlyphInterface()));

  runApp(const ProviderScope(child: MyApp()));
}
