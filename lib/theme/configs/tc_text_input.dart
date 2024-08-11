import 'package:cfc_christ/configs/c_constants.dart';
import 'package:cfc_christ/theme/configs/rc_color_sheme.dart';
import 'package:flutter/material.dart';

class TcTextInput {
  static InputDecorationTheme light = InputDecorationTheme(
    isDense: true,
    filled: true,
    fillColor: TcColorScheme.light.primaryContainer,
    contentPadding: const EdgeInsets.all(5.4),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(CConstants.DEFAULT_RADIUS / 2),
      borderSide: BorderSide.none,
      gapPadding: 1.0,
    ),
    hintStyle: const TextStyle(
      fontSize: (CConstants.GOLDEN_SIZE * 2) - 3,
      fontWeight: FontWeight.w300,
      fontFamily: CConstants.FONT_FAMILY_SECONDARY,
    ),
  );

  static InputDecorationTheme dark = InputDecorationTheme(
    isDense: true,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(CConstants.DEFAULT_RADIUS / 2)),
    contentPadding: const EdgeInsets.all(5.4),
    hintStyle: const TextStyle(
      fontSize: (CConstants.GOLDEN_SIZE * 2) - 3,
      fontWeight: FontWeight.w300,
      fontFamily: CConstants.FONT_FAMILY_SECONDARY,
    ),
  );
}
