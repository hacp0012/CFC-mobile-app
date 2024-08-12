import 'package:cfc_christ/configs/c_constants.dart';
import 'package:cfc_christ/views/layouts/empty_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewEchoScreen extends StatefulWidget {
  static const String routeName = 'echo.new';
  static const String routePath = 'new';

  const NewEchoScreen({super.key});

  @override
  State<NewEchoScreen> createState() => _NewEchoScreenState();
}

class _NewEchoScreenState extends State<NewEchoScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: Scaffold(
        appBar: AppBar(title: const Text('Nouvelle écho'), actions: [
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(CupertinoIcons.paperplane, size: CConstants.GOLDEN_SIZE * 2),
            label: const Text("Publier"),
          ),
        ]),

        // -- BODY :
        body: ListView(children: [
          const Padding(
            padding: EdgeInsets.all(CConstants.GOLDEN_SIZE),
            child: TextField(
              decoration: InputDecoration(
                isCollapsed: false,
                hintText: "Entrer le titre de l'écho",
                labelText: "Titre",
                border: InputBorder.none,
                prefixIcon: Icon(CupertinoIcons.bookmark_fill),
              ),
            ),
          ),

          // --- Visibilite :
          Padding(
            padding: const EdgeInsets.all(CConstants.GOLDEN_SIZE),
            child: InkWell(
              child: Row(children: [
                const Icon(CupertinoIcons.globe),
                const SizedBox(width: CConstants.GOLDEN_SIZE),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text("Visibilite"),
                    Text(
                      "Cillum pariatur in do amet deserunt laborum deserunt.",
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ]),
                ),
              ]),
              onTap: () {},
            ),
          ),

          // --- Attache FIle :
          Card(
            margin: const EdgeInsets.all(CConstants.GOLDEN_SIZE),
            child: Row(children: [
              IconButton.outlined(onPressed: () {}, icon: const Icon(Icons.attach_file)),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text("Attacher un document : .docx, .doc ou .pdf"),
                  Text("nom du comment risus quaestio quaeque noster", style: Theme.of(context).textTheme.labelMedium),
                  const SizedBox(height: CConstants.GOLDEN_SIZE),
                  Text("⚠️ Les fichier pdf ne sont pas supporter pour le rendu audio.",
                      style: Theme.of(context).textTheme.labelSmall),
                ]),
              ),
            ]),
          ),

          // --- Text body :
          const Padding(
            padding: EdgeInsets.all(CConstants.GOLDEN_SIZE),
            child: TextField(
              decoration: InputDecoration(
                labelText: "Echo en texte (non obligatoire) ...",
                hintText: "Écrivez le cours de vôtre écho ici ...",
                border: InputBorder.none,
                // prefixIcon: Icon(CupertinoIcons.t_bubble),
              ),
              maxLines: null,
              keyboardType: TextInputType.multiline,
            ),
          ),
        ]),
      ),
    );
  }
}
