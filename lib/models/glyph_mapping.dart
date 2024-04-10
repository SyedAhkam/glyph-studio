import 'phone.dart';

sealed class GlyphMap {
  final int idx;
  final String? group;

  const GlyphMap(this.idx, {this.group});

  static GlyphMap fromGlyphId(Phone phone, String id) {
    if (phone == Phone.phone1) {
      return Phone1GlyphMap.fromGlyphId(id);
    }

    if (phone == Phone.phone2) {
      return Phone2GlyphMap.fromGlyphId(id);
    }

    if (phone == Phone.phone2a) {
      return Phone2aGlyphMap.fromGlyphId(id);
    }

    throw UnimplementedError();
  }
}

enum Phone1GlyphMap implements GlyphMap {
  a1(0),
  b1(1),
  c1(2),
  c2(3),
  c3(4),
  c4(5),
  e1(6),
  d1_1(7, group: 'd1'),
  d1_2(8, group: 'd1'),
  d1_3(9, group: 'd1'),
  d1_4(10, group: 'd1'),
  d1_5(11, group: 'd1'),
  d1_6(12, group: 'd1'),
  d1_7(13, group: 'd1'),
  d1_8(14, group: 'd1');

  @override
  final int idx;
  @override
  final String? group;

  const Phone1GlyphMap(this.idx, {this.group});

  // Try normally first
  static Phone1GlyphMap fromGlyphId(String glyphId) {
    try {
      return Phone1GlyphMap.values.byName(glyphId);
    } catch (e) {
      // when that fails, there is a possibility of a group
      // in the svg, IDs are exclusive of group position
      // eg. d1_1 is just d1 in the svg.
      // for now we just return the first element
      return Phone1GlyphMap.values.firstWhere((e) => e.group == glyphId);
    }
  }

  static Phone1GlyphMap? fromIndex(int index) {
    try {
      return Phone1GlyphMap.values.firstWhere((e) => e.idx == index);
    } catch (_) {
      return null;
    }
  }
}

enum Phone2GlyphMap implements GlyphMap {
  a1(0),
  a2(1),
  b1(2),
  c1_1(3, group: 'c1'),
  c1_2(4, group: 'c1'),
  c1_3(5, group: 'c1'),
  c1_4(6, group: 'c1'),
  c1_5(7, group: 'c1'),
  c1_6(8, group: 'c1'),
  c1_7(9, group: 'c1'),
  c1_8(10, group: 'c1'),
  c1_9(11, group: 'c1'),
  c1_10(12, group: 'c1'),
  c1_11(13, group: 'c1'),
  c1_12(14, group: 'c1'),
  c1_13(15, group: 'c1'),
  c1_14(16, group: 'c1'),
  c1_15(17, group: 'c1'),
  c1_16(18, group: 'c1'),
  c2(19),
  c3(20),
  c4(21),
  c5(22),
  c6(23),
  e1(24),
  d1_1(25, group: 'd1'),
  d1_2(26, group: 'd1'),
  d1_3(27, group: 'd1'),
  d1_4(28, group: 'd1'),
  d1_5(29, group: 'd1'),
  d1_6(30, group: 'd1'),
  d1_7(31, group: 'd1'),
  d1_8(32, group: 'd1');

  @override
  final int idx;
  @override
  final String? group;

  const Phone2GlyphMap(this.idx, {this.group});

  static Phone2GlyphMap fromGlyphId(String glyphId) {
    try {
      return Phone2GlyphMap.values.byName(glyphId);
    } catch (e) {
      return Phone2GlyphMap.values.firstWhere((e) => e.group == glyphId);
    }
  }

  static Phone2GlyphMap? fromIndex(int index) {
    try {
      return Phone2GlyphMap.values.firstWhere((e) => e.idx == index);
    } catch (_) {
      return null;
    }
  }
}

enum Phone2aGlyphMap implements GlyphMap {
  c1(0, group: 'c'),
  c2(1, group: 'c'),
  c3(2, group: 'c'),
  c4(3, group: 'c'),
  c5(4, group: 'c'),
  c6(5, group: 'c'),
  c7(6, group: 'c'),
  c8(7, group: 'c'),
  c9(8, group: 'c'),
  c10(9, group: 'c'),
  c11(10, group: 'c'),
  c12(11, group: 'c'),
  c13(12, group: 'c'),
  c14(13, group: 'c'),
  c15(14, group: 'c'),
  c16(15, group: 'c'),
  c17(16, group: 'c'),
  c18(17, group: 'c'),
  c19(18, group: 'c'),
  c20(19, group: 'c'),
  c21(20, group: 'c'),
  c22(21, group: 'c'),
  c23(22, group: 'c'),
  c24(23, group: 'c'),
  b(24),
  a(25);

  @override
  final int idx;
  @override
  final String? group;

  const Phone2aGlyphMap(this.idx, {this.group});

  static Phone2aGlyphMap fromGlyphId(String glyphId) {
    try {
      return Phone2aGlyphMap.values.byName(glyphId);
    } catch (e) {
      return Phone2aGlyphMap.values.firstWhere((e) => e.group == glyphId);
    }
  }

  static Phone2aGlyphMap? fromIndex(int index) {
    try {
      return Phone2aGlyphMap.values.firstWhere((e) => e.idx == index);
    } catch (_) {
      return null;
    }
  }
}
