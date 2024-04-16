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

final flowActionsProvider =
    StateNotifierProvider.autoDispose<FlowActionsNotifier, List<FlowAction>>(
        (ref) => FlowActionsNotifier());
