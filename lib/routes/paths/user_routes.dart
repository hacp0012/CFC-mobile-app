import 'package:cfc_christ/routes/route_middleware.dart';
import 'package:cfc_christ/routes/routes_transitions.dart';
import 'package:cfc_christ/views/screens/user/partials/user_new_phone_validation_otp_screen.dart';
import 'package:cfc_christ/views/screens/user/profile_screen.dart';
import 'package:cfc_christ/views/screens/user/profile_setting_screen.dart';
import 'package:cfc_christ/views/screens/user/user_delete_account_screen.dart';
import 'package:cfc_christ/views/screens/user/user_edit_pcn_screen.dart';
import 'package:cfc_christ/views/screens/user/user_favorits_screen.dart';
import 'package:cfc_christ/views/screens/user/user_publications_list_screen.dart';
import 'package:cfc_christ/views/screens/user/user_responsability_screen.dart';
import 'package:cfc_christ/views/screens/user/validable_screen.dart';
import 'package:go_router/go_router.dart';

final List<GoRoute> userRoutes = [
  GoRoute(
    path: ProfileScreen.routePath,
    name: ProfileScreen.routeName,
    redirect: RouteMiddleware([RouteMiddleware.auth]).watch,
    builder: (context, state) => const ProfileScreen(),
    routes: [
      GoRoute(
        path: ValidableScreen.routePath,
        name: ValidableScreen.routeName,
        builder: (context, state) => const ValidableScreen(),
      ),
      GoRoute(
        path: ProfileSettingScreen.routePath,
        name: ProfileSettingScreen.routeName,
        builder: (context, state) => const ProfileSettingScreen(),
        pageBuilder: (context, state) => RoutesTransitions.slide(context, state, const ProfileSettingScreen()),
      ),
      GoRoute(
        path: UserDeleteAccountScreen.routePath,
        name: UserDeleteAccountScreen.routeName,
        builder: (context, state) => const UserDeleteAccountScreen(),
        pageBuilder: (context, state) => RoutesTransitions.slide(context, state, const UserDeleteAccountScreen()),
      ),
      GoRoute(
        path: UserPublicationsListScreen.routePath,
        name: UserPublicationsListScreen.routeName,
        builder: (context, state) => const UserPublicationsListScreen(),
      ),
      GoRoute(
        path: UserEditPcnScreen.routePath,
        name: UserEditPcnScreen.routeName,
        builder: (context, state) => const UserEditPcnScreen(),
      ),
      GoRoute(
        path: UserFavoritsScreen.routePath,
        name: UserFavoritsScreen.routeName,
        builder: (context, state) => const UserFavoritsScreen(),
        pageBuilder: (context, state) => RoutesTransitions.slide(context, state, const UserFavoritsScreen()),
      ),
      GoRoute(
        path: UserResponsabilityScreen.routePath,
        name: UserResponsabilityScreen.routeName,
        builder: (context, state) => const UserResponsabilityScreen(),
      ),
      GoRoute(
        path: UserNewPhoneValidationOtpScreen.routePath,
        name: UserNewPhoneValidationOtpScreen.routeName,
        builder: (context, state) => UserNewPhoneValidationOtpScreen(grState: state),
      ),
    ],
  ),
];
