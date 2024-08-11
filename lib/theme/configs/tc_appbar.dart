import 'package:cfc_christ/theme/configs/rc_color_sheme.dart';
import 'package:flutter/material.dart';

class TcAppbar {
  static AppBarTheme light = AppBarTheme(
    color: TcColorScheme.light.primaryContainer,
    // color: TcColorScheme.light.primary,
    // color: CConstants.PRIMARY_COLOR,
    // foregroundColor: TcColorScheme.light.surface,
  );

  static AppBarTheme dark = const AppBarTheme(
    color: Color(0xFF2E2F33),
  );
}
