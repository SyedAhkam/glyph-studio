import 'dart:async';

import 'package:glyph_studio/models/flow.dart';
import 'package:glyph_studio/models/glyph_mapping.dart';
import 'package:glyph_studio/models/phone.dart';
import 'package:nothing_glyph_interface/nothing_glyph_interface.dart';

class GlyphPlayer {
  final NothingGlyphInterface glyphInterface;

  GlyphPlayer(this.glyphInterface);

  Timer? _longPressAnimationTimer;

  // Custom wrapper buildChannelC method
  // since default buildChannelC() is inconsistent across different phones
  void buildChannelC(Phone phone, GlyphFrameBuilder builder) {
    switch (phone) {
      case Phone.phone1:
        builder.buildChannel(Phone1GlyphMap.c1.idx);
        builder.buildChannel(Phone1GlyphMap.c2.idx);
        builder.buildChannel(Phone1GlyphMap.c3.idx);
        builder.buildChannel(Phone1GlyphMap.c4.idx);
      case Phone.phone2:
        builder.buildChannel(Phone2GlyphMap.c1_1.idx);
        builder.buildChannel(Phone2GlyphMap.c1_2.idx);
        builder.buildChannel(Phone2GlyphMap.c1_3.idx);
        builder.buildChannel(Phone2GlyphMap.c1_4.idx);
        builder.buildChannel(Phone2GlyphMap.c1_5.idx);
        builder.buildChannel(Phone2GlyphMap.c1_6.idx);
        builder.buildChannel(Phone2GlyphMap.c1_7.idx);
        builder.buildChannel(Phone2GlyphMap.c1_8.idx);
        builder.buildChannel(Phone2GlyphMap.c1_9.idx);
        builder.buildChannel(Phone2GlyphMap.c1_10.idx);
        builder.buildChannel(Phone2GlyphMap.c1_11.idx);
        builder.buildChannel(Phone2GlyphMap.c1_12.idx);
        builder.buildChannel(Phone2GlyphMap.c1_13.idx);
        builder.buildChannel(Phone2GlyphMap.c1_14.idx);
        builder.buildChannel(Phone2GlyphMap.c1_15.idx);
        builder.buildChannel(Phone2GlyphMap.c1_16.idx);
      case Phone.phone2a:
        // for phone 2a, default is sufficient
        builder.buildChannelC();
      default:
        throw UnimplementedError();
    }
  }

  Future<void> handleSingleGlyph(GlyphMap glyph, Phone phone) async {
    var builder = GlyphFrameBuilder();

    // Choose glyph channel
    if (glyph.group != null) {
      switch (glyph.group) {
        case "d1":
          builder.buildChannelD();
        case "c1" || "c":
          buildChannelC(phone, builder);
      }
    } else {
      builder.buildChannel(glyph.idx);
    }

    // Set Common properties
    builder.buildPeriod(1000);
    builder.buildCycles(1);

    await glyphInterface.buildGlyphFrame(builder.build());

    await glyphInterface.animate();

    await Future.delayed(const Duration(milliseconds: 1000));

    await glyphInterface.turnOff();
  }

  Future<void> handleLongPressStart(GlyphMap glyph) async {
    var builder = GlyphFrameBuilder();

    switch (glyph.group!) {
      case "d1":
        builder.buildChannelD();
      case "c1":
        builder.buildChannelC();
      case "c":
        builder.buildChannelC();
    }

    await glyphInterface.buildGlyphFrame(builder.build());

    var progress = 0;
    var step = (_) async {
      if (progress == 100) return; // stop increments when already 100

      // Increment by 1 each increment
      await glyphInterface.displayProgress(progress);
      progress += 1;
    };

    _longPressAnimationTimer =
        Timer.periodic(const Duration(milliseconds: 300), step);
  }

  Future<void> handleLongPressEnd(_) async {
    // Cancel the existing task
    _longPressAnimationTimer?.cancel();

    // Turn off
    glyphInterface.turnOff();
  }

  Future<void> playActions(List<FlowAction> actions) async {
    for (var action in actions) {
      final builder = GlyphFrameBuilder();

      builder.buildChannel(action.glyph.idx);
      builder.buildPeriod(action.duration.inMilliseconds);

      await glyphInterface.buildGlyphFrame(builder.build());

      await glyphInterface.animate();

      await Future.delayed(action.duration);
    }

    await glyphInterface.turnOff();
  }

  Future<void> playFlow(Flow flow) async {
    playActions(flow.actions);
  }
}
