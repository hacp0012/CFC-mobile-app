import 'package:cfc_christ/views/screens/comm/new_comm_screen.dart';
import 'package:cfc_christ/views/screens/comm/read_comm_screen.dart';
import 'package:go_router/go_router.dart';

final List<GoRoute> communicationsRoutes = [
  GoRoute(path: '/communication', builder: (context, state) => const NewCommScreen(), routes: [
    GoRoute(path: NewCommScreen.routePath, name: NewCommScreen.routeName, builder: (context, state) => const NewCommScreen()),
    GoRoute(
      path: ReadCommScreen.routePath,
      name: ReadCommScreen.routeName,
      builder: (context, state) => const ReadCommScreen(),
    ),
  ]),
];
