// ignore_for_file: constant_identifier_names

import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cfc_christ/app.dart';
import 'package:cfc_christ/classes/c_image_handler_class.dart';
import 'package:cfc_christ/database/app_preferences.dart';
import 'package:cfc_christ/database/c_notification_model_handler.dart';
import 'package:cfc_christ/env.dart';
import 'package:cfc_christ/views/screens/comm/read_comm_screen.dart';
import 'package:cfc_christ/views/screens/echo/read_echo_screen.dart';
import 'package:cfc_christ/views/screens/home/home_screen.dart';
import 'package:cfc_christ/views/screens/teaching/read_teaching_screen.dart';
import 'package:cfc_christ/views/screens/user/validable_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:go_router/go_router.dart';

class CSNotification {
  static const String WAKE_CHANNEL_KEY = "WAKE_NOTIFICATION";
  static const String STD_CHANNEL_KEY = "STD_NOTIFICATION";
  static const String FLASH_CHANNEL_KEY = "FLASH_NOTIFICATION";
  static const String NOTIFICATION_BG_RQ_CTR_ID = "FLASH_NOTIFICATION";

  static const String LAST_USE_TIME_OUT = 'LAST_USE_TIME_OUT';
  static const String UPDATE_NOTIFICATION_BG_SERVICE = 'UPDATE_NOTIFICATION_BG_SERVICE';
  static const String CAN_RECEIVE_NOTIFICATIONS_KEY = 'd022df1b-074b-4b33-b020-d275f030e195';

  var loader = _Loader();

  var pusher = _UiController();

