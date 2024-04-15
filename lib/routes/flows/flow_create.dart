import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:glyph_studio/widgets/appbar.dart';
import 'package:glyph_studio/models/glyph_mapping.dart';
import 'package:glyph_studio/models/phone.dart';
import 'package:glyph_studio/providers.dart';
import 'package:glyph_studio/widgets/glyph_view.dart';

class FlowCreateRoute extends ConsumerWidget {
  const FlowCreateRoute({super.key});

  Future<void> onGlyphTap(GlyphMap glyph) async {}

  Widget _controlButton(String tooltip, IconData icon, VoidCallback onClick,
      {Color? backgroundColor}) {
    return IconButton(
        iconSize: 18.sp,
        padding: const EdgeInsets.all(16),
        tooltip: tooltip,
        icon: Icon(icon),
        onPressed: onClick,
        style: ButtonStyle(
            side: MaterialStateProperty.all(
                BorderSide(color: Colors.white.withOpacity(0.64))),
            backgroundColor: backgroundColor == null
                ? null
                : MaterialStateProperty.all(backgroundColor)));
  }

  @override
  Widget build(BuildContext context, ref) {
    var theme = Theme.of(context);
    var currentPhone = ref.watch(currentPhoneProvider);

    return Scaffold(
        appBar: AppbarWrapper(title: "CREATE FLOW", actions: [
          IconButton(
              icon: const Icon(Icons.help_outline),
              tooltip: "Help",
              onPressed: () {})
        ]),
        body: Padding(
          padding: const EdgeInsets.only(top: 32),
          child: Column(
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
                                ),
                              AsyncError() => const Center(
                                  child: Text(
                                      "Something went wrong while loading the glyph set")),
                              _ => const CircularProgressIndicator()
                            }
                        }),
              SizedBox(height: 4.h),
              SizedBox(
                height: 28.h,
                width: 100.w,
                child: Card(
                  color: theme.colorScheme.surface,
                  shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(16))),
                  child: Column(children: [
                    SizedBox(
                      height: 10.h,
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _controlButton(
                                  "Record", Icons.fiber_manual_record, () {},
                                  backgroundColor: theme.colorScheme.secondary),
                              SizedBox(width: 2.w),
                              _controlButton("Play", Icons.play_circle, () {}),
                              SizedBox(width: 2.w),
                              _controlButton("Save", Icons.save, () {}),
                            ],
                          ),
                          Expanded(
                            child: Container(),
                          )
                        ],
                      ),
                    ),
                    Expanded(child: Container(color: Colors.red))
                  ]),
                ),
              ),
            ],
          ),
        ));
  }
}
