import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:glyph_studio/state/notifiers.dart';
import 'package:glyph_studio/state/providers.dart';
import 'package:glyph_studio/widgets/appbar.dart';

class PrefsRoute extends ConsumerWidget {
  const PrefsRoute({super.key});

  void switchTheme(BuildContext context, AppPrefsNotifier appPrefsNotifier,
      ThemeMode mode) async {
    await appPrefsNotifier.updateValues(themeMode: mode);
  }

  void switchEnableHaptics(BuildContext context,
      AppPrefsNotifier appPrefsNotifier, bool value) async {
    await appPrefsNotifier.updateValues(enableHaptics: value);
  }

  void switchMirrorGlyphView(BuildContext context,
      AppPrefsNotifier appPrefsNotifier, bool value) async {
    await appPrefsNotifier.updateValues(mirrorGlyphView: value);
  }

  @override
  Widget build(BuildContext context, ref) {
    var theme = Theme.of(context);

    var appPrefs = ref.watch(appPrefsProvider);
    var appPrefsNotifier = ref.watch(appPrefsProvider.notifier);

    var activeButtonStyle =
        ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red));

    return Scaffold(
        appBar: const AppbarWrapper(title: "PREFERENCES", actions: []),
        body: Theme(
          data: theme.copyWith(
              textTheme: theme.textTheme.copyWith(
                  bodyLarge: const TextStyle(
                      fontFamily: 'Roboto', fontWeight: FontWeight.w300)),
              listTileTheme: const ListTileThemeData(
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8))), // this is to override the global style
          child: Column(
            children: [
              ListTile(
                  title: const Text("Theme"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          tooltip: "Dark",
                          onPressed: () => switchTheme(
                              context, appPrefsNotifier, ThemeMode.dark),
                          icon: const Icon(Icons.dark_mode_outlined),
                          style: appPrefs.value?.themeMode == ThemeMode.dark
                              ? activeButtonStyle
                              : null),
                      IconButton(
                          tooltip: "Light",
                          onPressed: () => switchTheme(
                              context, appPrefsNotifier, ThemeMode.light),
                          icon: const Icon(Icons.light_mode_outlined),
                          style: appPrefs.value?.themeMode == ThemeMode.light
                              ? activeButtonStyle
                              : null),
                      IconButton(
                          tooltip: "System",
                          onPressed: () => switchTheme(
                              context, appPrefsNotifier, ThemeMode.system),
                          icon: const Icon(Icons.android_outlined),
                          style: appPrefs.value?.themeMode == ThemeMode.system
                              ? activeButtonStyle
                              : null)
                    ],
                  )),
              ListTile(
                title: const Text("Enable Haptics"),
                trailing: Switch(
                  thumbColor: MaterialStateProperty.all(Colors.red),
                  trackColor: MaterialStateProperty.all(Colors.transparent),
                  trackOutlineColor:
                      MaterialStateProperty.all(Colors.white.withOpacity(0.64)),
                  trackOutlineWidth: MaterialStateProperty.all(1),
                  value: appPrefs.value?.enableHaptics ?? false,
                  onChanged: (v) =>
                      switchEnableHaptics(context, appPrefsNotifier, v),
                ),
              ),
              ListTile(
                title: const Text("Mirror Glyphs"),
                trailing: Switch(
                  thumbColor: MaterialStateProperty.all(Colors.red),
                  trackColor: MaterialStateProperty.all(Colors.transparent),
                  trackOutlineColor:
                      MaterialStateProperty.all(Colors.white.withOpacity(0.64)),
                  trackOutlineWidth: MaterialStateProperty.all(1),
                  value: appPrefs.value?.mirrorGlyphView ?? false,
                  onChanged: (v) =>
                      switchMirrorGlyphView(context, appPrefsNotifier, v),
                ),
              ),
            ],
          ),
        ));
  }
}
