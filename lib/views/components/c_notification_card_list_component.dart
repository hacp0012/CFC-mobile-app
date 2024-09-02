import 'package:cfc_christ/classes/c_misc_class.dart';
import 'package:cfc_christ/configs/c_constants.dart';
import 'package:cfc_christ/configs/c_network_state.dart';
import 'package:cfc_christ/model_view/notification_mv.dart';
import 'package:cfc_christ/views/screens/comm/read_comm_screen.dart';
import 'package:cfc_christ/views/screens/echo/read_echo_screen.dart';
import 'package:cfc_christ/views/screens/home/home_screen.dart';
import 'package:cfc_christ/views/screens/teaching/read_teaching_screen.dart';
import 'package:cfc_christ/views/screens/user/validable_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

class CNotificationCardListComponent extends StatelessWidget {
  const CNotificationCardListComponent({super.key, required this.notification, this.onlineState = true, this.onOpend});

  final Map notification;
  final bool onlineState;
  final Function()? onOpend;

  @override
  Widget build(BuildContext context) {
    Map notificationContent = notification['data']['notification'];

    return GestureAnimator(
      child: Card(
        margin: const EdgeInsets.all(CConstants.GOLDEN_SIZE),
        child: Padding(
          padding: const EdgeInsets.all(CConstants.GOLDEN_SIZE),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            CircleAvatar(
              radius: CConstants.GOLDEN_SIZE * 3,
              child: Icon(
                <String, IconData>{
                      'WELLCOME': CupertinoIcons.tag,
                      'TEACHING': CupertinoIcons.book,
                      'COMMUNICATION': CupertinoIcons.news,
                      'ECHO': CupertinoIcons.radiowaves_right,
                      'VALIDABLE': CupertinoIcons.person_crop_circle_badge_checkmark,
                    }[notification['data']['group']] ??
                    CupertinoIcons.bell,
              ),
            ),

            // -- Body :
            const SizedBox(width: CConstants.GOLDEN_SIZE),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  // const Icon(CupertinoIcons.envelope, size: CConstants.GOLDEN_SIZE * 2),
                  const Icon(CupertinoIcons.bell, size: CConstants.GOLDEN_SIZE * 2),
                  const SizedBox(width: CConstants.GOLDEN_SIZE),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: CConstants.GOLDEN_SIZE - 5),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(CConstants.DEFAULT_RADIUS),
                    ),
                    child: Text(
                      <String, String>{
                            'WELLCOME': 'Msg de bienvenue',
                            'TEACHING': "Enseignement",
                            'COMMUNICATION': 'Communiqué',
                            'ECHO': "écho",
                          }[notification['data']['group']] ??
                          "Notification",
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),

                  // Date :
                  const Spacer(),
                  Text(
                    CMiscClass.date(DateTime.parse(notification['created_at'])).ago(),
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ]),

                // --- Message :
                Text(notificationContent['title'], style: Theme.of(context).textTheme.titleSmall),
                Text(
                  notificationContent['body'],
                  maxLines: 9,
                  overflow: TextOverflow.ellipsis,
                  // style: Theme.of(context).textTheme.labelMedium,
                ),
              ]),
            )
          ]),
        ),
      ),
      onTap: () => open(context),
    );
  }

  // METHODS -----------------------------------------------------------------------------------------------------------------
  void open(BuildContext context) {
    CNetworkState.ifOnline(context, onlineState, () {
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
        context.pushNamed(routeName, extra: {'id': notification['data']['subject_id']});
        NotificationMv().markAsRead(notification['id']);
        onOpend?.call();
      }
    });
  }
}
