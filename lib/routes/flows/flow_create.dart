import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glyph_studio/models/flow.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:glyph_studio/widgets/appbar.dart';
import 'package:glyph_studio/models/glyph_mapping.dart';
import 'package:glyph_studio/models/phone.dart';
import 'package:glyph_studio/state/providers.dart';
import 'package:glyph_studio/widgets/glyph_view.dart';

class ArrowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    final Paint paint = Paint();

    paint.color = const Color(0xffffffff);
    path.moveTo(size.width * 0.01, size.height * 0.5);
    path.lineTo(size.width * 0.19, size.height * 0.88);
    path.lineTo(size.width * 0.37, size.height * 0.5);
    path.lineTo(size.width * 0.19, size.height * 0.12);
    path.lineTo(size.width * 0.01, size.height * 0.5);
    path.lineTo(size.width * 0.01, size.height * 0.5);
    path.moveTo(size.width * 0.98, size.height * 0.55);
    path.cubicTo(size.width, size.height * 0.52, size.width, size.height * 0.48,
        size.width * 0.98, size.height * 0.45);
    path.lineTo(size.width * 0.78, size.height * 0.03);
    path.cubicTo(size.width * 0.77, size.height * -0.01, size.width * 0.74,
        size.height * 0.01, size.width * 0.73, size.height * 0.06);
    path.cubicTo(size.width * 0.73, size.height * 0.08, size.width * 0.73,
        size.height * 0.11, size.width * 0.74, size.height * 0.12);
    path.lineTo(size.width * 0.92, size.height * 0.5);
    path.lineTo(size.width * 0.74, size.height * 0.88);
    path.cubicTo(size.width * 0.72, size.height * 0.91, size.width * 0.73,
        size.height * 0.98, size.width * 0.75, size.height * 0.99);
    path.cubicTo(size.width * 0.76, size.height, size.width * 0.78,
        size.height * 0.99, size.width * 0.78, size.height * 0.97);
    path.lineTo(size.width * 0.98, size.height * 0.55);
    path.lineTo(size.width * 0.98, size.height * 0.55);
    path.moveTo(size.width * 0.19, size.height * 0.57);
    path.lineTo(size.width * 0.96, size.height * 0.57);
    path.lineTo(size.width * 0.96, size.height * 0.43);
    path.lineTo(size.width * 0.19, size.height * 0.43);
    path.lineTo(size.width * 0.19, size.height * 0.57);
    path.lineTo(size.width * 0.19, size.height * 0.57);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class FlowCreateRoute extends ConsumerWidget {
  const FlowCreateRoute({super.key});

  Future<void> onGlyphTap(GlyphMap glyph) async {}

  void onPressRecord() {}

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

  Widget _flowActionView(
      FlowAction action, Color bgColor, TextStyle textStyle) {
    return Container(
      height: 8.h,
      width: 18.w,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: bgColor,
          borderRadius: const BorderRadius.all(Radius.circular(16))),
      child: Text(
          action.glyph
              .toString()
              .split(".")[1], // splits Phone1GlyphMap.a1 into a1
          style: textStyle),
    );
  }

  @override
  Widget build(BuildContext context, ref) {
    var theme = Theme.of(context);

    var currentPhone = ref.watch(currentPhoneProvider);
    var isRecording = ref.watch(isRecordingProvider);
    var flowActions = ref.watch(flowActionsProvider);

    List<Widget> flowActionWidgets = flowActions.isEmpty
        ? []
        : List.generate(flowActions.length * 2 - 1, (idx) {
            if (idx.isEven) {
              var actionIdx = idx ~/ 2;
              return _flowActionView(flowActions[actionIdx],
                  theme.colorScheme.secondary, theme.textTheme.headlineSmall!);
            }

            return CustomPaint(
                painter: ArrowPainter(), size: const Size(64, 30));
          });

    return Scaffold(
        appBar: AppbarWrapper(title: "CREATE FLOW", actions: [
          IconButton(
              icon: const Icon(Icons.help_outline),
              tooltip: "Help",
              onPressed: () {
                ref
                    .read(flowActionsProvider.notifier)
                    .addAction(const FlowAction(3, Phone2GlyphMap.c1_10));
              })
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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(children: [
                      Container(
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    width: 2,
                                    color: Colors.white.withOpacity(0.16)))),
                        height: 10.h,
                        child: Row(
                          children: [
                            Expanded(
                              child: isRecording
                                  ? Center(
                                      child: Text("RECORDING",
                                          style: theme.textTheme.bodyLarge))
                                  : Container(),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _controlButton(
                                    "Record", Icons.fiber_manual_record, () {
                                  ref.read(isRecordingProvider.notifier).state =
                                      !isRecording;
                                },
                                    backgroundColor: isRecording
                                        ? theme.colorScheme.secondary
                                        : null),
                                SizedBox(width: 2.w),
                                _controlButton(
                                    "Play", Icons.play_circle, () {}),
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
                      Expanded(
                          child: isRecording
                              ? flowActions.isEmpty
                                  ? Center(
                                      child: Text(
                                          "Start clicking on glyphs to bind actions",
                                          style: theme.textTheme.bodyLarge),
                                    )
                                  : SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(children: flowActionWidgets),
                                    )
                              : Center(
                                  child: Text(
                                      "Actions Graph will show here once you start recording",
                                      textAlign: TextAlign.center,
                                      style: theme.textTheme.bodyLarge)))
                    ]),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
