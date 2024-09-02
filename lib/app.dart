import 'package:cfc_christ/env.dart';
import 'package:cfc_christ/states/c_default_state.dart';
import 'package:cfc_christ/routes/routes_main.dart';
import 'package:cfc_christ/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class Setup extends StatelessWidget with WatchItMixin {
  const Setup({super.key});

  static final globalKey = GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      scaffoldMessengerKey: globalKey,
      restorationScopeId: 'main_restoration_id_scope',
      routerConfig: mainRoutes,
      themeMode: watchValue<CDefaultState, ThemeMode>((CDefaultState data) => data.themeMode),
      title: Env.APP_NAME,
      theme: CTheme.lightTheme,
      darkTheme: CTheme.dark,
      themeAnimationCurve: Curves.ease,
      debugShowCheckedModeBanner: Env.DEBUG,
      locale: const Locale('fr', 'FR'),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const <Locale>[Locale('fr', 'FR'), Locale('en', 'US')],
    );
  }
}
