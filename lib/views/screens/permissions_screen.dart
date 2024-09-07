import 'package:cfc_christ/configs/c_constants.dart';
import 'package:cfc_christ/services/c_s_boot.dart';
import 'package:cfc_christ/services/c_s_permissions.dart';
import 'package:cfc_christ/views/layouts/default_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionsScreen extends StatefulWidget {
  static const String routeName = 'permissions.screen';
  static const String routePath = 'permisssions/screen';

  const PermissionsScreen({super.key});

  @override
  State<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends State<PermissionsScreen> {
  // DATAS ------------------------------------------------------------------------------------------------------------------>

  // INITIALIZER ------------------------------------------------------------------------------------------------------------>
  @override
  void setState(VoidCallback fn) => super.setState(fn);

  @override
  void initState() {
    super.initState();

    // EVENTS HANDLERS : ---------------------------------------------------------------------------------------------------->
    Permission.camera
        .onGrantedCallback(() => setState(() {}))
        .onDeniedCallback(() => Permission.camera.request())
        .onPermanentlyDeniedCallback(() => openAppSettings());

    Permission.accessNotificationPolicy
        .onGrantedCallback(() => setState(() {}))
        .onDeniedCallback(() => Permission.accessNotificationPolicy.request())
        .onPermanentlyDeniedCallback(() => openAppSettings());

    Permission.notification
        .onGrantedCallback(() => setState(() {}))
        .onDeniedCallback(() => Permission.notification.request())
        .onPermanentlyDeniedCallback(() => openAppSettings());

    Permission.audio
        .onGrantedCallback(() => setState(() {}))
        .onDeniedCallback(() => Permission.audio.request())
        .onPermanentlyDeniedCallback(() => openAppSettings());

    Permission.mediaLibrary
        .onGrantedCallback(() => setState(() {}))
        .onDeniedCallback(() => Permission.mediaLibrary.request())
        .onPermanentlyDeniedCallback(() => openAppSettings());

    Permission.microphone
        .onGrantedCallback(() => setState(() {}))
        .onDeniedCallback(() => Permission.microphone.request())
        .onPermanentlyDeniedCallback(() => openAppSettings());

    Permission.accessMediaLocation
        .onGrantedCallback(() => setState(() {}))
        .onDeniedCallback(() => Permission.accessMediaLocation.request())
        .onPermanentlyDeniedCallback(() => openAppSettings());
  }

  // VIEW ------------------------------------------------------------------------------------------------------------------->
  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: Scaffold(
        // --- Body :
        body: SafeArea(
          child: ListView(padding: const EdgeInsets.all(CConstants.GOLDEN_SIZE * 2), children: [
            Column(children: [
              const Icon(CupertinoIcons.shield, size: CConstants.GOLDEN_SIZE * 5, color: Colors.green),
              Text("Autorisations", style: Theme.of(context).textTheme.titleMedium),
              Text(
                "Pour bien fonctionner l'application a besoin de ces autorisations.",
                style: Theme.of(context).textTheme.labelMedium,
                textAlign: TextAlign.center,
              ),
            ]),

            // --- Permission buttons :
            const SizedBox(height: CConstants.GOLDEN_SIZE * 2),

            // --- Audio :
            FutureBuilder(
              future: Permission.audio.status,
              builder: (context, snapshot) {
                bool state = false;

                if (snapshot.hasData) state = snapshot.data?.isGranted ?? false;

                return CheckboxListTile(
                  title: const Text("Audio"),
                  subtitle: const Text("Permettre l'accès aux périphériques des sorti sonore."),
                  secondary: const Icon(CupertinoIcons.music_note),
                  isThreeLine: true,
                  value: state,
                  onChanged: (state) => setState(() => Permission.audio.request()),
                );
              },
            ),

            // --- Notification :
            FutureBuilder(
              future: Permission.notification.status,
              builder: (context, snapshot) {
                bool state = false;

                if (snapshot.hasData) state = snapshot.data?.isGranted ?? false;

                return CheckboxListTile(
                  title: const Text("Notification"),
                  subtitle: const Text("Permettre de vous envoyez des notifications."),
                  isThreeLine: true,
                  secondary: const Icon(CupertinoIcons.bell),
                  value: state,
                  onChanged: (state) => setState(() => Permission.notification.request()),
                );
              },
            ),

            // --- Notification Policy :
            FutureBuilder(
              future: Permission.accessNotificationPolicy.status,
              builder: (context, snapshot) {
                bool state = false;

                if (snapshot.hasData) state = snapshot.data?.isGranted ?? false;

                return CheckboxListTile(
                  title: const Text("La capabilité à ne pas vous déranger"),
                  subtitle: const Text("Permettre de vous envoyez des notifications programmé à des moments opportun."),
                  isThreeLine: true,
                  secondary: const Icon(CupertinoIcons.bell_slash),
                  value: state,
                  onChanged: (state) => setState(() => Permission.accessNotificationPolicy.request()),
                );
              },
            ),

            // --- Media librery :
            FutureBuilder(
              future: Permission.mediaLibrary.status,
              builder: (context, snapshot) {
                bool state = false;

                if (snapshot.hasData) state = snapshot.data?.isGranted ?? false;

                return CheckboxListTile(
                  title: const Text("Accès au médiathèque"),
                  subtitle: const Text("Permettre d'accéder au outil des gestion des médias (galerie photo)."),
                  isThreeLine: true,
                  secondary: const Icon(CupertinoIcons.film_fill),
                  value: state,
                  onChanged: (state) => setState(() => Permission.mediaLibrary.request()),
                );
              },
            ),

            // --- AccessMediaLocation :
            /*FutureBuilder(
              future: Permission.accessMediaLocation.status,
              builder: (context, snapshot) {
                bool state = false;

                if (snapshot.hasData) state = snapshot.data?.isGranted ?? false;

                return CheckboxListTile(
                  title: const Text("Accès aux fichier"),
                  subtitle: const Text("Permettre d'accéder aux fichier."),
                  isThreeLine: true,
                  secondary: const Icon(CupertinoIcons.archivebox_fill),
                  value: state,
                  onChanged: (state) => setState(() => Permission.accessMediaLocation.request()),
                );
              },
            ),*/

            // --- Microphone :
            FutureBuilder(
              future: Permission.microphone.status,
              builder: (context, snapshot) {
                bool state = false;

                if (snapshot.hasData) state = snapshot.data?.isGranted ?? false;

                return CheckboxListTile(
                  title: const Text("Accès au microphone"),
                  subtitle: const Text("Permettre d'accéder au microphone."),
                  isThreeLine: true,
                  secondary: const Icon(CupertinoIcons.mic),
                  value: state,
                  onChanged: (state) => setState(() => Permission.microphone.request()),
                );
              },
            ),

            // --- Geo location :
            CheckboxListTile(
              enabled: false,
              title: const Text("Accéder aux fonctions des géo-localisation"),
              subtitle: const Text("Nécessaire pour vous permettre de trouver d'autres CFC à proximité de chez vous."),
              isThreeLine: true,
              secondary: const Icon(CupertinoIcons.map_pin_ellipse),
              value: true,
              onChanged: (state) {},
            ),

            // --> Go :
            const SizedBox(height: CConstants.GOLDEN_SIZE * 3),
            FutureBuilder(
              future: CSPermissions.status(),
              builder: (context, snapshot) {
                bool state = false;

                if (snapshot.hasData) state = snapshot.data ?? false;

                return Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  ElevatedButton(
                    onPressed: state == false ? null : () => CSBoot.openSession(context),
                    child: const Text("Continuer"),
                  ),
                ]);
              },
            )
          ]),
        ),
      ),
    );
  }

  // METHOD ----------------------------------------------------------------------------------------------------------------->
}
