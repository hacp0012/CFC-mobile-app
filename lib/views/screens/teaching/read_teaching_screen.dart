import 'package:cfc_christ/classes/c_sections_types_enum.dart';
import 'package:cfc_christ/configs/c_constants.dart';
import 'package:cfc_christ/services/c_s_audio_palyer.dart';
import 'package:cfc_christ/services/c_s_tts.dart';
import 'package:cfc_christ/views/components/c_comments_view_handler_component.dart';
import 'package:cfc_christ/views/components/c_images_grid_group_view_component.dart';
import 'package:cfc_christ/views/layouts/default_layout.dart';
import 'package:cfc_christ/views/widgets/c_audio_reader_widget.dart';
import 'package:cfc_christ/views/widgets/c_tts_reader_widget.dart';
import 'package:faker/faker.dart' hide Image;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ReadTeachingScreen extends StatefulWidget {
  static const String routeName = 'teaching.read';
  static const String routePath = 'read';

  const ReadTeachingScreen({super.key, this.teachId});

  final String? teachId;

  @override
  State<ReadTeachingScreen> createState() => _ReadTeachingScreenState();
}

class _ReadTeachingScreenState extends State<ReadTeachingScreen> {
  // DATA ------------------------------------------------------------------------------------------------------------------->

  // INITIALIZER ------------------------------------------------------------------------------------------------------------>
  @override
  void dispose() {
    CSTts.inst.dispose();
    super.dispose();
  }