  @pragma("vm:entry-point")
  static initialize() {
    AwesomeNotifications().initialize(
      // null, // "C:\Users\princ\OneDrive\Bureau\CODES\CCLOUD\CFC\mobile\android\app\src\main\ic_launcher-playstore.png"
      // "ressource://drawable/res_logo_cfc_512.png",
      // "ressource://drawable-xxxhdpi/ic_stat_1000020826.png",
      // "ressource://drawable/res_ly8k5xr98q9i606rbapt0xqp7m.xml",
      // "asset://${Env.APP_ICON_ASSET}",
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

    // Clean all reads.
    CNotificationModelHandler().cleanReads();

    // Complet with defaults notification.
    CNotificationModelHandler().storeDefaultModel();
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

  /// Handle notification buttons actions.
  void actionHandler(String notificationId, String actionKey) {
    // Actions keys :
    // ACCEPT_MESSAGE
    // MARK_AS_READ
    // IGNORE_NOTIFICATION
    Map? notification = CNotificationModelHandler().get(notificationId);

    if (notification == null) return;

    if (actionKey == 'ACCEPT_MESSAGE') {
      _UiController().open(notification);
    } else if (actionKey == 'MARK_AS_READ') {
      CNotificationModelHandler().markAsRead(notificationId);
    } else if (actionKey == 'IGNORE_NOTIFICATION') {
      // TODO: implement here. beacause ingored notification will reapeare on next load. Ex. 30 Sec
    } else if (actionKey == 'PRESSED') {
      _UiController().open(notification);
    }
  }

  // Handle UI actions requests.
  void requestController(Map<String, dynamic> request) {
    switch (request['f']) {
      case 'mark_as_read':
        CNotificationModelHandler().markAsRead(request['notification_id'] ?? '---');
        break;
    }
  }

  void updateLastUseForOneDay() {
    int now = DateTime.now().millisecondsSinceEpoch;

    int oneDay = (60 * 60 * 24) * 1000;

    CAppPreferences().instance?.setInt(LAST_USE_TIME_OUT, now + oneDay);
  }

  void updateLastUseForTowDays() {
    int now = DateTime.now().millisecondsSinceEpoch;

    int towDays = (60 * 60 * 48) * 1000;

    CAppPreferences().instance?.setInt(LAST_USE_TIME_OUT, now + towDays);
  }
}

class _Loader {
  load() async {
    // Read all unread notifications at phone startup.
    Timer(const Duration(seconds: 6), () => _UiController().pushAll(CNotificationModelHandler().notifications));

    // For downloading notifications.
    Timer.periodic(const Duration(minutes: 1), (timer) {
      if (CNotificationModelHandler().enabled) CNotificationModelHandler().download();
    });

    // For handle push.
    Timer.periodic(const Duration(hours: 1), (timer) => _Default().rememberUse());
  }
}

class _UiController {
  /// Push to notification panel.
  push(Map notification) {
    String type = notification['data']['type'];

    if (notification['read_at'] != null) return;

    switch (type) {
      case 'STD':
        _std(notification);
        break;

      case 'WAKE':
        _wake(notification);
        break;

      case 'FLASH':
        _flash(notification);
        break;

      case 'DEFAULT':
        _default(notification);
        break;
    }
  }

  pushAll(List notifications) {
    for (Map notification in notifications) {
      push(notification);
    }
  }

  _wake(Map notification) {
    Map notificationContent = notification['data']['notification'];

    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: notification['data']['id'],
        channelKey: CSNotification.WAKE_CHANNEL_KEY,
        icon: notificationContent['logo'] != null ? CImageHandlerClass.byPid(notificationContent['logo']) : null,
        largeIcon: notificationContent['logo'] != null ? CImageHandlerClass.byPid(notificationContent['logo']) : null,
        // largeIcon: null,
        title: notificationContent['title'],
        body: notificationContent['body'],
        bigPicture: notificationContent['picture'] != null ? CImageHandlerClass.byPid(notificationContent['picture']) : null,
        summary: null,
        actionType: ActionType.Default,
        // actionType: ActionType.Default,
        category: notificationContent['picture'] != null ? NotificationCategory.Promo : NotificationCategory.Message,
        // category: NotificationCategory.Message,
        badge: 1,
        wakeUpScreen: true,
        notificationLayout:
            notificationContent['picture'] != null ? NotificationLayout.BigPicture : NotificationLayout.Default,
        // notificationLayout: NotificationLayout.BigPicture,
        payload: {'notification_id': notification['id']}, // Theme same notification content.
      ),
      actionButtons: [
        // NotificationActionButton(
        //   key: 'IGNORE_NOTIFICATION',
        //   label: 'Ingorer',
        //   autoDismissible: true,
        //   actionType: ActionType.Default,
        //   color: const Color.fromARGB(0, 59, 74, 247),
        // ),
        // NotificationActionButton(
        //   key: 'MARK_AS_READ',
        //   label: 'Marquer comme lu',
        //   autoDismissible: true,
        //   actionType: ActionType.Default,
        //   color: null,
        // ),
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

  _std(Map notification) {
    Map notificationContent = notification['data']['notification'];

    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: notification['data']['id'],
        channelKey: CSNotification.STD_CHANNEL_KEY,
        icon: notificationContent['logo'] != null ? CImageHandlerClass.byPid(notificationContent['logo']) : null,
        largeIcon: notificationContent['logo'] != null ? CImageHandlerClass.byPid(notificationContent['logo']) : null,
        // largeIcon: null,
        title: notificationContent['title'],
        body: notificationContent['body'],
        bigPicture: notificationContent['picture'] != null ? CImageHandlerClass.byPid(notificationContent['picture']) : null,
        summary: {
          'WELLCOME': 'Bienvenue',
          'TEACHING': 'Enseignement',
          'COMMUNICATION': 'Communiqué',
          'ECHO': 'Écho',
          'VALIDABLE': 'Verifié',
        }[notification['data']['group']],
        actionType: ActionType.Default,
        // actionType: ActionType.Default,
        category: notificationContent['picture'] != null ? NotificationCategory.Promo : NotificationCategory.Message,
        // category: NotificationCategory.Message,
        badge: 1,
        wakeUpScreen: true,
        notificationLayout:
            notificationContent['picture'] != null ? NotificationLayout.BigPicture : NotificationLayout.BigText,
        // notificationLayout: NotificationLayout.BigPicture,
        payload: {'notification_id': notification['id']}, // Theme same notification content.
      ),
      actionButtons: [
        // NotificationActionButton(
        //   key: 'IGNORE_NOTIFICATION',
        //   label: 'Ingorer',
        //   autoDismissible: true,
        //   actionType: ActionType.Default,
        //   color: const Color.fromARGB(0, 59, 74, 247),
        // ),
        // NotificationActionButton(
        //   key: 'MARK_AS_READ',
        //   label: 'Marquer comme lu',
        //   autoDismissible: true,
        //   actionType: ActionType.Default,
        //   color: null,
        // ),
        NotificationActionButton(
          key: 'ACCEPT_MESSAGE',
          label: {
                'WELLCOME': 'Merci',
                'TEACHING': "Lire l'enseignement",
                'COMMUNICATION': 'Lire ce communiqué',
                'ECHO': "Lire l'écho",
                'VALIDABLE': 'Verifié',
              }[notification['data']['group']] ??
              'Lire',
          autoDismissible: true,
          actionType: ActionType.Default,
          color: const Color.fromARGB(0, 59, 74, 247),
        ),
      ],
    );
  }

  _flash(Map notification) {
    Map notificationContent = notification['data']['notification'];

    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: notification['data']['id'],
        channelKey: CSNotification.FLASH_CHANNEL_KEY,
        icon: notificationContent['logo'] != null ? CImageHandlerClass.byPid(notificationContent['logo']) : null,
        largeIcon: notificationContent['logo'] != null ? CImageHandlerClass.byPid(notificationContent['logo']) : null,
        // largeIcon: null,
        title: notificationContent['title'],
        body: notificationContent['body'],
        bigPicture: notificationContent['picture'] != null ? CImageHandlerClass.byPid(notificationContent['picture']) : null,
        summary: "Flash info",
        actionType: ActionType.Default,
        // actionType: ActionType.Default,
        category: notificationContent['picture'] != null ? NotificationCategory.Promo : NotificationCategory.Message,
        // category: NotificationCategory.Message,
        badge: 1,
        wakeUpScreen: true,
        notificationLayout:
            notificationContent['picture'] != null ? NotificationLayout.BigPicture : NotificationLayout.Default,
        // notificationLayout: NotificationLayout.BigPicture,
        payload: {'notification_id': notification['id']}, // Theme same notification content.
      ),
      actionButtons: [
        // NotificationActionButton(
        //   key: 'IGNORE_NOTIFICATION',
        //   label: 'Ingorer',
        //   autoDismissible: true,
        //   actionType: ActionType.Default,
        //   color: const Color.fromARGB(0, 59, 74, 247),
        // ),
        NotificationActionButton(
          key: 'MARK_AS_READ',
          label: {
                'WELLCOME': 'Merci',
                'TEACHING': "Lire l'enseignement",
                'COMMUNICATION': 'Lire ce communiqué',
                'ECHO': "Lire l'écho",
                'VALIDABLE': 'Verifié',
              }[notification['data']['group']] ??
              'OK',
          autoDismissible: true,
          actionType: ActionType.Default,
          color: null,
        ),
        // NotificationActionButton(
        //   key: 'ACCEPT_MESSAGE',
        //   label: 'Lire',
        //   autoDismissible: true,
        //   actionType: ActionType.Default,
        //   color: const Color.fromARGB(0, 59, 74, 247),
        // ),
      ],
    );
  }

  _default(Map notification) {
    Map notificationContent = notification['data']['notification'];

    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: notification['data']['id'],
        channelKey: CSNotification.WAKE_CHANNEL_KEY,
        largeIcon: "asset://${Env.APP_ICON_ASSET}",
        // icon: notificationContent['logo'] != null ? CImageHandlerClass.byPid(notificationContent['logo']) : null,
        // largeIcon: notificationContent['logo'] != null ? CImageHandlerClass.byPid(notificationContent['logo']) : null,
        // largeIcon: null,
        title: notificationContent['title'],
        body: notificationContent['body'],
        bigPicture: "asset://lib/assets/pictures/praying_people.jpg",
        // bigPicture: "http://192.168.190.6/api/v1/photo/get/45/null/logos.logo",
        // bigPicture: CImageHandlerClass.byPid(notificationContent['picture']),
        // bigPicture: notificationContent['picture'] != null ? CImageHandlerClass.byPid(notificationContent['picture']) : null,
        summary: 'Rappel',
        actionType: ActionType.Default,
        // actionType: ActionType.Default,
        category: notificationContent['picture'] != null ? NotificationCategory.Promo : NotificationCategory.Message,
        // category: NotificationCategory.Promo,
        badge: 1,
        wakeUpScreen: true,
        notificationLayout:
            notificationContent['picture'] != null ? NotificationLayout.BigPicture : NotificationLayout.BigText,
        // NotificationLayout.BigPicture,
        // notificationLayout: NotificationLayout.BigPicture,
        payload: {'notification_id': notification['id']}, // Theme same notification content.
      ),
      actionButtons: [
        // NotificationActionButton(
        //   key: 'IGNORE_NOTIFICATION',
        //   label: 'Ingorer',
        //   autoDismissible: true,
        //   actionType: ActionType.Default,
        //   color: const Color.fromARGB(0, 59, 74, 247),
        // ),
        // NotificationActionButton(
        //   key: 'MARK_AS_READ',
        //   label: 'Marquer comme lu',
        //   autoDismissible: true,
        //   actionType: ActionType.Default,
        //   color: null,
        // ),
        NotificationActionButton(
          key: 'ACCEPT_MESSAGE',
          label: "Ouvrir l'application",
          autoDismissible: true,
          actionType: ActionType.Default,
          color: const Color.fromARGB(0, 59, 74, 247),
        ),
      ],
    );
  }

  /// Open a notification content on apropriate screen.
  open(Map notification) {
    String? routeName;

    switch (notification['data']['group']) {
      case 'COMMUNICATION':
        routeName = ReadCommScreen.routeName;
      case 'ECHO':
        routeName = ReadEchoScreen.routeName;
      case 'TEACHING':
        routeName = ReadTeachingScreen.routeName;
      case 'VALIDABLE':
        routeName = ValidableScreen.routeName;
      case 'WELLCOME':
        routeName = null;
      case 'FLASH':
        routeName = null;
      case 'DEFAULT':
        routeName = HomeScreen.routeName;
    }

    if (routeName != null) {
      // GoRouter.of(Setup.globalKey.currentContext!).pushNamed(routeName, extra: {'id': notification['data']['subject_id']});
      Setup.globalKey.currentContext?.pushNamed(routeName, extra: {'id': notification['data']['subject_id']});

      // {
      // Setup.navigatorKey.currentState?.pushNamedAndRemoveUntil(
      //   '/notification-page',
      //   (route) => (route.settings.name != '/notification-page') || route.isFirst,
      //   arguments: {},
      // );

      // Setup.navigatorKey.currentState?.push(PageRouteBuilder(
      //   pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
      //     return const ReadEchoScreen();
      //   },
      // ));
      // }
    }

    CNotificationModelHandler()
      ..markAsRead(notification['id'])
      ..cleanReads();
  }
}

