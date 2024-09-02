import 'package:cfc_christ/app.dart';
import 'package:cfc_christ/configs/c_constants.dart';
import 'package:flutter/material.dart';

class CSnackbarWidget {
  CSnackbarWidget(
    BuildContext context, {
    required Widget content,
    bool defaultDuration = false,
    Duration duration = const Duration(seconds: 9),
    String? actionLabel,
    Color? backgroundColor,
    Function()? action,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: backgroundColor,
        padding: const EdgeInsets.all(CConstants.GOLDEN_SIZE),
        behavior: SnackBarBehavior.floating,
        duration: defaultDuration ? const Duration(seconds: 3) : duration,
        dismissDirection: DismissDirection.horizontal,
        content: content,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9.0)),
        action: action != null ? SnackBarAction(label: actionLabel ?? 'X', onPressed: action) : null,
      ),
    );
  }

  /// Show without context.
  CSnackbarWidget.direct(
    Widget content, {
    bool defaultDuration = false,
    Duration duration = const Duration(seconds: 9),
    String? actionLabel,
    Color? backgroundColor,
    Function()? action,
  }) {
    Setup.globalKey.currentState?.showSnackBar(
      SnackBar(
        backgroundColor: backgroundColor,
        padding: const EdgeInsets.all(CConstants.GOLDEN_SIZE),
        behavior: SnackBarBehavior.floating,
        duration: defaultDuration ? const Duration(seconds: 3) : duration,
        dismissDirection: DismissDirection.horizontal,
        content: content,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9.0)),
        action: action != null ? SnackBarAction(label: actionLabel ?? 'X', onPressed: action) : null,
      ),
    );
  }
}
