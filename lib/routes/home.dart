import 'dart:async';

import 'package:flutter/material.dart';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:nothing_glyph_interface/nothing_glyph_interface.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:glyph_studio/models/glyph_mapping.dart';
import 'package:glyph_studio/models/phone.dart';
import 'package:glyph_studio/widgets/glyph_view.dart';
import 'package:glyph_studio/widgets/drawer_view.dart';
import 'package:glyph_studio/widgets/appbar.dart';
import 'package:glyph_studio/providers.dart';

class HomeRoute extends ConsumerWidget {
  HomeRoute({super.key});

  final _glyphInterface = GetIt.I<NothingGlyphInterface>();

  Timer? _longPressAnimationTimer;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> onGlyphTap(GlyphMap glyph) async {
    var builder = GlyphFrameBuilder();

    // Choose glyph channel
    if (glyph.group != null) {
      switch (glyph.group) {
        case "d1":
          builder.buildChannelD();
        case "c1": // phone 2 exclusive group
          // had to pull in this hack, to light up everything under c1
          // since buildChannelC() lights up the whole ring
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
        case "c":
          builder.buildChannelC();
      }
    } else {
      builder.buildChannel(glyph.idx);
    }

    // Set Common properties
    builder.buildPeriod(1000);
    builder.buildCycles(1);

    await _glyphInterface.buildGlyphFrame(builder.build());

    await _glyphInterface.animate();

    await Future.delayed(const Duration(milliseconds: 1000));

    await _glyphInterface.turnOff();
  }

  Future<void> onGlyphLongPressStart(GlyphMap glyph) async {
    var builder = GlyphFrameBuilder();

    switch (glyph.group!) {
      case "d1":
        builder.buildChannelD();
      case "c1":
        builder.buildChannelC();
      case "c":
        builder.buildChannelC();
    }

    await _glyphInterface.buildGlyphFrame(builder.build());

    var progress = 0;
    var step = (_) async {
      if (progress == 100) return; // stop increments when already 100

      // Increment by 1 each increment
      await _glyphInterface.displayProgress(progress);
      progress += 1;
    };

    _longPressAnimationTimer =
        Timer.periodic(const Duration(milliseconds: 300), step);
  }

  Future<void> onGlyphLongPressEnd(GlyphMap glyph) async {
    // Cancel the existing task
    _longPressAnimationTimer?.cancel();

    // Turn off
    _glyphInterface.turnOff();
  }

  @override
  Widget build(BuildContext context, ref) {
    var theme = Theme.of(context);

    var currentPhone = ref.watch(currentPhoneProvider);

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppbarWrapper(
          title: "GLYPH (STUDIO)",
          actions: [
            IconButton(
                icon: Text("~", style: theme.textTheme.displaySmall),
                onPressed: () {
                  // Open end drawer
                  _scaffoldKey.currentState!.openEndDrawer();
                }),
            const SizedBox(width: 8)
          ],
        ),
        endDrawer: Drawer(
            backgroundColor: theme.colorScheme.surface.withOpacity(0.95),
            child: const DrawerView()),
        body: Container(
          width: 100.w,
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  child: currentPhone.isLoading
                      ? const CircularProgressIndicator()
                      : switch (currentPhone.value!) {
                          Phone.unknown => const Center(
                              child: Text("Unsupported Device, sorry!")),
                          _ => switch (ref.watch(glyphsetProvider)) {
                              AsyncData(:final value) => GlyphView(
                                  glyphSet: value,
                                  onGlyphTap: onGlyphTap,
                                  onGlyphLongPressStart: onGlyphLongPressStart,
                                  onGlyphLongPressEnd: onGlyphLongPressEnd,
                                ),
                              AsyncError() => const Center(
                                  child: Text(
                                      "Something went wrong while loading the glyph set")),
                              _ => const CircularProgressIndicator()
                            }
                        }),
              SizedBox(height: 4.h),
              SizedBox(
                height: 16.h,
                width: 100.w,
                child: Card.filled(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(24))),
                  child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          DottedBorder(
                            color: Colors.white,
                            customPath: (size) {
                              return Path()
                                ..moveTo(0, 40)
                                ..lineTo(size.width, 40);
                            },
                            child: SizedBox(
                              child: Text(
                                  "Running on ${currentPhone.value?.formattedName}",
                                  style: theme.textTheme.headlineMedium!
                                      .copyWith(
                                          color:
                                              Colors.white.withOpacity(0.82))),
                            ),
                          ),
                          Text(
                              "${currentPhone.value != Phone.unknown ? currentPhone.value?.calculateTotalZones : '0'} Glyph Zones Available",
                              style: theme.textTheme.headlineSmall!
                                  .copyWith(color: theme.colorScheme.secondary))
                        ],
                      )),
                ),
              )
            ],
          ),
        ));
  }
}
