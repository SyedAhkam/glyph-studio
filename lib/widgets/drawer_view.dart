import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

class DrawerView extends StatelessWidget {
  const DrawerView({super.key});

  Widget listSection(String? name, List<Widget> items, ThemeData theme,
      {bool borderTop = true}) {
    var borderColor = theme.dividerColor;

    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        width: double.infinity,
        decoration: BoxDecoration(
            border: borderTop
                ? Border(top: BorderSide(color: borderColor.withOpacity(0.16)))
                : null),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          name != null
              ? Padding(
                  padding: EdgeInsets.only(bottom: 1.h),
                  child: Text(name,
                      style: theme.textTheme.titleMedium!
                          .copyWith(decoration: TextDecoration.underline)),
                )
              : Container(),
          Column(children: items)
        ]));
  }

  Widget listTile(String title, ThemeData theme,
      {IconData? icon, VoidCallback? onTap}) {
    var textColor = theme.textTheme.titleLarge!.color!;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      onTap:
          onTap ?? () {}, // without an onTap, the ripple animations dont show
      title: Text(title,
          style: theme.textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.w200, color: textColor.withOpacity(0.64))),
      trailing: Icon(icon ?? Icons.arrow_right),
    );
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return SafeArea(
      child: Column(
        children: [
          Container(
              alignment: AlignmentDirectional.center,
              height: AppBar().preferredSize.height,
              width: double.infinity,
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: theme.dividerColor.withOpacity(0.16)))),
              child: Text("Advanced", style: theme.textTheme.displaySmall)),
          Expanded(
            child: Column(children: [
              listSection(
                  "Flows",
                  [
                    listTile("Your Flows", theme,
                        onTap: () => context.push("/flows")),
                    listTile("Create New", theme,
                        icon: Icons.add,
                        onTap: () => context.push("/flows/create"))
                  ],
                  theme,
                  borderTop: false),
              listSection(
                  null,
                  [
                    listTile("Preferences", theme,
                        onTap: () => context.push("/prefs"))
                  ],
                  theme),
              listSection(
                  null,
                  [
                    listTile("Open Source Licenses", theme,
                        onTap: () => context.push("/oss"))
                  ],
                  theme),
            ]),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            alignment: AlignmentDirectional.center,
            decoration: BoxDecoration(
                border: Border(
                    top: BorderSide(
                        color: theme.dividerColor.withOpacity(0.33)))),
            child: Column(children: [
              Text.rich(
                TextSpan(children: [
                  TextSpan(
                      text: "GLYPH (STUDIO)", style: theme.textTheme.bodyLarge),
                  const TextSpan(text: " is a community project;"),
                ]),
                textAlign: TextAlign.center,
              ),
              Text("~", style: theme.textTheme.bodyLarge),
              Text.rich(TextSpan(children: [
                const TextSpan(text: "We are not affiliated with"),
                TextSpan(text: " Nothing", style: theme.textTheme.bodyLarge),
                const TextSpan(text: "™"),
              ]))
            ]),
          )
        ],
      ),
    );
  }
}
