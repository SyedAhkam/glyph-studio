import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'glyph_mapping.dart';

@immutable
class FlowAction {
  final int seqId;
  final GlyphMap glyph;
  final Offset tapLocation; // this is not (de)serialised

  final Duration duration;
  final int repeatCount;

  const FlowAction(this.seqId, this.glyph, this.tapLocation,
      {this.duration = const Duration(milliseconds: 1000),
      this.repeatCount = 1});

  Map<String, dynamic> toJson() => {
        'seq_id': seqId,
        'glyph': glyph.toString(),
        'duration': duration.toString(),
        'repeat_count': repeatCount
      };
}

@immutable
class Flow {
  final String name;
  final String? author;
  final DateTime createdAt;

  final List<FlowAction> actions;

  const Flow(this.name, this.author, this.createdAt, this.actions);

  get normalizedName => name.toLowerCase().replaceAll(" ", "_");

  Map<String, dynamic> toJson() => {
        'name': name,
        'normalized_name': normalizedName,
        'author': author,
        'created_at': createdAt.toString(),
        'actions': actions.map((a) => a.toJson()).toList()
      };

  Future<String> getLocalPath() async {
    final String appDocumentsDirPath =
        (await getExternalStorageDirectory())!.path;

    final parentDir = Directory("$appDocumentsDirPath/flows");
    if (!parentDir.existsSync()) {
      await parentDir.create();
    }

    return "${parentDir.path}/$normalizedName.json";
  }

  Future<void> saveLocally() async {
    final json = jsonEncode(toJson());
    final path = await getLocalPath();

    await File(path).writeAsString(json);
  }
}
