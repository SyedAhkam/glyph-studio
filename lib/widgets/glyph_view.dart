import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:svg_path_parser/svg_path_parser.dart';

import 'package:glyph_studio/gen/assets.gen.dart';
import 'package:glyph_studio/state/providers.dart';
import 'package:glyph_studio/models/app_prefs.dart';
import 'package:glyph_studio/models/glyph_set.dart';
import 'package:glyph_studio/models/glyph_mapping.dart';

class Clipper extends CustomClipper<Path> {
  Clipper(
      {required this.path,
      required this.originalHeight,
      required this.originalWidth});

  Path path;

  // This helps us scale according to the svg viewBox size
  double originalHeight;
  double originalWidth;

  @override
  Path getClip(Size size) {
    // Calculate scale factors for width and height
    final scaleX = size.width / originalWidth;
    final scaleY = size.height / originalHeight;

    // Use the minimum scale to ensure aspect ratio preservation
    final scale = min(scaleX, scaleY);

    // Centering the canvas
    final dx = (size.width - (originalWidth * scale)) / 2;
    final dy = (size.height - (originalHeight * scale)) / 2;

    final Matrix4 matrix4 = Matrix4.identity();

    matrix4.scale(scale);

    return path.transform(matrix4.storage).shift(Offset(dx, dy));
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return false;
  }
}

class GlyphView extends ConsumerStatefulWidget {
  final GlyphSet glyphSet;
  final Future<void> Function(GlyphMap)? onGlyphTap;
  final Future<void> Function(TapDownDetails, GlyphMap)? onGlyphTapDown;
  final Future<void> Function(GlyphMap)? onGlyphLongPressStart;
  final Future<void> Function(GlyphMap)? onGlyphLongPressEnd;

  const GlyphView(
      {super.key,
      required this.glyphSet,
      this.onGlyphTap,
      this.onGlyphTapDown,
      this.onGlyphLongPressStart,
      this.onGlyphLongPressEnd});

  @override
  ConsumerState<GlyphView> createState() => _GlyphViewState();
}

class _GlyphViewState extends ConsumerState<GlyphView> {
  final player = AudioPlayer();

  GlyphMap? highlightedGlyph;
  AppPrefs? appPrefs;

  @override
  void initState() {
    super.initState();

    appPrefs = (ref.read(appPrefsProvider)).value;

    player.audioCache = AudioCache(prefix: ''); // remove asset prefix
    player.setSourceAsset(Assets.sounds.a);
    player.setPlayerMode(PlayerMode.lowLatency);
    player.setReleaseMode(ReleaseMode.stop);
  }

  void processTap(GlyphMap glyph) async {
    // Set highlightedGlyph
    setState(() => highlightedGlyph = glyph);

    // Trigger haptics
    if (appPrefs!.enableHaptics) await HapticFeedback.selectionClick();

    // Play sound
    await player.resume();

    // Redirect control to parent widget
    await widget.onGlyphTap?.call(glyph);

    // When function returns, we reset the highlighted glyph
    setState(() => highlightedGlyph = null);

    // reset player position
    await player.stop();
  }

  void processTapDown(TapDownDetails details, GlyphMap glyph) async {
    // Set highlightedGlyph
    setState(() => highlightedGlyph = glyph);

    // Trigger haptics
    if (appPrefs!.enableHaptics) await HapticFeedback.selectionClick();

    // Play sound
    await player.resume();

    // Redirect control to parent widget
    await widget.onGlyphTapDown?.call(details, glyph);

    // When function returns, we reset the highlighted glyph
    setState(() => highlightedGlyph = null);

    // reset player position
    await player.stop();
  }

  void processLongPressStart(GlyphMap glyph) async {
    print("Holding ${glyph}");

    // We are only concerned with groups here
    if (glyph.group == null) return;

    // Set highlightedGlyph
    setState(() => highlightedGlyph = glyph);

    // Trigger haptics
    if (appPrefs!.enableHaptics) await HapticFeedback.heavyImpact();

    // Redirect control to parent widget
    await widget.onGlyphLongPressStart?.call(glyph);
  }

  void processLongPressEnd(GlyphMap glyph) async {
    // We are only concerned with groups here
    if (glyph.group == null) return;

    // Trigger haptics
    if (appPrefs!.enableHaptics) await HapticFeedback.mediumImpact();

    // Redirect control to parent widget
    await widget.onGlyphLongPressEnd?.call(glyph);

    // When function returns, we reset the highlighted glyph
    setState(() => highlightedGlyph = null);
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Center(
      child: LayoutBuilder(builder: (context, constraints) {
        return Stack(
          children: widget.glyphSet.pathDefs.map((def) {
            var parsedPath = parseSvgPath(def.$2);

            return ClipPath(
                clipper: Clipper(
                    path: parsedPath,
                    originalHeight: widget.glyphSet.viewBoxHeight,
                    originalWidth: widget.glyphSet.viewBoxWidth),
                child: GestureDetector(
                    onTap: () =>
                        widget.onGlyphTap != null ? processTap(def.$1) : null,
                    onTapDown: (details) => widget.onGlyphTapDown != null
                        ? processTapDown(details, def.$1)
                        : null,
                    onLongPressStart: (_) => processLongPressStart(def.$1),
                    onLongPressEnd: (_) => processLongPressEnd(def.$1),
                    child: Container(
                      color: highlightedGlyph == def.$1
                          ? theme.colorScheme.secondary
                          : Colors.grey,
                    )));
          }).toList(),
        );
      }),
    );
  }
}
