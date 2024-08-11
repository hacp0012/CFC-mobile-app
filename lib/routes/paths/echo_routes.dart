import 'package:cfc_christ/views/screens/echo/new_echo_screen.dart';
import 'package:cfc_christ/views/screens/echo/read_echo_screen.dart';
import 'package:go_router/go_router.dart';

final List<GoRoute> echoRoutes = [
  GoRoute(path: '/echo', builder: (context, state) => const NewEchoScreen(), routes: [
    GoRoute(path: NewEchoScreen.routePath, name: NewEchoScreen.routeName, builder: (context, state) => const NewEchoScreen()),
    GoRoute(
      path: ReadEchoScreen.routePath,
      name: ReadEchoScreen.routeName,
      builder: (context, state) => const ReadEchoScreen(),
    ),
  ]),
];
