import 'package:get_it/get_it.dart';

import 'package:nothing_glyph_interface/nothing_glyph_interface.dart';

import 'glyph_mapping.dart';

enum Phone {
  phone1,
  phone2,
  phone2a,
  unknown;

  String get formattedName {
    switch (this) {
      case Phone.phone1:
        return "Phone (1)";

      case Phone.phone2:
        return "Phone (2)";

      case Phone.phone2a:
        return "Phone (2a)";

      default:
        return "Unsupported";
    }
  }

  int get calculateTotalZones {
    switch (this) {
      case Phone.phone1:
        return Phone1GlyphMap.values.length;

      case Phone.phone2:
        return Phone2GlyphMap.values.length;

      case Phone.phone2a:
        return Phone2aGlyphMap.values.length;

      default:
        throw UnimplementedError();
    }
  }

  static Future<Phone> guessCurrentPhone() async {
    final glyphInterface = GetIt.I<NothingGlyphInterface>();

    var isPhone1 = (await glyphInterface.is20111())!;
    var isPhone2 = (await glyphInterface.is22111())!;
    var isPhone2a = (await glyphInterface.is23111())!;

    if (isPhone1) {
      return Phone.phone1;
    }

    if (isPhone2) {
      return Phone.phone2;
    }

    if (isPhone2a) {
      return Phone.phone2a;
    }

    return Phone.unknown;
  }
}
