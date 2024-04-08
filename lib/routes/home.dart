import 'package:flutter/material.dart';

import 'package:dotted_border/dotted_border.dart';
import 'package:get_it/get_it.dart';
import 'package:glyph_studio/models/glyph_mapping.dart';
import 'package:nothing_glyph_interface/nothing_glyph_interface.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:glyph_studio/models/glyph_set.dart';
import 'package:glyph_studio/models/phone.dart';
import 'package:glyph_studio/widgets/glyph_view.dart';

class HomeRoute extends StatefulWidget {
  const HomeRoute({super.key});

  @override
  State<HomeRoute> createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> {
  final _glyphInterface = GetIt.I<NothingGlyphInterface>();

  Phone currentPhone = Phone.unknown;

  _init() async {
    var phone = await Phone.guessCurrentPhone();

    setState(() {
      currentPhone = phone;
    });
  }

  @override
  void initState() {
    super.initState();

    _glyphInterface.onServiceConnection.listen((connected) {
      print("connected: $connected");
    });

    _init();
  }

  doSomething() async {
    await _glyphInterface.buildGlyphFrame(GlyphFrameBuilder()
        .buildChannelB()
        .buildChannel(Phone2GlyphMap.c1_3.idx)
        .buildPeriod(2000)
        .buildCycles(3)
        .buildInterval(1000)
        .build());

    await _glyphInterface.animate();
  }

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
                child: currentPhone != Phone.unknown
                    ? FutureBuilder<GlyphSet>(
                        future: GlyphSet.load(currentPhone),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          return GlyphView(glyphSet: snapshot.data!);
                        })
                    : const Center(child: Text("Unsupported Device, sorry!")),
              ),
              SizedBox(height: 4.h),
              ElevatedButton(onPressed: doSomething, child: const Text("Test")),
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
                              child: Text(
                                  "Running on ${currentPhone.formattedName}",
                                  style: theme.textTheme.headlineMedium!
                                      .copyWith(
                                          color:
                                              Colors.white.withOpacity(0.82))),
                            ),
                          ),
                          Text(
                              "${currentPhone.calculateTotalZones} Glyph Zones Available",
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
