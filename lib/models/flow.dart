import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'package:glyph_studio/models/phone.dart';
import 'glyph_mapping.dart';

@immutable
class FlowAction {
  final int seqId;
  final GlyphMap glyph;

  final Offset? tapLocation; // this is not (de)serialised

  final Duration duration;
  final int repeatCount;

  const FlowAction(this.seqId, this.glyph, this.tapLocation,
      {this.duration = const Duration(milliseconds: 1000),
      this.repeatCount = 1});

  Map<String, dynamic> toJson() => {
        'seq_id': seqId,
        'glyph_idx': glyph.idx,
        'duration_ms': duration.inMilliseconds,
        'repeat_count': repeatCount
      };

  static FlowAction fromJson(Map<String, dynamic> map, Phone phone) {
    return FlowAction(
        map['seq_id'], GlyphMap.fromIndex(phone, map['glyph_idx']), null,
        duration: Duration(milliseconds: map['duration_ms']),
        repeatCount: map['repeat_count']);
  }
}

@immutable
class Flow {
  final String name;
  final DateTime createdAt;
  final Phone phone;
  final String? author;

  final List<FlowAction> actions;

  const Flow(this.name, this.createdAt, this.phone, this.actions,
      {this.author});

  static Future<Directory> getLocalFlowsDir() async {
    final String appDocumentsDirPath =
        (await getExternalStorageDirectory())!.path;

    final parentDir = Directory("$appDocumentsDirPath/flows");
    if (!parentDir.existsSync()) {
      await parentDir.create();
    }

    return parentDir;
  }

  static Flow fromJson(Map<String, dynamic> json) {
    var phone = Phone.fromIndex(json['phone']);

    return Flow(
      json['name'],
      DateTime.parse(json['created_at']),
      phone,
      (json['actions'] as List)
          .map((a) => FlowAction.fromJson(a, phone))
          .toList(),
      author: json['author'],
    );
  }

  get normalizedName => name.toLowerCase().replaceAll(" ", "_");

  Map<String, dynamic> toJson() => {
        'name': name,
        'normalized_name': normalizedName,
        'created_at': createdAt.toString(),
        'phone': phone.idx,
        'actions': actions.map((a) => a.toJson()).toList(),
        'author': author,
      };

  Future<void> saveLocally() async {
    final json = jsonEncode(toJson());
    final flowsDir = await getLocalFlowsDir();

    await File("${flowsDir.path}/$normalizedName.json").writeAsString(json);
  }
}
