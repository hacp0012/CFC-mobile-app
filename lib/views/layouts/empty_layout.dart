import 'package:cfc_christ/configs/c_constants.dart';
import 'package:cfc_christ/configs/c_network_state.dart';
import 'package:cfc_christ/theme/c_transition_thme.dart';
import 'package:cfc_christ/theme/configs/tc_overlay_ui_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:watch_it/watch_it.dart';

class EmptyLayout extends WatchingStatefulWidget with WatchItStatefulWidgetMixin {
  final Widget child;
  final Color? navColor;
  final bool transparentStatusBar;

  const EmptyLayout({super.key, required this.child, this.navColor, this.transparentStatusBar = false});

  @override
  State<StatefulWidget> createState() => _EmptyLayoutState();
}

class _EmptyLayoutState extends State<EmptyLayout> {
  // DATAS -------------------------------------------------------------------------------------------------------------------
  bool appIsOnline = false;

  // INITIALIZERS ------------------------------------------------------------------------------------------------------------
  @override
  void initState() {
    super.initState();
  }

  // VIEW --------------------------------------------------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    appIsOnline = watchValue<CNetworkState, bool>((CNetworkState data) => data.online);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: TcOverlayUiStyle.of(context, navColor: widget.navColor, statusBarTo: widget.transparentStatusBar),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        if (!appIsOnline)
          Container(
            padding: const EdgeInsets.symmetric(vertical: CConstants.GOLDEN_SIZE / 2),
            decoration: BoxDecoration(color: Colors.grey.shade800),
            child: Text(
              "hors ligne",
              style: Theme.of(context).textTheme.labelSmall?.copyWith(color: CConstants.LIGHT_COLOR),
            ),
          ).animate(effects: CTransitionsTheme.model_1),

        // APPLICATION CONTENT :
        Expanded(child: widget.child),
      ]),
    );
  }
}
