import 'package:cfc_christ/configs/c_network_state.dart';
import 'package:cfc_christ/database/app_preferences.dart';
import 'package:cfc_christ/database/models/user_model.dart';
import 'package:cfc_christ/views/screens/auth/login_screen.dart';
import 'package:cfc_christ/views/screens/offile_alert_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

/// Route middleware.
///
/// Call the static methodes without '()'.
///
/// Exemple :
/// ``` dart
///
/// redirect: RouteMiddleware([RouteMiddleware.auth]).watch
/// ```
class RouteMiddleware {
  List<Function> middlewares;

  RouteMiddleware(this.middlewares);

  String? watch(BuildContext context, GoRouterState state) {
    for (Function fn in middlewares) {
      return fn.call(context, state);
    }

    return null;
  }

  // MIDDLEWARE : @Return String|Null ----------------------------------------------------------------------------------------
  static String? auth(BuildContext context, GoRouterState state) {
    String? userData = CAppPreferences().instance?.getString(UserModel.tableName);
    // return String|Null
    if (CAppPreferences().loginToken == null || userData == null || userData.isEmpty) {
      // return null;
      return state.namedLocation(LoginScreen.routeName);
    }

    return null;
  }

  //
  static String? ensureIsOnline(BuildContext context, GoRouterState state) {
    if (GetIt.instance<CNetworkState>().online.value == false) {
      return state.namedLocation(OffileAlertScreen.routeName);
    }

    return null;
  }
}
