import 'package:flutter/material.dart';

import 'glyph_mapping.dart';

@immutable
class FlowAction {
  final int id;
  final GlyphMap glyph;
  final Duration duration;
  final int repeatCount;

  const FlowAction(this.id, this.glyph,
      {this.duration = const Duration(milliseconds: 1000),
      this.repeatCount = 1});
}

@immutable
class Flow {
  final String name;
  final String author;
  final DateTime createdAt;

  final List<FlowAction> actions;

  const Flow(this.name, this.author, this.createdAt, this.actions);
}
