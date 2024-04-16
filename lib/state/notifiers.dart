import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:glyph_studio/models/flow.dart';

class FlowActionsNotifier extends StateNotifier<List<FlowAction>> {
  FlowActionsNotifier() : super([]);

  void addAction(FlowAction action) {
    state = [...state, action];
  }
}
