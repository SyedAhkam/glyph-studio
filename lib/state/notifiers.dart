import 'dart:async';

import 'package:flutter/material.dart' hide Flow;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:glyph_studio/models/flow.dart';
import 'package:glyph_studio/models/glyph_mapping.dart';

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
