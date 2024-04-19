import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:glyph_studio/models/app_prefs.dart';
import 'package:glyph_studio/models/phone.dart';
import 'package:glyph_studio/models/glyph_set.dart';
import 'package:glyph_studio/models/flow.dart';
import 'package:glyph_studio/state/notifiers.dart';

// ------------------- Common ----------------------

final appPrefsProvider = FutureProvider<AppPrefs>((ref) async {
  try {
    return await AppPrefs.fromLocalStorage(); // this could fail on first launch
  } catch (_) {
    // thus we initialise a default app pref and save it when that happens
    final defaults = AppPrefs.defaults();

    await defaults.updateLocalStorage();

    return defaults;
  }
});

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

final flowsProvider =
    AsyncNotifierProvider.autoDispose<FlowsNotifier, List<Flow>>(
        () => FlowsNotifier());
