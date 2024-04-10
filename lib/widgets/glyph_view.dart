import 'dart:math';

import 'package:flutter/material.dart';
import 'package:svg_path_parser/svg_path_parser.dart';

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

class GlyphView extends StatefulWidget {
  final GlyphSet glyphSet;
  final Function(GlyphMap) onGlyphTap;

  const GlyphView(
      {super.key, required this.glyphSet, required this.onGlyphTap});

  @override
  State<GlyphView> createState() => _GlyphViewState();
}

class _GlyphViewState extends State<GlyphView> {
  GlyphMap? highlightedGlyph;

  @override
  Widget build(BuildContext context) {
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
                    onTap: () => widget.onGlyphTap(def.$1),
                    child: Container(
                      color: Colors.grey,
                    )));
          }).toList(),
        );
      }),
    );
  }
}
