import 'package:cfc_christ/views/screens/family/user_family_couple_screen.dart';
import 'package:cfc_christ/views/screens/family/user_family_godfather_screen.dart';
import 'package:cfc_christ/views/screens/family/user_family_home_screen.dart';
import 'package:cfc_christ/views/screens/family/user_family_parents_screen.dart';
import 'package:go_router/go_router.dart';

final List<GoRoute> familyRoutes = [
  GoRoute(
    path: UserFamilyHomeScreen.routePath,
    name: UserFamilyHomeScreen.routeName,
    builder: (context, state) => const UserFamilyHomeScreen(),
    routes: [
      GoRoute(
        path: UserFamilyCoupleScreen.routePath,
        name: UserFamilyCoupleScreen.routeName,
        builder: (context, state) => const UserFamilyCoupleScreen(),
      ),
      GoRoute(
        path: UserFamilyParentsScreen.routePath,
        name: UserFamilyParentsScreen.routeName,
        builder: (context, state) => const UserFamilyParentsScreen(),
      ),
      GoRoute(
        path: UserFamilyGodfatherScreen.routePath,
        name: UserFamilyGodfatherScreen.routeName,
        builder: (context, state) => const UserFamilyGodfatherScreen(),
      ),
    ],
  )
];
