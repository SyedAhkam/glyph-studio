import 'package:flutter/material.dart' hide Flow;

import 'package:date_format/date_format.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:glyph_studio/state/notifiers.dart';
import 'package:go_router/go_router.dart';

import 'package:glyph_studio/glyph_player.dart';
import 'package:glyph_studio/state/providers.dart';
import 'package:glyph_studio/widgets/appbar.dart';
import 'package:glyph_studio/models/flow.dart';

class FlowListRoute extends ConsumerWidget {
  FlowListRoute({super.key});

  final glyphPlayer = GetIt.I<GlyphPlayer>();

  void playFlow(BuildContext context, Flow flow) async {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Playing: '${flow.normalizedName}'")));

    await glyphPlayer.playFlow(flow);

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Done Playing")));
  }

  void deleteFlow(
      BuildContext context, FlowsNotifier flowsNotifier, Flow flow) {
    flowsNotifier.delete(flow.name).then((_) => {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Deleted Flow")))
        });
  }

  @override
  Widget build(BuildContext context, ref) {
    var theme = Theme.of(context);

    var flows = ref.watch(flowsProvider).value;
    var flowsNotifier = ref.watch(flowsProvider.notifier);

    return Scaffold(
      appBar: const AppbarWrapper(title: "YOUR FLOWS", actions: []),
      floatingActionButton: FloatingActionButton(
          tooltip: "Create New",
          child: const Icon(Icons.add),
          onPressed: () => context.replace("/flows/create")),
      body: flows != null && flows.isEmpty
          ? Center(
              child: const Text(
              "No Flows yet!\nCreate one using the + button",
              textAlign: TextAlign.center,
            ))
          : ListView.builder(
              itemBuilder: (context, index) {
                var flow = flows![index];

                return ListTile(
                  onTap: () {},
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  title: Text(flow.name),
                  subtitle: Text(formatDate(flow.createdAt, [dd, ' ', MM]),
                      style: TextStyle(color: Colors.white.withOpacity(0.64))),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          tooltip: "Play Flow",
                          color: theme.colorScheme.secondary,
                          onPressed: () => playFlow(context, flow),
                          icon: const Icon(Icons.play_arrow)),
                      IconButton(
                          tooltip: "Delete Flow",
                          color: Colors.grey,
                          onPressed: () =>
                              deleteFlow(context, flowsNotifier, flow),
                          icon: const Icon(Icons.delete))
                    ],
                  ),
                );
              },
              itemCount: flows?.length),
    );
  }
}
