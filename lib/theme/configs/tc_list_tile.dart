import 'package:cfc_christ/configs/c_constants.dart';
import 'package:cfc_christ/theme/configs/tc_text_theme.dart';
import 'package:flutter/material.dart';

class TcListTile {
  static ListTileThemeData light = ListTileThemeData(
    dense: true,
    visualDensity: VisualDensity.compact,
    subtitleTextStyle: TcTextTheme.light.labelSmall,
    style: ListTileStyle.list,
  );

  static ListTileThemeData dark = ListTileThemeData(
    dense: true,
    visualDensity: VisualDensity.compact,
    subtitleTextStyle: TcTextTheme.dark.labelSmall?.copyWith(
      fontWeight: FontWeight.w300,
      fontFamily: CConstants.FONT_FAMILY_SECONDARY,
    ),
    style: ListTileStyle.list,
  );
}
