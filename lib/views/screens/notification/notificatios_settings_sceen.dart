import 'package:cfc_christ/configs/c_constants.dart';
import 'package:cfc_christ/views/layouts/empty_layout.dart';
import 'package:flutter/material.dart';

class NotificatiosSettingsScreen extends StatefulWidget {
  static const String routeName = 'notification.settings';
  static const String routePath = 'settings';

  const NotificatiosSettingsScreen({super.key});

  @override
  State<NotificatiosSettingsScreen> createState() => _NotificatiosSettingsScreenState();
}

class _NotificatiosSettingsScreenState extends State<NotificatiosSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return EmptyLayout(
      child: Scaffold(
        appBar: AppBar(title: const Text('Paramètres des notifications')),

        // --- Body :
        body: ListView(children: [
          const SizedBox(height: CConstants.GOLDEN_SIZE),
          SwitchListTile(
            value: true,
            title: const Text("Recevoir des notifications"),
            subtitle: Text(
              "Si activé, l'application recevra des notifications en arrière plan. "
              "Optimale si vous voulez rester à l'écoute des activités.",
              style: Theme.of(context).textTheme.labelSmall,
            ),
            onChanged: (state) {},
          ),
        ]),
      ),
    );
  }
}
