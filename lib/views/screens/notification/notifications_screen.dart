import 'package:cfc_christ/configs/c_constants.dart';
import 'package:cfc_christ/views/components/c_notification_card_list_component.dart';
import 'package:cfc_christ/views/layouts/empty_layout.dart';
import 'package:cfc_christ/views/screens/notification/notificatios_settings_sceen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

class NotificationsScreen extends StatefulWidget {
  static const String routeName = 'notification.list';
  static const String routePath = '/notofication';

  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    return EmptyLayout(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Notifications'),
          actions: [
            IconButton(
              onPressed: () => context.pushNamed(NotificatiosSettingsScreen.routeName),
              icon: const Icon(Icons.settings).animate(onPlay: (controller) => controller.repeat(period: 3.seconds)).rotate(),
            ),
          ],
        ),

        // --- Body :
        body: ListView(children: [
          const Padding(
            padding: EdgeInsets.all(CConstants.GOLDEN_SIZE),
            child: Row(
              children: [
                Icon(CupertinoIcons.bell_circle),
                SizedBox(width: CConstants.GOLDEN_SIZE),
                Text("9 Notifications non lus"),
              ],
            ),
          ),
          const Divider(),
          ...AnimateList(
            interval: 450.ms,
            effects: [FadeEffect(duration: 1.seconds), SlideEffect(duration: 500.ms)],
            children: List<Widget>.generate(9, (int index) => const CNotificationCardListComponent()),
          )
        ]),
      ),
    );
  }
}
