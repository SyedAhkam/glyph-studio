import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart' hide Flow;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glyph_studio/models/app_prefs.dart';

import 'package:glyph_studio/models/flow.dart';
import 'package:glyph_studio/models/glyph_mapping.dart';

class AppPrefsNotifier extends AsyncNotifier<AppPrefs> {
  @override
  FutureOr<AppPrefs> build() async {
    try {
      return await AppPrefs
          .fromLocalStorage(); // this could fail on first launch
    } catch (_) {
      // thus we initialise a default app pref and save it when that happens
      final defaults = AppPrefs.defaults();

      await defaults.saveToLocalStorage();

      return defaults;
    }
  }

  Future<void> updateValues(
      {ThemeMode? themeMode,
      bool? enableHaptics,
      bool? mirrorGlyphView}) async {
    var current = state.value!;

    var new_ = AppPrefs(
        themeMode ?? current.themeMode,
        enableHaptics ?? current.enableHaptics,
        mirrorGlyphView ?? current.mirrorGlyphView);

    await new_.saveToLocalStorage();

    state = AsyncValue.data(new_);
  }
}

class FlowActionsNotifier extends StateNotifier<List<FlowAction>> {
  FlowActionsNotifier() : super([]);

  void addAction(FlowAction action) {
    state = [...state, action];
  }

  void createAction(GlyphMap glyph, Offset tapLocation) {
    var newSeqId = state.isEmpty ? 1 : state.last.seqId + 1;

    addAction(FlowAction(newSeqId, glyph, tapLocation));
  }
}

class FlowsNotifier extends AutoDisposeAsyncNotifier<List<Flow>> {
  @override
  FutureOr<List<Flow>> build() async {
    List<Flow> flows = [];

    var flowsDir = await Flow.getLocalFlowsDir();

    var files = await flowsDir.list().toList();

    for (var file in files) {
      if (file is File) {
        var fileContents = file.readAsStringSync();

        flows.add(Flow.fromJson(jsonDecode(fileContents)));
      }
    }

    return flows;
  }

  Future<void> delete(String flowName) async {
    List<Flow> newState = [];

    for (final flow in state.value!) {
      if (flow.name != flowName) {
        newState.add(flow);
      } else {
        await flow.delete();
      }
    }

    state = AsyncValue.data(newState);
  }
}
