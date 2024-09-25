import 'package:cfc_christ/services/notification/c_s_notification.dart';
import 'package:permission_handler/permission_handler.dart';

enum CSPermissionName { camera, notification, audio, media, microphone, notificationPolicy }

class CSPermissions {
  /// Start checking and asking for permissions.
  static void startAsking() async {
    var cameraStatus = await Permission.camera.status;
    if (cameraStatus.isDenied) {
      Permission.camera.request();
    } else if (cameraStatus.isPermanentlyDenied) {
      openAppSettings();
    }

    var accessNotificationsStatus = await Permission.notification.status;
    if (accessNotificationsStatus.isDenied) {
      Permission.accessMediaLocation.request();
    } else if (accessNotificationsStatus.isPermanentlyDenied) {
      openAppSettings();
    }

    var accessNotificationsPolicyStatus = await Permission.accessNotificationPolicy.status;
    if (accessNotificationsPolicyStatus.isDenied) {
      Permission.accessNotificationPolicy.request();
    } else if (accessNotificationsPolicyStatus.isPermanentlyDenied) {
      openAppSettings();
    }

    var audioStatus = await Permission.audio.status;
    if (audioStatus.isDenied) {
      Permission.audio.request();
    } else if (audioStatus.isPermanentlyDenied) {
      openAppSettings();
    }

    var mediaStatus = await Permission.mediaLibrary.status;
    if (mediaStatus.isDenied) {
      Permission.mediaLibrary.request();
    } else if (mediaStatus.isPermanentlyDenied) {
      openAppSettings();
    }

    var microStatus = await Permission.microphone.status;
    if (microStatus.isDenied) {
      Permission.microphone.request();
    } else if (microStatus.isPermanentlyDenied) {
      openAppSettings();
    }

    // EVENTS HANDLERS : ---------------------------------------------------------------------------------------------------->
    Permission.camera
        .onDeniedCallback(() => Permission.camera.request())
        .onPermanentlyDeniedCallback(() => openAppSettings());

    Permission.accessNotificationPolicy
        .onDeniedCallback(() => Permission.accessNotificationPolicy.request())
        .onPermanentlyDeniedCallback(() => openAppSettings());

    Permission.audio.onDeniedCallback(() => Permission.audio.request()).onPermanentlyDeniedCallback(() => openAppSettings());

    Permission.mediaLibrary
        .onDeniedCallback(() => Permission.mediaLibrary.request())
        .onPermanentlyDeniedCallback(() => openAppSettings());

    Permission.microphone
        .onDeniedCallback(() => Permission.microphone.request())
        .onPermanentlyDeniedCallback(() => openAppSettings());

    Permission.accessMediaLocation
        .onDeniedCallback(() => Permission.accessMediaLocation.request())
        .onPermanentlyDeniedCallback(() => openAppSettings());

    CSNotification.permissionInitilize();
  }

  static Future<bool> status() async {
    var cameraStatus = await Permission.camera.status;
    var accessNotificationsStatus = await Permission.notification.status;
    // var accessNotificationsPolicyStatus = await Permission.accessNotificationPolicy.status;
    // var audioStatus = await Permission.audio.status;
    var mediaStatus = await Permission.mediaLibrary.status;
    var microStatus = await Permission.microphone.status;

    if (cameraStatus.isGranted &&
        accessNotificationsStatus.isGranted &&
        // accessNotificationsPolicyStatus.isGranted &&
        // audioStatus.isGranted && // Not obligatory
        mediaStatus.isGranted &&
        microStatus.isGranted) return true;

    return false;
  }

  static statusOf(CSPermissionName name) async {
    var cameraStatus = await Permission.camera.status;
    var accessNotificationsStatus = await Permission.notification.status;
    // var accessNotificationsPolicyStatus = await Permission.accessNotificationPolicy.status;
    var mediaLocation = await Permission.accessMediaLocation.status;
    // var audioStatus = await Permission.audio.status;
    var mediaStatus = await Permission.mediaLibrary.status;
    var microStatus = await Permission.microphone.status;

    if (cameraStatus.isGranted &&
        accessNotificationsStatus.isGranted &&
        // accessNotificationsPolicyStatus.isGranted &&
        // audioStatus.isGranted &&
        mediaStatus.isGranted &&
        mediaLocation.isGranted &&
        microStatus.isGranted) return true;

    return false;
  }

  static request(CSPermissionName permission) async {}

  static void recheck() {}
}
