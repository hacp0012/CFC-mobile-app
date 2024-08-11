import 'package:cfc_christ/theme/c_transition_thme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CModalWidget {
  CModalWidget({required this.context, required this.child});

  CModalWidget.fullscreen({required this.context, required this.child}) {
    _isFullscreen = true;
  }

  final BuildContext context;
  final Widget child;
  bool _isFullscreen = false;
  Alignment alignment = Alignment.center;
  bool persistant = false;
  bool unRoute = false;

  void show({bool? persistant, Alignment? alignment, bool? isFullscreen, bool unRoute = false}) {
    this.alignment = alignment ?? Alignment.center;
    _isFullscreen = isFullscreen ?? _isFullscreen;
    this.persistant = persistant ?? false;
    this.unRoute = unRoute;

    if (_isFullscreen) {
      _fullscreenModal();
    } else {
      _modal();
    }
  }

  void _fullscreenModal() {
    showDialog(
      context: context,
      barrierDismissible: !persistant,
      useRootNavigator: !unRoute,
      builder: (context) => Dialog.fullscreen(
        insetAnimationCurve: Curves.ease,
        child: child,
      ).animate(effects: CTransitionsTheme.model_1),
    );
  }

  void _modal() {
    showDialog(
      context: context,
      barrierLabel: "lorem ipsum",
      barrierDismissible: !persistant,
      useRootNavigator: !unRoute,
      builder: (context) => Dialog(
        insetAnimationCurve: Curves.ease,
        alignment: alignment,
        child: child,
      ).animate(effects: CTransitionsTheme.model_1),
    );
  }

  /// Close modal.
  static void close(BuildContext context) {
    Navigator.of(context).pop();
  }
}