class _OnActionsEventListeners {
  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async {
    // Handler action with payload.
    String actionName = receivedAction.buttonKeyPressed;

    CSNotification().actionHandler(
      receivedAction.payload?['notification_id'] ?? '',
      actionName.isNotEmpty ? actionName : 'PRESSED',
    );
  }

  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(ReceivedAction receivedAction) async {
    // Send ignore notification.
    CSNotification().actionHandler(
      receivedAction.payload?['notification_id'] ?? '',
      'IGNORE_NOTIFICATION',
    );
  }

  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(ReceivedNotification receivedNotification) async {}

  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(ReceivedNotification receivedNotification) async {}
}

// ----------------------------
/*class _Wake {
  List get notifications {
    List elements = [];

    for (Map element in CNotificationModelHandler().notifications) {
      if (element['data']['type'] == 'WAKE') elements.add(element);
    }

    return elements;
  }

  void load() {
    for (Map notification in notifications) {
      if (notification['read_at'] != null) continue;

      if (notification['data']?['max_visible'] <= 0) continue;

      // Control data time.
      DateTime dateTime = DateTime.now();
      List shedules = notification['data']?['shedules'] ?? [];
      // bool push = false;
      for (Map shedule in shedules) {
        if (dateTime.weekday == shedule['week_day'] &&
            dateTime.hour == shedule['hour'] &&
            dateTime.minute == shedule['munite'] &&
            dateTime.second == (shedule['second'] ?? dateTime.second)) {
          _UiController().push(notification);
          break;
        }
      }
    }
  }
}

class _Std {
  List get notifications {
    List elements = [];

    for (Map element in CNotificationModelHandler().notifications) {
      if (element['data']['type'] == 'STD') elements.add(element);
    }

    return elements;
  }

  void load() {
    for (Map notification in notifications) {
      if (notification['read_at'] == null && notification['data']['max_visible'] >= 1) {
        notification['data']['max_visible'] -= 1;

        _UiController().push(notification);

        if (notification['data']['max_visible'] <= 0) notification['read_at'] = DateTime.now().toIso8601String();
        CNotificationModelHandler().update(notification);
      }
    }
  }
}

class _Flash {
  List get notifications {
    List elements = [];

    for (Map element in CNotificationModelHandler().notifications) {
      if (element['data']['type'] == 'FLASH') elements.add(element);
    }

    return elements;
  }

  void load() {
    for (Map notification in notifications) {
      if (notification['read_at'] != null) continue;

      _UiController().push(notification);
    }
  }
}*/