  // VIEW ------------------------------------------------------------------------------------------------------------------->
  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: Scaffold(
        appBar: AppBar(title: const Text('Enseignement'), actions: [
          IconButton(onPressed: () {}, icon: const Icon(CupertinoIcons.heart)),
        ]),

        // --- Body :
        body: ListView(padding: const EdgeInsets.symmetric(horizontal: CConstants.GOLDEN_SIZE), children: [
          const SizedBox(height: CConstants.GOLDEN_SIZE),
          Row(children: [
            const Icon(CupertinoIcons.book),
            const SizedBox(width: CConstants.GOLDEN_SIZE),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(CConstants.DEFAULT_RADIUS),
                  ),
                  child: Text(
                    "ENSEIGNEMENT",
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(color: CConstants.LIGHT_COLOR),
                  ),
                ),
                Text("Pool de ${Faker().address.city()}", style: Theme.of(context).textTheme.labelMedium),
              ]),
            ),
            // const Spacer(),
            // const SizedBox(width: CConstants.GOLDEN_SIZE),
            // Container(
            //   padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
            //   decoration: BoxDecoration(
            //     color: Colors.green.shade400,
            //     borderRadius: BorderRadius.circular(CConstants.DEFAULT_RADIUS),
            //   ),
            //   child: Text("Prévu",
            //       style: Theme.of(context).textTheme.labelMedium?.copyWith(
            //             color: Colors.black,
            //           )),
            // ),
          ]),

          const SizedBox(height: CConstants.GOLDEN_SIZE * 1),
          // --- Heading image :
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: CConstants.GOLDEN_SIZE),
            child: Animate(
              effects: [FadeEffect(duration: 1.seconds)],
              child: const CImagesGridGroupViewComponent(pictures: [null]),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: CConstants.GOLDEN_SIZE),
            child: Row(children: [
              Expanded(
                child: Text(
                  "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam "
                  "text text",
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              // TTS reader :
              CTtsReaderWidget.icon(
                text: () =>
                    """Tu te jugeras donc toi—même, lui répondit le roi. C’est le plus difficile. Il est bien plus difficile de se juger soi—même que de juger autrui. 
Si tu réussis bien te juger, c’est que tu es un véritable sage.
Moi, dit le petit prince,je puis me juger moi même n’importe où. 
Je n’ai pas besoin d’habiter ici. Hem! hem! dit le roi,je crois bien que sur ma planète il y a quelque part un vieux rat. 
je l’entends la nuit. 
Tu pourras juger ce vieux rat. Tu le condamneras mort de temps en temps. Ainsi, sa vie dépendra de ta justice. Mais tu le gracieras chaque fois pour l’économiser. 
Il n’y en a qu’un.
""",
              ),
            ]),
          ),
          FittedBox(
            child: Row(children: [
              Row(children: [
                const Icon(CupertinoIcons.clock, size: CConstants.GOLDEN_SIZE * 1.5),
                const SizedBox(width: CConstants.GOLDEN_SIZE / 2),
                Text(
                  "il y a 10 min",
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ]),
              const SizedBox(width: CConstants.GOLDEN_SIZE),
              Row(children: [
                const Icon(CupertinoIcons.eye, size: CConstants.GOLDEN_SIZE * 1.5),
                const SizedBox(width: CConstants.GOLDEN_SIZE / 2),
                Text(
                  "45 vus",
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ]),
              const SizedBox(width: CConstants.GOLDEN_SIZE),
              Row(children: [
                const Icon(CupertinoIcons.hand_thumbsup, size: CConstants.GOLDEN_SIZE * 1.5),
                const SizedBox(width: CConstants.GOLDEN_SIZE / 2),
                Text(
                  "9 j'aimes",
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ]),
              const SizedBox(width: CConstants.GOLDEN_SIZE),
              Row(children: [
                const Icon(CupertinoIcons.chat_bubble_2, size: CConstants.GOLDEN_SIZE * 1.5),
                const SizedBox(width: CConstants.GOLDEN_SIZE / 2),
                Text(
                  "3 Comm..s",
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ]),
            ]),
          ),
          const Divider(),

          // --- TEXT BODY :

          const SizedBox(height: CConstants.GOLDEN_SIZE * 1),
          SelectableText(
            "data data Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam "
            "data data Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam "
            "data data Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam "
            "data data Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam "
            "data data Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam "
            "data data Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam "
            "data data Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam "
            "data data Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam "
            "data data Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam "
            "data data",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontFamily: CConstants.FONT_FAMILY_PRIMARY,
                  fontWeight: FontWeight.normal,
                ),
          ),

          // --- AUDIO :
          const SizedBox(height: CConstants.GOLDEN_SIZE * 2),
          Text("Écouter en audio", style: Theme.of(context).textTheme.titleMedium),
          TextButton(
            onPressed: () async {
              var file = await FilePicker.platform.pickFiles(dialogTitle: "POUR TESTE", type: FileType.audio);

              setState(() {
                var demoAudioFile = file?.xFiles.first.path;
                if (demoAudioFile != null) CSAudioPalyer.inst.source = "file://$demoAudioFile";
              });
            },
            child: const Text("Sélectionnez un fichier audio ici (pour tester)"),
          ),
          const CAudioReaderWidget(audioSource: 'audioFile'),

          // --- POSTER :
          const SizedBox(height: CConstants.GOLDEN_SIZE * 3),
          Row(children: [
            const CircleAvatar(
              backgroundImage: AssetImage('lib/assets/pictures/smil_man.jpg'),
            ),
            const SizedBox(width: CConstants.GOLDEN_SIZE),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Publié par le frère", style: Theme.of(context).textTheme.labelMedium),
                Text(
                  "Publié par le frère",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ]),

          // --- ACTION BUTTONS :
          const SizedBox(height: CConstants.GOLDEN_SIZE * 3),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            FilledButton.tonal(
              onPressed: () {},
              child: const Row(
                children: [Icon(CupertinoIcons.hand_thumbsup), SizedBox(width: CConstants.GOLDEN_SIZE), Text("J'aime")],
              ),
            ),
            const SizedBox(width: CConstants.GOLDEN_SIZE),
            FilledButton.tonal(
              onPressed: () {},
              child: const Row(
                children: [
                  Icon(CupertinoIcons.download_circle),
                  SizedBox(width: CConstants.GOLDEN_SIZE),
                  Text("Télécharger le document"),
                ],
              ),
            ),
          ]),

          // --- COMMENTS :
          const SizedBox(height: CConstants.GOLDEN_SIZE * 3),
          Text("Laisser un commentaire", style: Theme.of(context).textTheme.titleMedium),
          CCommentsViewHandlerComponent(section: CSectionsTypesEnum.teaching, id: widget.teachId ?? '---'),
        ]),
      ),
    );
  }
}
