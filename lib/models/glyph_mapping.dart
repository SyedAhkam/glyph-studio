enum Phone1GlyphMap {
  a1(0),
  b1(1),
  c1(2),
  c2(3),
  c3(4),
  c4(5),
  e1(6),
  d1_1(7),
  d1_2(8),
  d1_3(9),
  d1_4(10),
  d1_5(11),
  d1_6(12),
  d1_7(13),
  d1_8(14);

  final int idx;
  const Phone1GlyphMap(this.idx);

  static Phone1GlyphMap? fromIndex(int index) {
    try {
      return Phone1GlyphMap.values.firstWhere((e) => e.idx == index);
    } catch (_) {
      return null;
    }
  }
}

enum Phone2GlyphMap {
  a1(0),
  a2(1),
  b1(2),
  c1_1(3),
  c1_2(4),
  c1_3(5),
  c1_4(6),
  c1_5(7),
  c1_6(8),
  c1_7(9),
  c1_8(10),
  c1_9(11),
  c1_10(12),
  c1_11(13),
  c1_12(14),
  c1_13(15),
  c1_14(16),
  c1_15(17),
  c1_16(18),
  c2(19),
  c3(20),
  c4(21),
  c5(22),
  c6(23),
  e1(24),
  d1_1(25),
  d1_2(26),
  d1_3(27),
  d1_4(28),
  d1_5(29),
  d1_6(30),
  d1_7(31),
  d1_8(32);

  final int idx;
  const Phone2GlyphMap(this.idx);

  static Phone2GlyphMap? fromIndex(int index) {
    try {
      return Phone2GlyphMap.values.firstWhere((e) => e.idx == index);
    } catch (_) {
      return null;
    }
  }
}

enum Phone2aGlyphMap {
  c1(0),
  c2(1),
  c3(2),
  c4(3),
  c5(4),
  c6(5),
  c7(6),
  c8(7),
  c9(8),
  c10(9),
  c11(10),
  c12(11),
  c13(12),
  c14(13),
  c15(14),
  c16(15),
  c17(16),
  c18(17),
  c19(18),
  c20(19),
  c21(20),
  c22(21),
  c23(22),
  c24(23),
  b(24),
  a(25);

  final int idx;
  const Phone2aGlyphMap(this.idx);

  static Phone2aGlyphMap? fromIndex(int index) {
    try {
      return Phone2aGlyphMap.values.firstWhere((e) => e.idx == index);
    } catch (_) {
      return null;
    }
  }
}
