import 'package:cfc_christ/theme/configs/rc_color_sheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cfc_christ/configs/c_constants.dart';

class TcSegementButton {
  static SegmentedButtonThemeData ligth = SegmentedButtonThemeData(
    selectedIcon: const Icon(CupertinoIcons.check_mark_circled),
    style: ButtonStyle(
      side: WidgetStatePropertyAll(BorderSide(color: TcColorScheme.light.primaryContainer)),
      shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(CConstants.DEFAULT_RADIUS))),
    ),
  );

  static SegmentedButtonThemeData dark = SegmentedButtonThemeData(
    selectedIcon: const Icon(CupertinoIcons.check_mark_circled),
    style: ButtonStyle(
      side: WidgetStatePropertyAll(BorderSide(color: TcColorScheme.dark.primaryContainer)),
      shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(CConstants.DEFAULT_RADIUS))),
    ),
  );
}