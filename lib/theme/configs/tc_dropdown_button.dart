import 'package:cfc_christ/configs/c_constants.dart';
import 'package:cfc_christ/theme/configs/rc_color_sheme.dart';
import 'package:flutter/material.dart';

class TcDropdownButton {
  static DropdownMenuThemeData light = DropdownMenuThemeData(
    inputDecorationTheme: InputDecorationTheme(
      isDense: true,
      filled: true,
      fillColor: TcColorScheme.light.primaryContainer,
      contentPadding: const EdgeInsets.symmetric(horizontal: CConstants.GOLDEN_SIZE / 2),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(CConstants.DEFAULT_RADIUS / 2),
        borderSide: BorderSide.none,
        gapPadding: 1.0,
      ),
      constraints: const BoxConstraints(maxHeight: CConstants.GOLDEN_SIZE * 4),
    ),
    menuStyle: MenuStyle(
      padding: WidgetStateProperty.all(const EdgeInsets.all(CConstants.GOLDEN_SIZE / 2)),
      backgroundColor: WidgetStateProperty.all(TcColorScheme.light.primaryContainer),
      side: WidgetStateProperty.all(const BorderSide(style: BorderStyle.none)),
      shape: WidgetStateProperty.all(RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(CConstants.DEFAULT_RADIUS / 2),
      )),
      elevation: const WidgetStatePropertyAll(5),
    ),
  );

  static DropdownMenuThemeData dark = DropdownMenuThemeData(
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(CConstants.DEFAULT_RADIUS / 2)),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: CConstants.GOLDEN_SIZE / 2),
      constraints: const BoxConstraints(maxHeight: CConstants.GOLDEN_SIZE * 4),
    ),
    menuStyle: MenuStyle(
      padding: WidgetStateProperty.all(const EdgeInsets.all(CConstants.GOLDEN_SIZE)),
      backgroundColor: WidgetStateProperty.all(const Color(0xFF2E2F33)),
      side: WidgetStateProperty.all(const BorderSide(style: BorderStyle.none)),
      shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(CConstants.DEFAULT_RADIUS))),
      elevation: const WidgetStatePropertyAll(5),
    ),
  );
}
