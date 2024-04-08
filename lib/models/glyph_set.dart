import 'dart:ui';

import 'package:flutter/services.dart';

import 'package:xml/xml.dart';

import 'package:glyph_studio/gen/assets.gen.dart';

enum Phone { phone1, phone2, phone2a }

class GlyphSet {
  String svgString;
  Phone phone;

  late double viewBoxHeight;
  late double viewBoxWidth;
  List<String> pathDefs = [];

  GlyphSet(this.svgString, this.phone) {
    XmlDocument document = XmlDocument.parse(svgString);

    final svgElement = document.getElement('svg')!;
    final paths = document.findAllElements('path');

    viewBoxHeight = double.parse(svgElement.getAttribute('height')!);
    viewBoxWidth = double.parse(svgElement.getAttribute('width')!);

    for (var path in paths) {
      final d = path.getAttribute('d')!;

      pathDefs.add(d);
    }
  }

  static getSvgPath(Phone phone) {
    switch (phone) {
      case Phone.phone1:
        return Assets.images.glyphs.phone1Glyphs.path;
      case Phone.phone2:
        return Assets.images.glyphs.phone2Glyphs.path;
      case Phone.phone2a:
        return Assets.images.glyphs.phone2aGlyphs.path;
      default:
        throw UnimplementedError();
    }
  }

  static Future<GlyphSet> load(Phone phone) async {
    var svg = await rootBundle.loadString(getSvgPath(phone));

    return GlyphSet(svg, phone);
  }
}
