import 'package:cfc_christ/configs/c_constants.dart';
import 'package:cfc_christ/theme/configs/rc_color_sheme.dart';
import 'package:flutter/material.dart';

class TCDialog {
  static DialogTheme light = DialogTheme(
    barrierColor: TcColorScheme.light.primaryContainer.withOpacity(0.5),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(CConstants.GOLDEN_SIZE)),
    elevation: CConstants.GOLDEN_SIZE,
    shadowColor: Colors.grey.withOpacity(0.6),
  );

  static DialogTheme dark = DialogTheme(
    barrierColor: TcColorScheme.dark.surface.withOpacity(0.9),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(CConstants.GOLDEN_SIZE)),
    elevation: CConstants.GOLDEN_SIZE,
    shadowColor: Colors.grey.withOpacity(0.6),
  );
}
