import 'package:flutter/services.dart';
import 'package:glyph_studio/models/glyph_mapping.dart';

import 'package:xml/xml.dart';

import 'package:glyph_studio/gen/assets.gen.dart';

import 'phone.dart';

class GlyphSet {
  String svgString;
  Phone phone;

  late double viewBoxHeight;
  late double viewBoxWidth;

  List<(GlyphMap, String)> pathDefs = [];

  GlyphSet(this.svgString, this.phone) {
    XmlDocument document = XmlDocument.parse(svgString);

    final svgElement = document.getElement('svg')!;
    final paths = document.findAllElements('path');

    viewBoxHeight = double.parse(svgElement.getAttribute('height')!);
    viewBoxWidth = double.parse(svgElement.getAttribute('width')!);

    for (var path in paths) {
      final id = path.getAttribute('id')!;
      final d = path.getAttribute('d')!;

      final glyph = GlyphMap.fromGlyphId(phone, id);

      pathDefs.add((glyph, d));
    }
  }

  static getSvgPath(Phone phone) {
    switch (phone) {
      case Phone.phone1:
        return Assets.images.glyphs.phone1Glyphs;
      case Phone.phone2:
        return Assets.images.glyphs.phone2Glyphs;
      case Phone.phone2a:
        return Assets.images.glyphs.phone2aGlyphs;
      default:
        throw UnimplementedError();
    }
  }

  static Future<GlyphSet> load(Phone phone) async {
    assert(phone != Phone.unknown);

    var svg = await rootBundle.loadString(getSvgPath(phone));

    return GlyphSet(svg, phone);
  }
}
