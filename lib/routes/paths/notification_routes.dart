import 'package:cfc_christ/routes/routes_transitions.dart';
import 'package:cfc_christ/views/screens/notification/notifications_screen.dart';
import 'package:cfc_christ/views/screens/notification/notificatios_settings_sceen.dart';
import 'package:go_router/go_router.dart';

final List<GoRoute> notificatonRoutes = [
  GoRoute(
    path: NotificationsScreen.routePath,
    name: NotificationsScreen.routeName,
    builder: (context, state) => const NotificationsScreen(),
    pageBuilder: (context, state) => RoutesTransitions.slide(context, state, const NotificationsScreen()),
    routes: [
      GoRoute(
        path: NotificatiosSettingsScreen.routePath,
        name: NotificatiosSettingsScreen.routeName,
        builder: (context, state) => const NotificatiosSettingsScreen(),
      )
    ],
  )
];
