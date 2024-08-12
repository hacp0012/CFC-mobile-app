import 'package:cfc_christ/database/app_preferences.dart';
import 'package:cfc_christ/database/models/user_model.dart';
import 'package:cfc_christ/services/c_s_loader.dart';
import 'package:cfc_christ/services/c_s_permissions.dart';
import 'package:cfc_christ/views/screens/auth/login_screen.dart';
import 'package:cfc_christ/views/screens/home/home_screen.dart';
import 'package:cfc_christ/views/screens/presentation_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

/// Boot manager.
class CSBoot {
  final String _firstTimeStoreKey = 'APP_FIRST_LAUNCH_STATE';

  CSBoot({Function()? onFinish, Function()? onFailed}) {
    CSLoader.load(
      onStart: () => debugPrint("APP LOADING START *********"),
      onFinish: onFinish,
      onError: onFailed,
    );

    // ASK FOR PERSMISSIONS :
    // Isolate.run(() => CSBoot.askingForPermissions());
  }

  /// Control wether is first time launch.
  static void isFirstTime(BuildContext context) {
    bool? state = CAppPreferences().instance?.getBool(CSBoot()._firstTimeStoreKey);

    // Create state.
    if (state == null) {
      CAppPreferences().instance?.setBool(CSBoot()._firstTimeStoreKey, true);
      // Update state.
      state = true;
    }

    if (state == true) {
      // Open presentation screen.
      context.goNamed(PresentationScreen.routeName);
    } else {
      openSession(context);
    }
  }

  /// Open vieuw screen.
  static void openSession(BuildContext context) {
    var loginTokenState = CAppPreferences().loginToken;
    String? userDataState = CAppPreferences().instance?.getString(UserModel.tableName);

    if (loginTokenState != null && userDataState != null && userDataState.isNotEmpty) {
      // Open Home Screen -----------------:>
      context.goNamed(HomeScreen.routeName);
    } else {
      // Open Login Screen ----------------:>
      context.goNamed(LoginScreen.routeName);
    }
  }

  /// Mark the first time lauch flag as already launched.
  static void firstTimeCompleted(BuildContext context) {
    CAppPreferences().instance?.setBool(CSBoot()._firstTimeStoreKey, false);

    // Recall OpenSession :
    openSession(context);
  }

  /// Mark the first time lauch flag as unlaunched.
  /// This make the app to reopen the presentation screen.
  static void firstTimeIncompleted() {
    CAppPreferences().instance?.setBool(CSBoot()._firstTimeStoreKey, false);
  }

  static Future<void> askingForPermissions() async => CSPermissions.startAsking();
}
