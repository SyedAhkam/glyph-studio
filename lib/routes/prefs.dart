import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:glyph_studio/models/app_prefs.dart';
import 'package:glyph_studio/state/providers.dart';
import 'package:glyph_studio/widgets/appbar.dart';

class PrefsRoute extends ConsumerWidget {
  const PrefsRoute({super.key});

  // FIXME: remove the need for a restart
  void switchTheme(BuildContext context, AppPrefs appPrefs, ThemeMode mode) {
    appPrefs.updateValues(themeMode: mode).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Done! Please restart the app to see changes")));
    });
  }

  void switchEnableHaptics(
      BuildContext context, AppPrefs appPrefs, bool value) {
    appPrefs.updateValues(enableHaptics: value).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Done! Please restart the app to see changes")));
    });
  }

  @override
  Widget build(BuildContext context, ref) {
    var theme = Theme.of(context);

    var appPrefs = ref.watch(appPrefsProvider);

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
                              context, appPrefs.value!, ThemeMode.dark),
                          icon: const Icon(Icons.dark_mode_outlined),
                          style: appPrefs.value?.themeMode == ThemeMode.dark
                              ? activeButtonStyle
                              : null),
                      IconButton(
                          tooltip: "Light",
                          onPressed: () => switchTheme(
                              context, appPrefs.value!, ThemeMode.light),
                          icon: const Icon(Icons.light_mode_outlined),
                          style: appPrefs.value?.themeMode == ThemeMode.light
                              ? activeButtonStyle
                              : null),
                      IconButton(
                          tooltip: "System",
                          onPressed: () => switchTheme(
                              context, appPrefs.value!, ThemeMode.system),
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
                      switchEnableHaptics(context, appPrefs.value!, v),
                ),
              ),
            ],
          ),
        ));
  }
}
