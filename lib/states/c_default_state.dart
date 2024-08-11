import 'package:cfc_christ/database/app_preferences.dart';
import 'package:flutter/material.dart';

class CDefaultState {
  final ValueNotifier<ThemeMode> _themeMode = ValueNotifier<ThemeMode>(ThemeMode.system);

  ValueNotifier<ThemeMode> get themeMode {
    String? mode = CAppPreferences().instance?.getString('theme_mode');
    switch (mode) {
      case 'light':
        _themeMode.value = ThemeMode.light;
      case 'dark':
        _themeMode.value = ThemeMode.dark;
      case 'system':
        _themeMode.value = ThemeMode.system;
    }

    // if (darkMode == true && _themeMode.value != ThemeMode.dark) {
    //   _themeMode.value = ThemeMode.dark;
    // }
    return _themeMode;
  }

  setThemeMode(ThemeMode mode) {
    _themeMode.value = mode;
    Map t = <ThemeMode, String>{ThemeMode.light: 'light', ThemeMode.dark: 'dark', ThemeMode.system: 'system'};

    CAppPreferences().instance?.setString('theme_mode', t[mode]);
  }
}
