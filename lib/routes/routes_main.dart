import 'package:cfc_christ/routes/auth_routes.dart';
import 'package:cfc_christ/routes/paths/app_routes.dart';
import 'package:cfc_christ/routes/paths/communication_routes.dart';
import 'package:cfc_christ/routes/paths/echo_routes.dart';
import 'package:cfc_christ/routes/paths/family_routes.dart';
import 'package:cfc_christ/routes/paths/misc_routes.dart';
import 'package:cfc_christ/routes/paths/notification_routes.dart';
import 'package:cfc_christ/routes/paths/teaching_routes.dart';
import 'package:cfc_christ/routes/paths/user_routes.dart';
import 'package:cfc_christ/views/screens/error_screen.dart';
import 'package:go_router/go_router.dart';

final mainRoutes = GoRouter(
  initialLocation: '/',
  errorBuilder: (context, state) => ErrorScreen(routeState: state),

  // ROUTES ------------------ --------------------------------------------------
  routes: [
    ...appRoutes,
    ...authRoutes,
    ...userRoutes,
    ...notificatonRoutes,
    ...communicationsRoutes,
    ...echoRoutes,
    ...familyRoutes,
    ...miscRoutes,
    ...teachingRoutes,
  ],
);
