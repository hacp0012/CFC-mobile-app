import 'package:cfc_christ/configs/c_constants.dart';
import 'package:cfc_christ/views/layouts/empty_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserEditPcnScreen extends StatefulWidget {
  static const String routeName = 'user.edit.pcn';
  static const String routePath = 'edit/pcn';

  const UserEditPcnScreen({super.key});

  @override
  State<UserEditPcnScreen> createState() => _UserEditPcnScreenState();
}

class _UserEditPcnScreenState extends State<UserEditPcnScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: Scaffold(
        appBar: AppBar(title: const Text('PCN'), actions: [
          TextButton.icon(
            onPressed: () {},
            label: const Text("Enregistrer"),
            icon: const Icon(CupertinoIcons.square_favorites_alt, size: CConstants.GOLDEN_SIZE * 2),
          )
        ]),

        // --- BODY :
        body: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: CConstants.GOLDEN_SIZE * 42),
              child: Column(
                children: [
                  const SizedBox(height: CConstants.GOLDEN_SIZE),
                  const Text("Pool, Communauté locale et Noyau d’affermissement"),
                  const SizedBox(height: CConstants.GOLDEN_SIZE),
                  Text(
                    "data Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy "
                    "eirmod tempor invidunt ut labore et dolore"
                    "data",
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: CConstants.GOLDEN_SIZE * 2),
                  const DropdownButtonHideUnderline(
                    child: DropdownMenu(label: Text("Pool"), width: double.infinity, dropdownMenuEntries: []),
                  ),
                  const SizedBox(height: CConstants.GOLDEN_SIZE * 2),
                  const DropdownButtonHideUnderline(
                    child: DropdownMenu(
                      label: Text("Communauté locale"),
                      width: double.infinity,
                      dropdownMenuEntries: [],
                    ),
                  ),
                  const SizedBox(height: CConstants.GOLDEN_SIZE * 2),
                  const DropdownButtonHideUnderline(
                    child: DropdownMenu(
                      label: Text("Noyau d’affermissement"),
                      width: double.infinity,
                      dropdownMenuEntries: [],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
