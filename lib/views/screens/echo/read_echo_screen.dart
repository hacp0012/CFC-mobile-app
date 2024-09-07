import 'package:cfc_christ/configs/c_constants.dart';
import 'package:cfc_christ/configs/c_styled_text_tags.dart';
import 'package:cfc_christ/services/c_s_audio_palyer.dart';
import 'package:cfc_christ/views/components/c_comments_view_handler_component.dart';
import 'package:cfc_christ/views/components/c_images_grid_group_view_component.dart';
import 'package:cfc_christ/views/layouts/default_layout.dart';
import 'package:cfc_christ/views/widgets/c_audio_reader_widget.dart';
import 'package:cfc_christ/views/widgets/c_tts_reader_widget.dart';
import 'package:faker/faker.dart' hide Image;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:styled_text/widgets/styled_text.dart';

class ReadEchoScreen extends StatefulWidget {
  static const String routeName = 'echo.read';
  static const String routePath = 'read';

  const ReadEchoScreen({super.key});

  @override
  State<ReadEchoScreen> createState() => _ReadEchoScreenState();
}

class _ReadEchoScreenState extends State<ReadEchoScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: Scaffold(
        appBar: AppBar(
            title: const Row(
              children: [
                Icon(CupertinoIcons.radiowaves_right),
                SizedBox(width: CConstants.GOLDEN_SIZE),
                Text('Echo'),
              ],
            ),
            actions: [
              IconButton(onPressed: () {}, icon: const Icon(CupertinoIcons.heart)),
            ]),

        // --- Body :
        body: ListView(padding: const EdgeInsets.all(CConstants.GOLDEN_SIZE), children: [
          // --- PICTURES -->
          const CImagesGridGroupViewComponent(),

          // --- BODY -->
          const SizedBox(height: CConstants.GOLDEN_SIZE),
          Row(children: [
            const Padding(
              padding: EdgeInsets.only(right: CConstants.GOLDEN_SIZE),
              child: CircleAvatar(
                radius: CConstants.GOLDEN_SIZE * 2.5,
                backgroundImage: AssetImage('lib/assets/pictures/smil_man.jpg'),
              ),
            ),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(Faker().person.name(), style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(
                "Pool de ${Faker().address.city()}",
                style: Theme.of(context).textTheme.labelSmall,
              ),
              Text("il y a 7h", style: Theme.of(context).textTheme.labelSmall),
            ]),
          ]),

          // --- Title -->
          const SizedBox(height: CConstants.GOLDEN_SIZE),
          Row(children: [
            Expanded(child: Text(Faker().lorem.sentence(), style: Theme.of(context).textTheme.titleMedium)),
            // TTS reader :
            CTtsReaderWidget.icon(
              text: () => """soupira le renard.
Mais le renard revint son idée. Ma vie est monotone. 
Je chasse les poules, les hommes me chassent. 
Toutes les poules se ressemblent, et tous les hommes se ressemblent. 
Je m’ennuie donc un peu. Mais, si tu m’apprivoises, ma vie sera comme ensoleillée. 
Je connaîtrai un bruit de pas qui sera différent de tous les autres. 
Les autres pas me font rentrer sous terre. 
Le tien m’appellera hors du terrier, comme une musique. 
Et puis regarde! Tu vois, là—bas, les champs de blé? Je ne mange pas de pain. 
Le blé pour moi est inutile. Les champs de blé ne me rappellent rien. 
Et ça, c’est triste! Mais tu as des cheveux couleur d’or. 
Alors ce sera merveilleux quand tu m’auras apprivoisé! 
Le blé, qui est doré, me fera souvenir de toi. Etj’aimerai le bruit du vent dans le blé...»
Le renard se tut et regarda longtemps le petit prince.
S’il te plaît... apprivoise-moi, dit-il.
""",
            ),
          ]),

          // --- SMALL DESCRIPTIONS -->
          const SizedBox(height: CConstants.GOLDEN_SIZE),
          StyledText(
            text: "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod "
                "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod "
                "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod \n\n"
                "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod "
                "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod "
                "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod \n\n"
                "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod "
                "tempor invidunt ut labore et dolore... ",
            tags: CStyledTextTags().tags,
          ),

          // --- AUDIO :
          const SizedBox(height: CConstants.GOLDEN_SIZE * 3),
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

          // --- LIKES AND COMMENT TEXT -->
          const SizedBox(height: CConstants.GOLDEN_SIZE),
          Padding(
            padding: const EdgeInsets.all(CConstants.GOLDEN_SIZE),
            child: Row(children: [
              Row(children: [
                const Icon(CupertinoIcons.hand_thumbsup_fill, size: CConstants.GOLDEN_SIZE),
                Text(
                  "123 K",
                  style: Theme.of(context).textTheme.labelSmall,
                )
              ]),
              const SizedBox(width: CConstants.GOLDEN_SIZE * 2),
              Row(children: [
                const Icon(CupertinoIcons.eye, size: CConstants.GOLDEN_SIZE),
                const SizedBox(width: CConstants.GOLDEN_SIZE),
                Text(
                  "123 vues",
                  style: Theme.of(context).textTheme.labelSmall,
                )
              ]),
              const Spacer(),
              Text("123 Commentaires", style: Theme.of(context).textTheme.labelSmall),
            ]),
          ),

          // --- KIKES BUTTONS -->
          const Divider(indent: CConstants.GOLDEN_SIZE, endIndent: CConstants.GOLDEN_SIZE),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(CupertinoIcons.hand_thumbsup, size: CConstants.GOLDEN_SIZE * 2),
              label: const Text("J'aime"),
              style: const ButtonStyle(visualDensity: VisualDensity.compact),
            ),
            // TextButton.icon(
            //   onPressed: () {},
            //   icon: const Icon(CupertinoIcons.chat_bubble, size: CConstants.GOLDEN_SIZE * 2),
            //   label: const Text("Commenter"),
            //   style: const ButtonStyle(visualDensity: VisualDensity.compact),
            // ),
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(CupertinoIcons.heart, size: CConstants.GOLDEN_SIZE * 2),
              label: const Text("Favaris"),
              style: const ButtonStyle(visualDensity: VisualDensity.compact),
            ),
          ]),

          // --- COMMENTS :
          const SizedBox(height: CConstants.GOLDEN_SIZE * 3),
          Text("Laisser un commentaire", style: Theme.of(context).textTheme.titleMedium),
          const CCommentsViewHandlerComponent(),
        ]),
      ),
    );
  }
}
