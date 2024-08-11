import 'package:cfc_christ/configs/c_constants.dart';
import 'package:cfc_christ/model_view/auth/register_mv.dart';
import 'package:cfc_christ/views/layouts/empty_layout.dart';
import 'package:cfc_christ/views/widgets/c_modal_widget.dart';
import 'package:cfc_christ/views/widgets/c_snackbar_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UserDeleteAccountScreen extends StatefulWidget {
  static const String routeName = 'user.unregister';
  static const String routePath = 'delete/account';

  const UserDeleteAccountScreen({super.key});

  @override
  State<UserDeleteAccountScreen> createState() => _UserDeleteAccountScreenState();
}

class _UserDeleteAccountScreenState extends State<UserDeleteAccountScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User unregister'),
        backgroundColor: Colors.red.shade100,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(CupertinoIcons.xmark),
        ),
      ),
      body: EmptyLayout(
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: CConstants.MAX_CONTAINER_WIDTH),
              child: Column(children: [
                const SizedBox(height: CConstants.GOLDEN_SIZE * 2),
                const Icon(Icons.warning_amber, size: CConstants.GOLDEN_SIZE * 7),
                const Text("Attention"),

                // --- Body :
                const SizedBox(height: CConstants.GOLDEN_SIZE * 2),
                const Text(
                  "En continuant vous allez procéder à la suppression des toutes vos données et "
                  "cette action est irréversible car vous ne pourrez pas récupérer vos données.",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: CConstants.GOLDEN_SIZE * 2),

                // --- Action :
                ElevatedButton.icon(
                  onPressed: () {
                    CModalWidget(
                      context: context,
                      child: Padding(
                        padding: const EdgeInsets.all(CConstants.GOLDEN_SIZE),
                        child: Column(mainAxisSize: MainAxisSize.min, children: [
                          Text(
                            "Attention",
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                          ),
                          const SizedBox(height: CConstants.GOLDEN_SIZE),
                          const Text(
                            "En continuant vous allez procéder à la suppression des toutes vos données et "
                            "cette action est irréversible car vous ne pourrez pas récupérer vos données.",
                          ),
                          const SizedBox(height: CConstants.GOLDEN_SIZE),
                          Row(children: [
                            FilledButton.tonal(
                              style: ButtonStyle(
                                backgroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.error),
                                foregroundColor: const WidgetStatePropertyAll(CConstants.LIGHT_COLOR),
                              ),
                              onPressed: () {
                                CModalWidget.close(context);
                                start();
                              },
                              child: const Text("OUI, supprimer"),
                            ),
                            const Spacer(),
                            TextButton(onPressed: () => CModalWidget.close(context), child: const Text("Annuler")),
                          ]),
                        ]),
                      ),
                    ).show();
                  },
                  icon: Icon(
                    CupertinoIcons.trash_fill,
                    size: CConstants.GOLDEN_SIZE * 2,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  label: Text(
                    "Supprimer",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                  style: const ButtonStyle(surfaceTintColor: WidgetStatePropertyAll(Colors.red)),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  //  ------------------------------------------------------------------------------------------------------------------------
  void start() {
    CModalWidget(
      context: context,
      child: Padding(
        padding: const EdgeInsets.all(CConstants.GOLDEN_SIZE),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Suppression",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.error),
            ),
            const SizedBox(height: CConstants.GOLDEN_SIZE),
            LinearProgressIndicator(borderRadius: BorderRadius.circular(CConstants.GOLDEN_SIZE / 2)),
          ],
        ),
      ),
    ).show(persistant: true, unRoute: true);

    // DELETION :
    RegisterMv().unregister(
      onSuccess: () {
        context.go('/');
      },
      onFailed: () {
        CSnackbarWidget(
          context,
          content: const Text(
            "Une erreur serveur est rencontré, "
            "veuillez vérifier votre connexion internet.",
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        );
        Navigator.pop(context);
      },
    );
  }
}
