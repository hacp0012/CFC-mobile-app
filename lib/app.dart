import 'package:cfc_christ/env.dart';
import 'package:cfc_christ/states/c_default_state.dart';
import 'package:cfc_christ/routes/routes_main.dart';
import 'package:cfc_christ/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

class Setup extends StatelessWidget with WatchItMixin {
  const Setup({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      restorationScopeId: 'main_restoration_id_scope',
      routerConfig: mainRoutes,
      themeMode: watchValue<CDefaultState, ThemeMode>((CDefaultState data) => data.themeMode),
      title: Env.APP_NAME,
      theme: CTheme.lightTheme,
      darkTheme: CTheme.dark,
      themeAnimationCurve: Curves.ease,
      debugShowCheckedModeBanner: Env.DEBUG,
    );
  }
}
