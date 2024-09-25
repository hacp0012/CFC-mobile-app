import 'package:cfc_christ/configs/c_constants.dart';
import 'package:cfc_christ/theme/configs/rc_color_sheme.dart';
import 'package:cfc_christ/theme/configs/t_c_dialog.dart';
import 'package:cfc_christ/theme/configs/tc_appbar.dart';
import 'package:cfc_christ/theme/configs/tc_button.dart';
import 'package:cfc_christ/theme/configs/tc_card.dart';
import 'package:cfc_christ/theme/configs/tc_drawer.dart';
import 'package:cfc_christ/theme/configs/tc_dropdown_button.dart';
import 'package:cfc_christ/theme/configs/tc_list_tile.dart';
import 'package:cfc_christ/theme/configs/tc_segement_button.dart';
import 'package:cfc_christ/theme/configs/tc_switch.dart';
import 'package:cfc_christ/theme/configs/tc_text_input.dart';
import 'package:cfc_christ/theme/configs/tc_text_theme.dart';
import 'package:flutter/material.dart';

class CTheme {
  static PageTransitionsTheme pageTransitionsTheme = const PageTransitionsTheme(
    // builders: <TargetPlatform, PageTransitionsBuilder>{TargetPlatform.android: CupertinoPageTransitionsBuilder()},
    builders: <TargetPlatform, PageTransitionsBuilder>{TargetPlatform.android: OpenUpwardsPageTransitionsBuilder()},
  );

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: CConstants.FONT_FAMILY_PRIMARY,
    brightness: Brightness.light,
    colorScheme: TcColorScheme.light,

    textTheme: TcTextTheme.light,
    pageTransitionsTheme: pageTransitionsTheme,
    // CUSTOMS WIDGETS THEMES -------------------------------- >
    // cardTheme:
    inputDecorationTheme: TcTextInput.light,
    dropdownMenuTheme: TcDropdownButton.light,
    appBarTheme: TcAppbar.light,
    segmentedButtonTheme: TcSegementButton.ligth,
    switchTheme: TcSwitch.light,
    drawerTheme: TcDrawer.light,
    listTileTheme: TcListTile.light,
    buttonTheme: TcButton.light,
    dividerTheme: const DividerThemeData(space: 1.0),
    dialogTheme: TCDialog.light,
    cardTheme: TcCard.light,
  );

  static ThemeData dark = ThemeData(
    useMaterial3: true,
    fontFamily: CConstants.FONT_FAMILY_PRIMARY,
    brightness: Brightness.dark,
    colorScheme: TcColorScheme.dark,

    textTheme: TcTextTheme.dark,
    pageTransitionsTheme: pageTransitionsTheme,
    // CUSTOMS WIDGETS THEMES -------------------------------- >
    // cardTheme:
    inputDecorationTheme: TcTextInput.dark,
    dropdownMenuTheme: TcDropdownButton.dark,
    appBarTheme: TcAppbar.dark,
    segmentedButtonTheme: TcSegementButton.dark,
    switchTheme: TcSwitch.dark,
    drawerTheme: TcDrawer.dark,
    listTileTheme: TcListTile.dark,
    dividerTheme: const DividerThemeData(space: 1.0),
    dialogTheme: TCDialog.dark,
    progressIndicatorTheme: const ProgressIndicatorThemeData(color: CConstants.LIGHT_COLOR),
    cardTheme: TcCard.dark,
  );
}
