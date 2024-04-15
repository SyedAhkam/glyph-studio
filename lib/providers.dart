import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:glyph_studio/models/phone.dart';
import 'package:glyph_studio/models/glyph_set.dart';
import 'package:nothing_glyph_interface/nothing_glyph_interface.dart';

final currentPhoneProvider =
    FutureProvider<Phone>((ref) async => await Phone.guessCurrentPhone());

final glyphsetProvider = FutureProvider<GlyphSet>((ref) async {
  var currentPhone = ref.watch(currentPhoneProvider);

  return await GlyphSet.load(currentPhone.value!);
});
