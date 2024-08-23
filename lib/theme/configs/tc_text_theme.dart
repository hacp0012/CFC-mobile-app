import 'package:cfc_christ/configs/c_constants.dart';
import 'package:flutter/material.dart';

class TcTextTheme {
  TcTextTheme._();

  static TextTheme light = const TextTheme(
    // bodyLarge: TextStyle(fontFamily: 'Figtree'),
    // bodyMedium: TextStyle(fontFamily: 'Rubik', fontWeight: FontWeight.w600),
    // bodySmall: TextStyle(fontFamily: 'Rubik', fontWeight: FontWeight.w400),
    // titleLarge: TextStyle(fontFamily: 'Figtree'),
    // titleMedium: const TextStyle(fontFamily: 'Poppins'),
    // titleSmall: TextStyle(fontFamily: 'Rubik'),
    labelSmall: TextStyle(fontFamily: CConstants.FONT_FAMILY_SECONDARY, color: Colors.black54),
    labelMedium: TextStyle(fontFamily: CConstants.FONT_FAMILY_SECONDARY, color: Colors.black54),
  );
  static TextTheme dark = const TextTheme(
    // bodyLarge: TextStyle(fontFamily: 'Figtree'),
    // bodyMedium: TextStyle(fontFamily: 'Figtree', fontWeight: FontWeight.w600),
    // bodySmall: TextStyle(fontFamily: 'Figtree', fontWeight: FontWeight.w400),
    // titleLarge: TextStyle(fontFamily: 'Figtree'),
    // titleMedium: TextStyle(fontFamily: 'Poppins'),
    // titleSmall: TextStyle(fontFamily: 'Figtree'),
    labelSmall: TextStyle(fontFamily: CConstants.FONT_FAMILY_SECONDARY),
    labelMedium: TextStyle(fontFamily: CConstants.FONT_FAMILY_SECONDARY),
  );
}
