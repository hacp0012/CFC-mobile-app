import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TcOverlayUiStyle {
  TcOverlayUiStyle._();

  static SystemUiOverlayStyle of(BuildContext context, {bool statusBarTo = false, Color? navColor}) {
    return SystemUiOverlayStyle.light.copyWith(
      systemNavigationBarColor: navColor ?? Theme.of(context).colorScheme.surface,
      statusBarColor:
          statusBarTo ? Theme.of(context).colorScheme.surface.withOpacity(0) : Theme.of(context).colorScheme.surface,
      statusBarIconBrightness: Theme.of(context).brightness == Brightness.light ? Brightness.dark : Brightness.light,
    );
  }
}
