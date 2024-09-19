import 'package:cfc_christ/views/screens/teaching/edit_teaching_screen.dart';
import 'package:cfc_christ/views/screens/teaching/new_teaching_screen.dart';
import 'package:cfc_christ/views/screens/teaching/read_teaching_screen.dart';
import 'package:go_router/go_router.dart';

final List<GoRoute> teachingRoutes = [
  GoRoute(path: '/teaching', builder: (context, state) => const NewTeachingScreen(), routes: [
    GoRoute(
      path: NewTeachingScreen.routePath,
      name: NewTeachingScreen.routeName,
      builder: (context, state) => const NewTeachingScreen(),
    ),
    GoRoute(
      path: ReadTeachingScreen.routePath,
      name: ReadTeachingScreen.routeName,
      builder: (context, state) {
        Map data = {};

        if (state.extra is Map) data = state.extra as Map;

        return ReadTeachingScreen(teachId: data['teach_id']);
      },
    ),
    GoRoute(path: EditTeachingScreen.routePath, name: EditTeachingScreen.routeName, builder: (context, state) {
     Map data = {};

     if (state.extra is Map) data = state.extra as Map;

     return EditTeachingScreen(teachId: data['teach_id']);
    })
  ]),
];
