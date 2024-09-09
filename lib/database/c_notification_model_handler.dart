// ignore_for_file: constant_identifier_names

import 'dart:convert';

import 'package:cfc_christ/configs/c_api.dart';
import 'package:cfc_christ/database/app_preferences.dart';
import 'package:cfc_christ/env.dart';
import 'package:cfc_christ/services/notification/c_s_notification.dart';
import 'package:flutter/foundation.dart';

class CNotificationModelHandler {
  final _appPreference = CAppPreferences().instance;

  static final Map notificationTemplate = {
    "id": "00000000-0000-0000-0000-000000000001",
    "type": null,
    "notifiable_type": null,
    "notifiable_id": null,
    "data": {
      "id": 801,
      "group": "DEFAULT",
      "type": "DEFAUT",
      "shedules": [],
      "subject_id": null,
      "max_visible": 1,
      "notification": {
        "title": "This is default Notification",
        "body": "Dolores culpa non accusamus assumenda incidunt eius quidem quidem officiis quae.",
        "picture": null,
        "logo": null
      }
    },
    "read_at": null,
    "created_at": DateTime.now().toIso8601String(),
    "updated_at": DateTime.now().toIso8601String(),
  };

  void realoadPreference() => _appPreference?.reload();

  List get notifications {
    String? rawData = _appPreference?.getString(Env.NOTIFICATION_STORE_NAME);

    if (rawData != null) {
      List data = jsonDecode(rawData) as List;
      return data;
    }

    return [];
  }

  bool get enabled {
    bool? state = _appPreference?.getBool(CSNotification.CAN_RECEIVE_NOTIFICATIONS_KEY);

    return state ?? true;
  }

  set enabled(bool state) => _appPreference?.setBool(CSNotification.CAN_RECEIVE_NOTIFICATIONS_KEY, state);

  // METHODS -----------------------------------------------------------------------------------------------------------------
  void reloadBgNotificationPreferences() {
    // var service = FlutterBackgroundService();
    // service.invoke('UPDATE_PREFERENCE_STORAGE');
  }

  void download() async {
    Map data = {'f': 'download'};

    CApi.request.post('/feature/notification/request/handler', data: data).then(
      (res) {
        debugPrint('[DOWNLOADING NOTIFICATIONS] -->------------------------:SUCCESS');
        if (res.data is List && (res.data as List).isNotEmpty) {
          _sayThenks();

          _store(res.data);
          CSNotification().pusher.pushAll(res.data);

          // FlutterBackgroundService().invoke(
          //   CSNotification.UPDATE_NOTIFICATION_BG_SERVICE,
          //   {'count': (res.data as List).length},
          // );
        }
      },
      onError: (error) {
        debugPrint('Notification error : --> ------------------------------------------------:ERROR');
        if (kDebugMode) print(error);
      },
    );
  }

  _sayThenks() {
    Map data = {'f': 'mark_all_as_read'};

    CApi.request.post('/feature/notification/request/handler', data: data).then((res) {}, onError: (error) {});
  }

  _store(List notifications) {
    List updatedList = this.notifications;

    bool add = true;
    for (Map notification in notifications) {
      for (Map pNotification in this.notifications) {
        if (notification['id'] == pNotification['id']) add = false;
      }

      if (add) updatedList.add(notification);

      add = true;
    }

    // Store.
    _appPreference?.setString(Env.NOTIFICATION_STORE_NAME, jsonEncode(updatedList));
  }

  void markAsRead(String notificationId) {
    List updatedList = [];

    for (Map notification in notifications) {
      if (notification['id'] == notificationId && notification['data']?['type'] == 'DEFAULT') {
        //
      } else if (notification['id'] == notificationId && notification['data']?['type'] == 'WAKE') {
        if ((notification['data']['max_visible'] - 1) <= 0) {
          notification['data']['max_visible'] -= 1;
          notification['read_at'] = DateTime.now().toIso8601String();
        }
      } else if (notification['id'] == notificationId && notification['data']?['type'] == 'STD') {
        notification['read_at'] = DateTime.now().toIso8601String();
      } else if (notification['id'] == notificationId && notification['data']?['type'] == 'FLASH') {
        notification['read_at'] = DateTime.now().toIso8601String();
      }
      updatedList.add(notification);
    }

    _appPreference?.setString(Env.NOTIFICATION_STORE_NAME, jsonEncode(updatedList));

    cleanReads();
  }

  void cleanReads() {
    List updatedList = [];

    for (Map notification in notifications) {
      if (notification['read_at'] == null) updatedList.add(notification);
    }

    _appPreference?.setString(Env.NOTIFICATION_STORE_NAME, jsonEncode(updatedList));

    reloadBgNotificationPreferences();
  }

  int count() {
    return notifications.length;
  }

  Map? get(String notificationId) {
    for (Map notification in notifications) {
      if (notification['id'] == notificationId) return notification;
    }

    return null;
  }

  void clean() {
    _appPreference?.setString(Env.NOTIFICATION_STORE_NAME, '[]');
    reloadBgNotificationPreferences();
  }

  void update(Map notification) {
    List updated = [];

    for (Map element in notifications) {
      if (element['id'] == notification['id']) {
        updated.add(notification);
      } else {
        updated.add(element);
      }
    }

    _appPreference?.setString(Env.NOTIFICATION_STORE_NAME, jsonEncode(updated));
  }

  void storeDefaultModel() {
    return;
    // List models = [
    //   {
    //     "id": "00000000-0000-0000-0000-000000000002",
    //     "type": null,
    //     "notifiable_type": null,
    //     "notifiable_id": null,
    //     "data": {
    //       "id": 810,
    //       "group": "DEFAULT",
    //       "type": "DEFAUT",
    //       "shedules": [],
    //       "subject_id": null,
    //       "notification": {
    //         "title": "This is default Notification",
    //         "body": "Dolores culpa non accusamus assumenda incidunt eius quidem quidem officiis quae.",
    //         "picture": null,
    //         "logo": null
    //       }
    //     },
    //     "read_at": null,
    //     "created_at": DateTime.now().toIso8601String(),
    //     "updated_at": DateTime.now().toIso8601String(),
    //   }
    // ];
    //
    // if (notifications.isEmpty) {
    //   _store(models);
    //
    //   reloadBgNotificationPreferences();
    // }
  }
}
