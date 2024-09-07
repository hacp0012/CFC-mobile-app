import 'package:cfc_christ/routes/route_middleware.dart';
import 'package:cfc_christ/routes/routes_transitions.dart';
import 'package:cfc_christ/views/screens/app/aboutus_screen.dart';
import 'package:cfc_christ/views/screens/app/app_pastoral_calendar_screen.dart';
import 'package:cfc_christ/views/screens/app/app_setting_screen.dart';
import 'package:cfc_christ/views/screens/app/contactus_screen.dart';
import 'package:cfc_christ/views/screens/app/donate_screen.dart';
import 'package:cfc_christ/views/screens/app/find_cfc_around_screen.dart';
import 'package:cfc_christ/views/screens/app/invite_friend_screen.dart';
import 'package:cfc_christ/views/screens/app/leave_notice_screen.dart';
import 'package:cfc_christ/views/screens/app/search_screen.dart';
import 'package:cfc_christ/views/screens/home/home_screen.dart';
import 'package:cfc_christ/views/screens/index_screen.dart';
import 'package:cfc_christ/views/screens/offile_alert_screen.dart';
import 'package:cfc_christ/views/screens/permissions_screen.dart';
import 'package:cfc_christ/views/screens/presentation_screen.dart';
import 'package:cfc_christ/views/screens/splash_screen.dart';
import 'package:go_router/go_router.dart';

final appRoutes = [
  // --- STARTUP ROUTES :
  GoRoute(
    path: '/',
    name: SplashScreen.routeName,
    builder: (context, state) => const SplashScreen(),
    routes: [
      GoRoute(
        path: 'presentation',
        name: PresentationScreen.routeName,
        builder: (context, state) => const PresentationScreen(),
        pageBuilder: (context, state) => RoutesTransitions.slide(context, state, const PresentationScreen()),
      ),
      GoRoute(
        path: OffileAlertScreen.routePath,
        name: OffileAlertScreen.routeName,
        builder: (context, state) => const OffileAlertScreen(),
      ),
      GoRoute(
        path: PermissionsScreen.routePath,
        name: PermissionsScreen.routeName,
        builder: (context, state) => const PermissionsScreen(),
      ),
      GoRoute(
        path: IndexScreen.routePath,
        name: IndexScreen.routeName,
        builder: (context, state) => const IndexScreen(),
        // redirect: (context, state) => '/login',
        routes: const [],
      ),
    ],
  ),

  // --- APP ROUES :
  GoRoute(
    path: '/${HomeScreen.routePath}',
    name: HomeScreen.routeName,
    builder: (context, state) => const HomeScreen(),
    redirect: RouteMiddleware([RouteMiddleware.auth]).watch,
    pageBuilder: (context, state) => RoutesTransitions.slide(context, state, const HomeScreen()),
    routes: [
      GoRoute(
        path: SearchScreen.routePath,
        name: SearchScreen.routeName,
        builder: (context, state) => const SearchScreen(),
        pageBuilder: (context, state) => RoutesTransitions.slide(context, state, const SearchScreen()),
      ),
      GoRoute(
        path: FindCfcAroundScreen.routePath,
        name: FindCfcAroundScreen.routeName,
        builder: (context, state) => const FindCfcAroundScreen(),
      ),
      GoRoute(
        path: InviteFriendScreen.routePath,
        name: InviteFriendScreen.routeName,
        builder: (context, state) => const InviteFriendScreen(),
      ),
      GoRoute(
        path: LeaveNoticeScreen.routePath,
        name: LeaveNoticeScreen.routeName,
        builder: (context, state) => const LeaveNoticeScreen(),
      ),
      GoRoute(
        path: DonateScreen.routePath,
        name: DonateScreen.routeName,
        builder: (context, state) => const DonateScreen(),
      ),
      GoRoute(
        path: ContactusScreen.routePath,
        name: ContactusScreen.routeName,
        builder: (context, state) => const ContactusScreen(),
      ),
      GoRoute(
        path: AboutusScreen.routePath,
        name: AboutusScreen.routeName,
        builder: (context, state) => const AboutusScreen(),
      ),
      GoRoute(
        path: AppSettingScreen.routePath,
        name: AppSettingScreen.routeName,
        builder: (context, state) => const AppSettingScreen(),
      ),
      GoRoute(
        path: AppPastoralCalendarScreen.routePath,
        name: AppPastoralCalendarScreen.routeName,
        builder: (context, state) => const AppPastoralCalendarScreen(),
      ),
    ],
  ),
];
