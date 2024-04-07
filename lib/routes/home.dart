import 'package:flutter/material.dart';

class HomeRoute extends StatelessWidget {
  const HomeRoute({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            title: Text("GLYPH (STUDIO)", style: theme.textTheme.displaySmall),
            actions: [
              IconButton(
                  icon: Text("~", style: theme.textTheme.displaySmall),
                  onPressed: () {}),
              const SizedBox(width: 8)
            ],
            shape: Border(
                bottom: BorderSide(color: Colors.white.withOpacity(0.33)))),
        body: const Center(child: Text("Hello")));
  }
}
