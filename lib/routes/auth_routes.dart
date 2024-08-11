import 'package:cfc_christ/views/screens/auth/login_screen.dart';
import 'package:cfc_christ/views/screens/auth/otp_screen.dart';
import 'package:cfc_christ/views/screens/auth/register_otp_screen.dart';
import 'package:cfc_christ/views/screens/auth/register_screen.dart';
import 'package:go_router/go_router.dart';

final authRoutes = [
  GoRoute(
    path: '/login',
    name: LoginScreen.routeName,
    builder: (context, state) => const LoginScreen(),
    routes: [
      GoRoute(
        path: OtpScreen.routePath,
        name: OtpScreen.routeName,
        builder: (context, state) => OtpScreen(grState: state),
      ),
    ],
  ),
  GoRoute(
    path: RegisterScreen.routePath,
    name: RegisterScreen.routeName,
    builder: (context, state) => RegisterScreen(grState: state),
    routes: [
      GoRoute(
        path: RegisterOtpScreen.routePath,
        name: RegisterOtpScreen.routeName,
        builder: (context, state) => RegisterOtpScreen(grState: state),
      ),
    ],
  ),
];
