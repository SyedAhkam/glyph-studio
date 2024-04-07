import 'package:flutter/material.dart';

class HomeRoute extends StatelessWidget {
  const HomeRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("GLYPH STUDIO"),
          actions: const [Text("~"), SizedBox(width: 24)],
        ),
        body: const Center(child: Text("Hello")));
  }
}
