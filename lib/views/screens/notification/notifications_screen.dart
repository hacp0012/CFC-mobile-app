import 'package:cfc_christ/configs/c_constants.dart';
import 'package:cfc_christ/configs/c_network_state.dart';
import 'package:cfc_christ/model_view/notification_mv.dart';
import 'package:cfc_christ/states/c_default_state.dart';
import 'package:cfc_christ/theme/c_transition_thme.dart';
import 'package:cfc_christ/views/components/c_notification_card_list_component.dart';
import 'package:cfc_christ/views/layouts/default_layout.dart';
import 'package:cfc_christ/views/screens/notification/notificatios_settings_sceen.dart';
import 'package:cfc_christ/views/widgets/c_snackbar_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:watch_it/watch_it.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

class NotificationsScreen extends StatefulWidget with WatchItStatefulWidgetMixin {
  static const String routeName = 'notification.list';
  static const String routePath = '/notofication';

  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  // DATAS -------------------------------------------------------------------------------------------------------------------
  List notificaitons = [];

  // INITIALIZERS ------------------------------------------------------------------------------------------------------------
  void _s(fn) => super.setState(fn);

  @override
  void initState() {
    super.initState();

    getList();
  }

  // VIEW --------------------------------------------------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    int counts = watchValue<CDefaultState, int>((CDefaultState s) {
      getList();
      return s.notificationsCount;
    });

    bool onlineState = watchValue((CNetworkState o) => o.online);

    return DefaultLayout(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Notifications'),
          actions: [
            IconButton(
              onPressed: clear,
              icon: const Icon(CupertinoIcons.trash_slash),
            ),
            IconButton(
              onPressed: () => context.pushNamed(NotificatiosSettingsScreen.routeName),
              icon: const Icon(Icons.settings)
                  .animate(onPlay: (controller) => controller.repeat())
                  .rotate(duration: 15.seconds),
            ),
          ],
        ),

        // --- Body :
        body: ListView(children: [
          Padding(
            padding: const EdgeInsets.all(CConstants.GOLDEN_SIZE),
            child: Row(
              children: [
                WidgetAnimator(atRestEffect: WidgetRestingEffects.swing(), child: const Icon(CupertinoIcons.bell_circle)),
                const SizedBox(width: CConstants.GOLDEN_SIZE),
                Text("${counts == 0 ? NotificationMv.count() : counts} Notifications non lus"),
              ],
            ),
          ),
          const Divider(),
          ...AnimateList(
            interval: 108.ms,
            effects: [FadeEffect(duration: 360.ms), SlideEffect(duration: 360.ms, begin: const Offset(0.0, 0.4))],
            children: notificaitons
                .map(
                  (element) => Dismissible(
                    key: Key(element['id']),
                    onDismissed: (direction) => onDismiss(element),
                    direction: DismissDirection.endToStart,
                    background: Container(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: CConstants.GOLDEN_SIZE * 2),
                          child: Text("Supprimer", style: TextStyle(color: Theme.of(context).colorScheme.error)),
                        )),
                    child: CNotificationCardListComponent(
                      notification: element,
                      onlineState: onlineState,
                      onOpend: () => getList(),
                    ),
                  ),
                )
                .toList(),
          )
        ]),
      ),
    );
  }

  // METHODS -----------------------------------------------------------------------------------------------------------------
  Future<void> getList() async => _s(() => notificaitons = NotificationMv().getList().reversed.toList());

  void onDismiss(Map notification) => _s(() {
        NotificationMv().markAsRead(notification['id']);
        CSnackbarWidget.direct(const Text("Notification supprimé"), defaultDuration: true);
      });

  void _clear() => _s(() {
        NotificationMv.clear();
        CSnackbarWidget.direct(const Text("Notifications vidé"), defaultDuration: true);
      });

  void clear() {
    showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Attention"),
        content: const Text("Vider tout la liste des notifications ?"),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          TextButton(onPressed: () => context.pop(), child: const Text("Annuler")),
          TextButton(
              onPressed: () {
                context.pop();
                _clear();
              },
              child: const Text("Oui vider")),
        ],
      ).animate(effects: CTransitionsTheme.model_1),
    );
  }
}