class _Default {
  List get notifications {
    List elements = [];

    for (Map element in CNotificationModelHandler().notifications) {
      if (element['data']['type'] == 'WAKE') elements.add(element);
    }

    return elements;
  }

  // Only load at week day 3 and 7.
  void load() {
    // int now = DateTime.now().weekday;

    // if (now == 3 || now == 7) {
    for (Map notification in notifications) {
      // if (notification['read_at'] != null) continue;

      _UiController().push(notification);
    }
    // }
  }

  void rememberUse() {
    int timeOut = CAppPreferences().instance?.getInt(CSNotification.LAST_USE_TIME_OUT) ?? 0;

    if (DateTime.now().millisecondsSinceEpoch > timeOut) {
      Map template = CNotificationModelHandler.notificationTemplate;

      template['data']['id'] = 9918;
      template['data']['type'] = 'DEFAULT';
      template['data']['group'] = 'DEFAULT';
      template['data']['notification'] = {
        "title": "Shalom à vous cher camarade",
        "body": "Ca ce fait longtemps que l'on ne vous est pas revues. "
            '\n\n'
            "Il y a beaucoup des choses qui ces sont passés à votre absence, nous vous sollicitons à visiter la "
            "Famille Chrétienne pour être au courant des dernières activités et enseignements.",
        "picture": 'null000',
        "logo": 'nullll'
      };

      // show notification.
      _UiController().push(template);

      // update time by one day.
      CSNotification().updateLastUseForOneDay();
    }
  }
}
