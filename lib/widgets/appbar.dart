import 'package:flutter/material.dart';

class AppbarWrapper extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget> actions;

  const AppbarWrapper({super.key, required this.title, required this.actions});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return AppBar(
        centerTitle: true,
        title: Text(title, style: theme.textTheme.displaySmall),
        backgroundColor: theme.colorScheme.background,
        actions: actions,
        shape: Border(
            bottom: BorderSide(color: theme.dividerColor.withOpacity(0.33))));
  }

  @override
  Size get preferredSize => AppBar().preferredSize;
}
