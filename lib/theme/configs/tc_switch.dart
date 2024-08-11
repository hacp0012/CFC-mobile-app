import 'package:cfc_christ/theme/configs/rc_color_sheme.dart';
import 'package:flutter/material.dart';

class TcSwitch {
  static SwitchThemeData light = const SwitchThemeData().copyWith(
    trackOutlineWidth: const WidgetStatePropertyAll(0),
    // trackOutlineColor: WidgetStatePropertyAll(TcColorScheme.light.primaryContainer),
    trackColor: WidgetStatePropertyAll(TcColorScheme.light.primaryContainer),
    overlayColor: WidgetStatePropertyAll(TcColorScheme.light.primary),
  );

  static SwitchThemeData dark = const SwitchThemeData().copyWith(
    trackOutlineWidth: const WidgetStatePropertyAll(0),
    // trackOutlineColor: WidgetStatePropertyAll(TcColorScheme.light.primaryContainer),
    // trackColor: WidgetStatePropertyAll(TcColorScheme.dark.primaryContainer),
    // overlayColor: WidgetStatePropertyAll(TcColorScheme.dark.primary),
  );
}
