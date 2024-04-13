import 'package:flutter/material.dart';

import 'package:dotted_border/dotted_border.dart';
import 'package:get_it/get_it.dart';
import 'package:glyph_studio/models/glyph_mapping.dart';
import 'package:nothing_glyph_interface/nothing_glyph_interface.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:glyph_studio/models/glyph_set.dart';
import 'package:glyph_studio/models/phone.dart';
import 'package:glyph_studio/widgets/glyph_view.dart';
import 'package:glyph_studio/widgets/drawer_view.dart';

class HomeRoute extends StatefulWidget {
  const HomeRoute({super.key});

  @override
  State<HomeRoute> createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> {
  final _glyphInterface = GetIt.I<NothingGlyphInterface>();

  Phone currentPhone = Phone.unknown;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  _init() async {
    var phone = await Phone.guessCurrentPhone();

    setState(() {
      currentPhone = phone;
    });
  }

  @override
  void initState() {
    super.initState();

    // this doesn't seem to work
    // _glyphInterface.onServiceConnection.listen((connected) {
    //   print("connected: $connected");
    // });

    _init();
  }

  Future<void> onGlyphTap(GlyphMap glyph) async {
    var builder = GlyphFrameBuilder();

    // Choose glyph channel
    if (glyph.group != null) {
      switch (glyph.group) {
        case "d1":
          builder.buildChannelD();
        case "c1": // phone 2 exclusive group
          // had to pull in this hack, to light up everything under c1
          // since buildChannelC() lights up the whole ring
          builder.buildChannel(Phone2GlyphMap.c1_1.idx);
          builder.buildChannel(Phone2GlyphMap.c1_2.idx);
          builder.buildChannel(Phone2GlyphMap.c1_3.idx);
          builder.buildChannel(Phone2GlyphMap.c1_4.idx);
          builder.buildChannel(Phone2GlyphMap.c1_5.idx);
          builder.buildChannel(Phone2GlyphMap.c1_6.idx);
          builder.buildChannel(Phone2GlyphMap.c1_7.idx);
          builder.buildChannel(Phone2GlyphMap.c1_8.idx);
          builder.buildChannel(Phone2GlyphMap.c1_9.idx);
          builder.buildChannel(Phone2GlyphMap.c1_10.idx);
          builder.buildChannel(Phone2GlyphMap.c1_11.idx);
          builder.buildChannel(Phone2GlyphMap.c1_12.idx);
          builder.buildChannel(Phone2GlyphMap.c1_13.idx);
          builder.buildChannel(Phone2GlyphMap.c1_14.idx);
          builder.buildChannel(Phone2GlyphMap.c1_15.idx);
          builder.buildChannel(Phone2GlyphMap.c1_16.idx);
        case "c":
          builder.buildChannelC();
      }
    } else {
      builder.buildChannel(glyph.idx);
    }

    // Set Common properties
    builder.buildPeriod(1000);
    builder.buildCycles(1);

    await _glyphInterface.buildGlyphFrame(builder.build());

    await _glyphInterface.animate();

    await Future.delayed(const Duration(milliseconds: 1000));

    await _glyphInterface.turnOff();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
            centerTitle: true,
            title: Text("GLYPH (STUDIO)", style: theme.textTheme.displaySmall),
            backgroundColor: theme.colorScheme.background,
            actions: [
              IconButton(
                  icon: Text("~", style: theme.textTheme.displaySmall),
                  onPressed: () {
                    // Open end drawer
                    _scaffoldKey.currentState!.openEndDrawer();
                  }),
              const SizedBox(width: 8)
            ],
            shape: Border(
                bottom: BorderSide(color: Colors.white.withOpacity(0.33)))),
        endDrawer: Drawer(
            //surfaceTintColor: theme.colorScheme.surface.withOpacity(0),
            backgroundColor: theme.colorScheme.surface.withOpacity(0.95),
            child: const DrawerView()),
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

                          return GlyphView(
                              glyphSet: snapshot.data!, onGlyphTap: onGlyphTap);
                        })
                    : const Center(child: Text("Unsupported Device, sorry!")),
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
                              child: Text(
                                  "Running on ${currentPhone.formattedName}",
                                  style: theme.textTheme.headlineMedium!
                                      .copyWith(
                                          color:
                                              Colors.white.withOpacity(0.82))),
                            ),
                          ),
                          Text(
                              "${currentPhone != Phone.unknown ? currentPhone.calculateTotalZones : '0'} Glyph Zones Available",
                              style: theme.textTheme.headlineSmall!
                                  .copyWith(color: theme.colorScheme.secondary))
                        ],
                      )),
                ),
              )
            ],
          ),
        ));
  }
}
