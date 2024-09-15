import 'package:cfc_christ/classes/c_sections_types_enum.dart';
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
import 'package:go_router/go_router.dart';
import 'package:styled_text/widgets/styled_text.dart';

class ReadEchoScreen extends StatefulWidget {
  static const String routeName = 'echo.read';
  static const String routePath = 'read';

  const ReadEchoScreen({super.key, required this.echoId});

  final String? echoId;

  @override
  State<ReadEchoScreen> createState() => _ReadEchoScreenState();
}

class _ReadEchoScreenState extends State<ReadEchoScreen> {
  // DATA -->-----------------------------------------------------------------------------------------------------------------
  Map echoData = {};
  Map reactionsData = {};

  bool favState = false;

  // INITIALIZER -->----------------------------------------------------------------------------------------------------------
  @override
  void initState() {
    super.initState();

    if (widget.echoId == null) context.pop();
  }

  // VIEW -->-----------------------------------------------------------------------------------------------------------------
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
            CTtsReaderWidget.icon(text: () => ""),
          ]),

          // --- SMALL DESCRIPTIONS -->
          const SizedBox(height: CConstants.GOLDEN_SIZE),
          StyledText(
            text: "Lorem ipsum ",
            tags: CStyledTextTags().tags,
          ),

          // --- Download document -->
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Expanded(
              child: TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.download, size: CConstants.GOLDEN_SIZE * 2),
                label: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text("Télécharger le document associé"),
                  Text("document.ext", style: Theme.of(context).textTheme.labelSmall),
                ]),
                style: const ButtonStyle(visualDensity: VisualDensity.compact, alignment: Alignment.centerLeft),
              ),
            ),
          ]),

          // --- AUDIO :
          const SizedBox(height: CConstants.GOLDEN_SIZE * 3),
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
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(CupertinoIcons.hand_thumbsup, size: CConstants.GOLDEN_SIZE * 2),
              label: const Text("J'aime"),
              style: const ButtonStyle(visualDensity: VisualDensity.compact),
            ),
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(CupertinoIcons.heart, size: CConstants.GOLDEN_SIZE * 2),
              label: const Text("Favaris"),
              style: const ButtonStyle(visualDensity: VisualDensity.compact),
            ),
          ]),

          // --- COMMENTS :
          const SizedBox(height: CConstants.GOLDEN_SIZE * 3),
          Text("Commentaires", style: Theme.of(context).textTheme.titleMedium),
          CCommentsViewHandlerComponent(section: CSectionsTypesEnum.echo, id: widget.echoId ?? '---'),
        ]),
      ),
    );
  }

  // METHODS -->--------------------------------------------------------------------------------------------------------------
  load() {}

  loadReactions() {}

  putAReadReaction() {}

  likeThis() {}

  loadFavState() {}

  toggleFaveState() {}

  openUserProfile(String userId) {}
}
