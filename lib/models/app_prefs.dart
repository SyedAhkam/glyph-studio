import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

@immutable
class AppPrefs {
  final ThemeMode themeMode;
  final bool enableHaptics;
  final bool mirrorGlyphView;

  const AppPrefs(this.themeMode, this.enableHaptics, this.mirrorGlyphView);

  factory AppPrefs.defaults() {
    return const AppPrefs(ThemeMode.dark, true, false);
  }

  static fromJson(String contents) {
    final map = jsonDecode(contents);

    return AppPrefs(
        ThemeMode.values.firstWhere((e) => e.name == map['theme_mode']),
        map['enable_haptics'],
        map['mirror_glyph_view']);
  }

  static get fileName => "app_prefs.json";

  static fromLocalStorage() async {
    final cacheDir = await getExternalStorageDirectory();

    final file = File("${cacheDir!.path}/$fileName");
    final fileContents = await file.readAsString();

    return fromJson(fileContents);
  }

  String toJson() => jsonEncode({
        "theme_mode": themeMode.name,
        "enable_haptics": enableHaptics,
        "mirror_glyph_view": mirrorGlyphView
      });

  Future<void> saveToLocalStorage() async {
    final json = toJson();
    final cacheDir = await getExternalStorageDirectory();

    final file = File("${cacheDir!.path}/$fileName");
    await file.writeAsString(json);
  }
}
