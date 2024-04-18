import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glyph_studio/state/providers.dart';
import 'package:glyph_studio/widgets/appbar.dart';
import 'package:go_router/go_router.dart';

class FlowListRoute extends ConsumerWidget {
  FlowListRoute({super.key});

  @override
  Widget build(BuildContext context, ref) {
    var theme = Theme.of(context);

    var flows = ref.watch(flowsProvider).value!;

    return Scaffold(
      appBar: const AppbarWrapper(title: "Your Flows", actions: []),
      floatingActionButton: FloatingActionButton(
          tooltip: "Create New",
          child: const Icon(Icons.add),
          onPressed: () => context.replace("/flows/create")),
      body: flows.isEmpty
          ? Center(
              child: const Text(
              "No Flows yet!\nCreate one using the + button",
              textAlign: TextAlign.center,
            ))
          : ListView.builder(
              itemBuilder: (context, index) {
                var flow = flows[index];

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
                          onPressed: () {},
                          icon: const Icon(Icons.play_arrow)),
                      IconButton(
                          tooltip: "Delete Flow",
                          color: Colors.grey,
                          onPressed: () {},
                          icon: const Icon(Icons.delete))
                    ],
                  ),
                );
              },
              itemCount: flows.length),
    );
  }
}
