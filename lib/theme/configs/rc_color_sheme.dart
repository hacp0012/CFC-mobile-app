import 'package:cfc_christ/configs/c_constants.dart';
import 'package:flutter/material.dart';

class TcColorScheme {
  TcColorScheme._();

  static ColorScheme light = ColorScheme.fromSeed(
    seedColor: CConstants.PRIMARY_COLOR,
    secondary: CConstants.SECONDARY_COLOR,
    // primary: CConstants.PRIMARY_COLOR,
  );

  static ColorScheme dark = const ColorScheme.dark(
    brightness: Brightness.dark,
    // secondary: Color(0xFF0A2642),
    secondary: CConstants.PRIMARY_COLOR,
    primary: CConstants.PRIMARY_COLOR,
  );
}
