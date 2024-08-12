import 'package:cfc_christ/configs/c_constants.dart';
import 'package:cfc_christ/views/components/c_com_card_list_component.dart';
import 'package:cfc_christ/views/components/c_echo_card_list_component.dart';
import 'package:cfc_christ/views/components/c_enseignement_card_list_component.dart';
import 'package:cfc_christ/views/layouts/empty_layout.dart';
import 'package:flutter/material.dart';

class UserPublicationsListScreen extends StatefulWidget {
  static const String routeName = 'user.publications';
  static const String routePath = 'publications';

  const UserPublicationsListScreen({super.key});

  @override
  State<UserPublicationsListScreen> createState() => _UserPublicationsListScreenState();
}

class _UserPublicationsListScreenState extends State<UserPublicationsListScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: Scaffold(
        appBar: AppBar(title: const Text('Mes publications')),
        body: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: CConstants.GOLDEN_SIZE * 43),
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.all(CConstants.GOLDEN_SIZE),
                  child: Text("Contient la liste des tout vos publications.", style: Theme.of(context).textTheme.labelSmall),
                ),
                Row(children: [
                  const Text("12 Publications"),
                  const Spacer(),
                  FilledButton.tonalIcon(
                    icon: const Icon(Icons.filter_alt),
                    label: const Text("Filtrer"),
                    onPressed: () {},
                  )
                ]),

                // --- List :
                const CComCardListComponent(showTypeLabel: true),
                const CEchoCardListComponent(showTypeLabel: true),
                const CEnseignementCardListComponent(showTypeLabel: true),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
