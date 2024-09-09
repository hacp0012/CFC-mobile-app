import 'package:cfc_christ/database/app_preferences.dart';
import 'package:cfc_christ/env.dart';
import 'package:cfc_christ/services/notification/c_s_notification.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

class CSBackground {
  @pragma('vm:entry-point')
  static Future<void> initialize() async {
    final service = FlutterBackgroundService();

    await service.configure(
      iosConfiguration: IosConfiguration(),
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        autoStart: false, // ! The start is set in notification service permission.
        autoStartOnBoot: true,
        isForegroundMode: false,
        foregroundServiceType: AndroidForegroundType.dataSync,
      ),
    );
  }

  @pragma('vm:entry-point')
  static void onStart(ServiceInstance service) async {
    // DartPluginRegistrant.ensureInitialized();

      debugPrint("SERVICE STARTED --> ------------------------------------------");
    // ! KILL THIS SERVICE !
    service.on(Env.APP_BACKGROUND_SERVICE_NAME).listen((event) {
      debugPrint("SERVICE KILLED --> ------------------------------------------");
      service.stopSelf();
    });

    // REGISTER METHODS
    CSBackground().methodsRegistration(service);

    // INIT PREFERENCE FOR BG SERVICE.
    CAppPreferences().initialize();

    // NOTIFICATION.
    CSNotification.initialize();

    // RUN SERVICES.
    // Lazy runing services.
    CSBackground().lazyRuning();
  }

  /// KILL THE BACKGROUNG PROCESS.
  static void killService() {
    final service = FlutterBackgroundService();

    // KILL PROCESS.
    service.invoke(Env.APP_BACKGROUND_SERVICE_NAME);
  }

  // SERVICES RUNNERS --------------------------------------------------------------------------------------------------------

  void methodsRegistration(ServiceInstance service) {
    // Register : Notification request controller.
    service.on(CSNotification.NOTIFICATION_BG_RQ_CTR_ID).listen((data) => CSNotification().requestController(data ?? {}));

    // Update Isolate preference state.
    service.on("UPDATE_PREFERENCE_STORAGE").listen((event) => CAppPreferences().instance?.reload());
  }

  /// Keep runing evently.
  void lazyRuning() async {
    // ADD CALLS HERE...
    CSNotification().loader.load();
  }
}
