import 'package:flutter/material.dart';

class TcTextTheme {
  TcTextTheme._();

  static TextTheme light = TextTheme(
    // bodyLarge: TextStyle(fontFamily: 'Figtree'),
    // bodyMedium: TextStyle(fontFamily: 'Rubik', fontWeight: FontWeight.w600),
    // bodySmall: TextStyle(fontFamily: 'Rubik', fontWeight: FontWeight.w400),
    // titleLarge: TextStyle(fontFamily: 'Figtree'),
    // titleMedium: const TextStyle(fontFamily: 'Poppins'),
    // titleSmall: TextStyle(fontFamily: 'Rubik'),
    labelSmall: TextStyle(color: Colors.grey.shade800),
  );
  static TextTheme dark = const TextTheme(
      // bodyLarge: TextStyle(fontFamily: 'Figtree'),
      // bodyMedium: TextStyle(fontFamily: 'Figtree', fontWeight: FontWeight.w600),
      // bodySmall: TextStyle(fontFamily: 'Figtree', fontWeight: FontWeight.w400),
      // titleLarge: TextStyle(fontFamily: 'Figtree'),
      // titleMedium: TextStyle(fontFamily: 'Poppins'),
      // titleSmall: TextStyle(fontFamily: 'Figtree'),
      );
}
