import 'package:cfc_christ/configs/c_constants.dart';
import 'package:cfc_christ/views/layouts/empty_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class NewTeachingScreen extends StatefulWidget {
  static const String routeName = 'teaching.new';
  static const String routePath = 'new';

  const NewTeachingScreen({super.key});

  @override
  State<NewTeachingScreen> createState() => _NewTeachingScreenState();
}

class _NewTeachingScreenState extends State<NewTeachingScreen> {
  bool showHeaderPhoto = false;

  @override
  void initState() => super.initState();

  @override
  void setState(VoidCallback fn) => super.setState(fn);

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Nouvelle enseignement'),
          actions: [
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(CupertinoIcons.paperplane, size: CConstants.GOLDEN_SIZE * 2),
              label: const Text("Publier"),
            ),
          ],
        ),

        // --- Body :
        body: ListView(children: [
          const Padding(
            padding: EdgeInsets.all(CConstants.GOLDEN_SIZE),
            child: TextField(
              decoration: InputDecoration(
                isCollapsed: false,
                hintText: "Entrer le titre de l'enseignement",
                labelText: "Titre",
                border: InputBorder.none,
                prefixIcon: Icon(CupertinoIcons.bookmark_fill),
              ),
            ),
          ),

          // --- Heading image :
          Padding(
            padding: const EdgeInsets.all(CConstants.GOLDEN_SIZE),
            child: Column(children: [
              Visibility(
                visible: showHeaderPhoto,
                child: Animate(
                  effects: [FadeEffect(duration: 1.seconds)],
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: CConstants.GOLDEN_SIZE * 27),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(CConstants.DEFAULT_RADIUS)),
                      child: Image.asset('lib/assets/pictures/family_2.jpg', fit: BoxFit.contain),
                    ),
                  ),
                ),
              ),

              // --- Photo button.
              Row(children: [
                FilledButton.tonalIcon(
                  onPressed: () => setState(() => showHeaderPhoto = true),
                  label: const Text("Photo detente"),
                  style: const ButtonStyle(visualDensity: VisualDensity.compact),
                  icon: const Icon(CupertinoIcons.photo),
                ),
              ]),
            ]),
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
                labelText: "Enseignement en texte (non obligatoire) ...",
                hintText: "Écrivez le cours de vôtre enseignement ici ...",
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
