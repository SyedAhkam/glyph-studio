import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:glyph_studio/models/phone.dart';
import 'package:glyph_studio/models/glyph_set.dart';
import 'package:glyph_studio/models/flow.dart';
import 'package:glyph_studio/state/notifiers.dart';

// ------------------- Common ----------------------

final currentPhoneProvider =
    FutureProvider<Phone>((ref) async => await Phone.guessCurrentPhone());

final glyphsetProvider = FutureProvider<GlyphSet>((ref) async {
  var currentPhone = ref.watch(currentPhoneProvider);

  return await GlyphSet.load(currentPhone.value!);
});

// ------------------ Flow create screen --------------

final isRecordingProvider = StateProvider.autoDispose<bool>((ref) => false);
final isPlayingProvider = StateProvider.autoDispose<bool>((ref) => false);

final flowActionsProvider =
    StateNotifierProvider.autoDispose<FlowActionsNotifier, List<FlowAction>>(
        (ref) => FlowActionsNotifier());

// ----------------- Flow list screen -----------------

final flowsProvider = FutureProvider.autoDispose<List<Flow>>((ref) async {
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
});
