// ignore_for_file: constant_identifier_names

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

class CSNotification {
  static const String WAKE_CHANNEL_KEY = "WAKE_NOTIFICATION";
  static const String STD_CHANNEL_KEY = "STD_NOTIFICATION";
  static const String FLASH_CHANNEL_KEY = "FLASH_NOTIFICATION";

  var loader = _Loader();

  var pusher = _UiController();

  @pragma("vm:entry-point")
  static initialize() {
    AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelGroupKey: 'WAKE_NOTIFICATION_GROUP',
          channelKey: WAKE_CHANNEL_KEY,
          channelName: 'Les notifications de veille',
          channelDescription: "Notification de rappel pour éveillé l'attention de l'utilisateur",
          channelShowBadge: true,
          playSound: true,
          defaultPrivacy: NotificationPrivacy.Public,
        ),
        NotificationChannel(
          channelGroupKey: 'STD_NOTIFICATION_GROUP',
          channelKey: STD_CHANNEL_KEY,
          channelName: 'Famille Chrétienne',
          channelDescription: "Mettre à la file des actualités",
          channelShowBadge: true,
          playSound: true,
          defaultPrivacy: NotificationPrivacy.Public,
        ),
        NotificationChannel(
          channelGroupKey: 'FLASH_NOTIFICATION_GROUP',
          channelKey: FLASH_CHANNEL_KEY,
          channelName: "Message d'application CFC",
          channelDescription: "Message d'application flash sans action",
        ),
      ],
      debug: true,
      languageCode: 'fr',
    );

    AwesomeNotifications().setListeners(
      onActionReceivedMethod: _OnActionsEventListeners.onActionReceivedMethod,
      onNotificationCreatedMethod: _OnActionsEventListeners.onNotificationCreatedMethod,
      onNotificationDisplayedMethod: _OnActionsEventListeners.onNotificationDisplayedMethod,
      onDismissActionReceivedMethod: _OnActionsEventListeners.onDismissActionReceivedMethod,
    );
  }

  static permissionInitilize() {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (isAllowed == false) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      } else {
        // ! START THE BACKGROUNG SERVICE. !
        FlutterBackgroundService().startService();
      }
    });
  }
}

class _Loader {
  load() async {
    var service = FlutterBackgroundService();
    // service.startService();
  }
}

class _UiController {
  push(Map notification) {
    _std();
  }

  _wake() {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 10,
        channelKey: CSNotification.STD_CHANNEL_KEY,
        title: 'Simple Notification',
        body: 'Simple body',
        customSound: '',
        bigPicture: null,
        summary: null,
        actionType: ActionType.Default,
        // actionType: ActionType.Default,
        category: NotificationCategory.Promo,
        // category: NotificationCategory.Message,
        badge: 1,
        wakeUpScreen: true,
        notificationLayout: NotificationLayout.Default,
        // notificationLayout: NotificationLayout.BigPicture,
        payload: {}, // Theme same notification content.
      ),
      actionButtons: [
        NotificationActionButton(
          key: 'IGNORE_NOTIFICATION',
          label: 'Ingorer',
          autoDismissible: true,
          actionType: ActionType.Default,
          color: const Color.fromARGB(0, 59, 74, 247),
        ),
        NotificationActionButton(
          key: 'MARK_AS_READ',
          label: 'Marquer comme lu',
          autoDismissible: true,
          actionType: ActionType.Default,
          color: null,
        ),
        NotificationActionButton(
          key: 'ACCEPT_MESSAGE',
          label: 'Lire',
          autoDismissible: true,
          actionType: ActionType.Default,
          color: const Color.fromARGB(0, 59, 74, 247),
        ),
      ],
    );
  }

  _std() {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 10,
        channelKey: CSNotification.STD_CHANNEL_KEY,
        title: 'Simple Notification',
        body: 'Simple body',
        customSound: '',
        bigPicture: null,
        summary: null,
        actionType: ActionType.Default,
        // actionType: ActionType.Default,
        category: NotificationCategory.Promo,
        // category: NotificationCategory.Message,
        badge: 1,
        wakeUpScreen: true,
        notificationLayout: NotificationLayout.Default,
        // notificationLayout: NotificationLayout.BigPicture,
        payload: {}, // Theme same notification content.
      ),
      actionButtons: [
        NotificationActionButton(
          key: 'IGNORE_NOTIFICATION',
          label: 'Ingorer',
          autoDismissible: true,
          actionType: ActionType.Default,
          color: const Color.fromARGB(0, 59, 74, 247),
        ),
        NotificationActionButton(
          key: 'MARK_AS_READ',
          label: 'Marquer comme lu',
          autoDismissible: true,
          actionType: ActionType.Default,
          color: null,
        ),
        NotificationActionButton(
          key: 'ACCEPT_MESSAGE',
          label: 'Lire',
          autoDismissible: true,
          actionType: ActionType.Default,
          color: const Color.fromARGB(0, 59, 74, 247),
        ),
      ],
    );
  }

  _flash() {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 10,
        channelKey: CSNotification.STD_CHANNEL_KEY,
        title: 'Simple Notification',
        body: 'Simple body',
        customSound: '',
        bigPicture: null,
        summary: null,
        actionType: ActionType.Default,
        // actionType: ActionType.Default,
        category: NotificationCategory.Promo,
        // category: NotificationCategory.Message,
        badge: 1,
        wakeUpScreen: true,
        notificationLayout: NotificationLayout.Default,
        // notificationLayout: NotificationLayout.BigPicture,
        payload: {}, // Theme same notification content.
      ),
      actionButtons: [
        NotificationActionButton(
          key: 'IGNORE_NOTIFICATION',
          label: 'Ingorer',
          autoDismissible: true,
          actionType: ActionType.Default,
          color: const Color.fromARGB(0, 59, 74, 247),
        ),
        NotificationActionButton(
          key: 'MARK_AS_READ',
          label: 'Marquer comme lu',
          autoDismissible: true,
          actionType: ActionType.Default,
          color: null,
        ),
        NotificationActionButton(
          key: 'ACCEPT_MESSAGE',
          label: 'Lire',
          autoDismissible: true,
          actionType: ActionType.Default,
          color: const Color.fromARGB(0, 59, 74, 247),
        ),
      ],
    );
  }
}

class _OnActionsEventListeners {
  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async {
    // Handler action with payload.
  }

  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(ReceivedAction receivedAction) async {
    // Send ignore notification.
  }

  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(ReceivedNotification receivedNotification) async {}

  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(ReceivedNotification receivedNotification) async {}
}
