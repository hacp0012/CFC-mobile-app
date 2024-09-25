import 'package:cfc_christ/env.dart';
import 'package:cfc_christ/states/c_default_state.dart';
import 'package:cfc_christ/routes/routes_main.dart';
import 'package:cfc_christ/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:watch_it/watch_it.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class Setup extends StatelessWidget with WatchItMixin {
  const Setup({super.key});

  static final globalKey = GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    ThemeMode themeMode = watchValue<CDefaultState, ThemeMode>((CDefaultState data) => data.themeMode);

    return RefreshConfiguration(
      headerBuilder: () => const WaterDropMaterialHeader(
        distance: 36,
        // backgroundColor: themeMode == ThemeMode.system ? TcColorScheme.light.primaryContainer : const Color(0xFF2E2F33),
        // color: themeMode == ThemeMode.system ? TcColorScheme.light.primary : CConstants.LIGHT_COLOR,
      ),
      footerBuilder:  () => const ClassicFooter(),        // Configure default bottom indicator
      headerTriggerDistance: 80.1,
      springDescription: const SpringDescription(stiffness: 170, damping: 16, mass: 1.9),
      maxOverScrollExtent: 100,
      maxUnderScrollExtent: 0,
      enableScrollWhenRefreshCompleted: true,
      enableLoadingWhenFailed: true,
      hideFooterWhenNotFull: false,
      enableBallisticLoad: true,

      // --> APP -->
      child: MaterialApp.router(
        scaffoldMessengerKey: globalKey,
        restorationScopeId: 'main_restoration_id_scope',
        routerConfig: mainRoutes,
        themeMode: themeMode,
        title: Env.APP_NAME,
        theme: CTheme.lightTheme,
        darkTheme: CTheme.dark,
        themeAnimationCurve: Curves.ease,
        debugShowCheckedModeBanner: Env.DEBUG,
        locale: const Locale('fr', 'FR'),
        localizationsDelegates: const [
          RefreshLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const <Locale>[Locale('fr', 'FR'), Locale('en', 'US')],
      ),
    );

    /*return MaterialApp.router(
      scaffoldMessengerKey: globalKey,
      restorationScopeId: 'main_restoration_id_scope',
      routerConfig: mainRoutes,
      themeMode: themeMode,
      title: Env.APP_NAME,
      theme: CTheme.lightTheme,
      darkTheme: CTheme.dark,
      themeAnimationCurve: Curves.ease,
      debugShowCheckedModeBanner: Env.DEBUG,
      locale: const Locale('fr', 'FR'),
      localizationsDelegates: const [
        RefreshLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const <Locale>[Locale('fr', 'FR'), Locale('en', 'US')],
    );*/
  }
}
