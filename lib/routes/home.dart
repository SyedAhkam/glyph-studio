import 'package:flutter/material.dart';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:glyph_studio/glyph_player.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:glyph_studio/models/phone.dart';
import 'package:glyph_studio/widgets/glyph_view.dart';
import 'package:glyph_studio/widgets/drawer_view.dart';
import 'package:glyph_studio/widgets/appbar.dart';
import 'package:glyph_studio/state/providers.dart';

class HomeRoute extends ConsumerWidget {
  HomeRoute({super.key});

  final glyphPlayer = GetIt.I<GlyphPlayer>();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
                tooltip: "Drawer",
                onPressed: () {
                  // Open end drawer
                  _scaffoldKey.currentState!.openEndDrawer();
                }),
            const SizedBox(width: 8)
          ],
        ),
        endDrawer: Drawer(
            backgroundColor: theme.colorScheme.surface.withOpacity(0.95),
            surfaceTintColor: Colors.transparent,
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
                                  onGlyphTap: (glyph) =>
                                      glyphPlayer.handleSingleGlyph(
                                          glyph, currentPhone.value!),
                                  onGlyphLongPressStart:
                                      glyphPlayer.handleLongPressStart,
                                  onGlyphLongPressEnd:
                                      glyphPlayer.handleLongPressEnd,
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
                  elevation: 0.5,
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
                                          color: theme
                                              .textTheme.headlineMedium!.color!
                                              .withOpacity(0.82))),
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
