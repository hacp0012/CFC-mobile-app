import 'package:cfc_christ/configs/c_constants.dart';
import 'package:cfc_christ/model_view/notification_mv.dart';
import 'package:cfc_christ/views/layouts/default_layout.dart';
import 'package:cfc_christ/views/widgets/c_snackbar_widget.dart';
import 'package:flutter/material.dart';

class NotificatiosSettingsScreen extends StatefulWidget {
  static const String routeName = 'notification.settings';
  static const String routePath = 'settings';

  const NotificatiosSettingsScreen({super.key});

  @override
  State<NotificatiosSettingsScreen> createState() => _NotificatiosSettingsScreenState();
}

class _NotificatiosSettingsScreenState extends State<NotificatiosSettingsScreen> {
  // DATAS -------------------------------------------------------------------------------------------------------------------

  // INITIALIZERE ------------------------------------------------------------------------------------------------------------
  void _s(fn) => super.setState(fn);

  // VIEWS -------------------------------------------------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: Scaffold(
        appBar: AppBar(title: const Text('Paramètres des notifications')),

        // --- Body :
        body: ListView(children: [
          const SizedBox(height: CConstants.GOLDEN_SIZE),
          SwitchListTile(
            value: NotificationMv.enabled(),
            title: Text("Recevoir des notifications (${NotificationMv.enabled() ? 'activé' : 'désactivé'})"),
            subtitle: Text(
              "Si activé, l'application recevra des notifications en arrière plan. "
              "Optimale si vous voulez rester à l'écoute des activités.",
              style: Theme.of(context).textTheme.labelSmall,
            ),
            onChanged: (state) => _s(() {
              CSnackbarWidget.direct(Text("Notification ${state ? 'activé' : 'désactivé'}"), defaultDuration: true);
              return NotificationMv.enabled(state);
            }),
          ),
        ]),
      ),
    );
  }

  // METHODS -----------------------------------------------------------------------------------------------------------------
  // _showSnackbar(String message) {
  //   Setup.globalKey.currentState?.showSnackBar(SnackBar(content: Text(message)));
  // }
}
