import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:glyph_studio/models/glyph_set.dart';
import 'package:glyph_studio/widgets/glyph_view.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:glyph_studio/gen/assets.gen.dart';

class HomeRoute extends StatelessWidget {
  const HomeRoute({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            title: Text("GLYPH (STUDIO)", style: theme.textTheme.displaySmall),
            backgroundColor: theme.colorScheme.background,
            actions: [
              IconButton(
                  icon: Text("~", style: theme.textTheme.displaySmall),
                  onPressed: () {}),
              const SizedBox(width: 8)
            ],
            shape: Border(
                bottom: BorderSide(color: Colors.white.withOpacity(0.33)))),
        body: Container(
          width: 100.w,
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: FutureBuilder<GlyphSet>(
                    future: GlyphSet.load(Phone.phone1),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      return GlyphView(glyphSet: snapshot.data!);
                    }),
              ),
              SizedBox(height: 4.h),
              SizedBox(
                height: 16.h,
                width: 100.w,
                child: Card.filled(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(24))),
                  child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          DottedBorder(
                            color: Colors.white,
                            customPath: (size) {
                              return Path()
                                ..moveTo(0, 40)
                                ..lineTo(size.width, 40);
                            },
                            child: SizedBox(
                              child: Text("Running on Phone (2)",
                                  style: theme.textTheme.headlineMedium!
                                      .copyWith(
                                          color:
                                              Colors.white.withOpacity(0.82))),
                            ),
                          ),
                          Text("5 Glyph Zones Available",
                              style: theme.textTheme.headlineSmall!
                                  .copyWith(color: const Color(0xFFC8102E)))
                        ],
                      )),
                ),
              )
            ],
          ),
        ));
  }
}
