import 'package:cfc_christ/env.dart';
import 'package:cfc_christ/theme/configs/tc_overlay_ui_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DefaultLayoutLoose extends StatefulWidget {
  const DefaultLayoutLoose({super.key, required this.child, this.title});

  final Widget child;

  final Widget? title;

  @override
  createState() => _DefaultLayoutLooseState();
}

class _DefaultLayoutLooseState extends State<DefaultLayoutLoose> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: TcOverlayUiStyle.of(context),
      child: Scaffold(
        appBar: AppBar(
          title: widget.title ?? const Text(Env.APP_NAME),
          // systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
          //   systemNavigationBarColor: Theme.of(context).colorScheme.surface,
          // ),
        ),
        body: widget.child,
      ),
    );
  }
}
