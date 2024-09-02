import 'package:cfc_christ/classes/c_misc_class.dart';
import 'package:cfc_christ/configs/c_network_state.dart';
import 'package:cfc_christ/theme/configs/tc_overlay_ui_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:watch_it/watch_it.dart';

class DefaultLayout extends WatchingStatefulWidget with WatchItStatefulWidgetMixin {
  final Widget child;
  final Color? navColor;
  final bool transparentStatusBar;

  const DefaultLayout({super.key, required this.child, this.navColor, this.transparentStatusBar = false});

  @override
  State<StatefulWidget> createState() => _EmptyLayoutState();
}

class _EmptyLayoutState extends State<DefaultLayout> {
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
        // APPLICATION CONTENT :
        Expanded(child: widget.child),

        if (!appIsOnline)
          Container(
            width: double.infinity,
            decoration: BoxDecoration(color: CMiscClass.whenBrightnessOf<Color>(context, light: Colors.grey.shade200)),
            child: Text(
              "Vous êtes hors ligne",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Theme.of(context).colorScheme.error),
            ),
          ),
      ]),
    );
  }
}
