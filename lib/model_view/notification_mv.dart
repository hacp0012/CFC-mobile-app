import 'package:cfc_christ/configs/c_api.dart';
import 'package:cfc_christ/database/c_notification_model_handler.dart';
import 'package:cfc_christ/services/notification/c_s_notification.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

class NotificationMv {
  void open(Map notification) {
    CSNotification().pusher.open(notification);
  }

  void markAsRead(String notificationId) {
    CNotificationModelHandler().markAsRead(notificationId);
    FlutterBackgroundService().invoke(CSNotification.CAN_RECEIVE_NOTIFICATIONS_KEY);
  }

  List getList() {
    List list = CNotificationModelHandler().notifications;

    return list;
  }

  static Future<int> checkOnline() async {
    var data = await CApi.request.post('/feature/notification/request/handler', data: {'f': 'count'});

    if ((data.data['count'] as int) > 0) CNotificationModelHandler().realoadPreference();

    return data.data['count'] as int;
  }

  static int count() => CNotificationModelHandler().notifications.length;

  static bool enabled([bool? setState]) {
    if (setState != null) {
      CNotificationModelHandler().enabled = setState;
      FlutterBackgroundService().invoke('UPDATE_PREFERENCE_STORAGE');

      return setState;
    } else {
      return CNotificationModelHandler().enabled;
    }
  }

  static void clear() {
    CNotificationModelHandler().clean();
    FlutterBackgroundService().invoke(CSNotification.CAN_RECEIVE_NOTIFICATIONS_KEY);
  }
}
