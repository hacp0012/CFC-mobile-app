// import 'dart:io';

import 'package:cfc_christ/env.dart';
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

    // ! KILL THIS SERVICE !
    service.on(Env.APP_BACKGROUND_SERVICE_NAME).listen((event) => service.stopSelf());

    // RUN SERVICES.
    // Lazy runing services.
    CSBackground().lazyRuning();

    // Frequantly runing services.
    // while (true) {
    //   await CSBackground().instantRuning();

    //   sleep(const Duration(milliseconds: 360));
    // }
  }

  /// KILL THE BACKGROUNG PROCESS.
  static void killService() {
    final service = FlutterBackgroundService();

    // KILL PROCESS.
    service.invoke(Env.APP_BACKGROUND_SERVICE_NAME);
  }

  // SERVICES RUNNERS --------------------------------------------------------------------------------------------------------
  /// Called even 360ms.
  Future<void> instantRuning() async {
    // A TIMER CALLS HERE...
  }

  /// Keep runing evently.
  void lazyRuning() {
    // ADD CALLS HERE...
  }
}
