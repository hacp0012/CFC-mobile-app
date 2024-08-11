import 'package:cfc_christ/configs/c_constants.dart';
import 'package:cfc_christ/views/components/c_audio_player_widget_component.dart';
import 'package:cfc_christ/views/components/c_comments_view_handler_component.dart';
import 'package:cfc_christ/views/layouts/empty_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReadCommScreen extends StatefulWidget {
  static const String routeName = 'comm.read';
  static const String routePath = 'read';

  const ReadCommScreen({super.key});

  @override
  State<ReadCommScreen> createState() => _ReadCommScreenState();
}

class _ReadCommScreenState extends State<ReadCommScreen> {
  @override
  Widget build(BuildContext context) {
    return EmptyLayout(
      child: Scaffold(
        appBar: AppBar(title: const Text('Communiquer'), actions: [
          IconButton(onPressed: () {}, icon: const Icon(CupertinoIcons.heart)),
        ]),

        // --- Body :
        body: ListView(padding: const EdgeInsets.symmetric(horizontal: CConstants.GOLDEN_SIZE), children: [
          const SizedBox(height: CConstants.GOLDEN_SIZE),
          Row(children: [
            const Icon(CupertinoIcons.news),
            const SizedBox(width: CConstants.GOLDEN_SIZE),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(CConstants.DEFAULT_RADIUS),
              ),
              child: Text(
                "COMMUNIQUER",
                style: Theme.of(context).textTheme.labelMedium?.copyWith(color: CConstants.LIGHT_COLOR),
              ),
            ),
            const SizedBox(width: CConstants.GOLDEN_SIZE),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
              decoration: BoxDecoration(
                // color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(CConstants.DEFAULT_RADIUS),
              ),
              child: Text("Pool de Bukavu",
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Colors.black,
                      )),
            ),
            const Spacer(),
            const SizedBox(width: CConstants.GOLDEN_SIZE),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
              decoration: BoxDecoration(
                color: Colors.green.shade400,
                borderRadius: BorderRadius.circular(CConstants.DEFAULT_RADIUS),
              ),
              child: Text("Prévu", style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.black)),
            ),
          ]),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: CConstants.GOLDEN_SIZE),
            child: SelectableText(
              "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam "
              "text text",
              style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
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
                  "3 Commantaires",
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ]),
            ]),
          ),
          const Divider(),

          // --- TEXT BODY :
          const SizedBox(height: CConstants.GOLDEN_SIZE * 2),
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
                  // fontFamily: CConstants.FONT_FAMILY_PRIMARY,
                  // fontWeight: FontWeight.normal,
                ),
          ),

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

          // --- AUDIO :
          const SizedBox(height: CConstants.GOLDEN_SIZE * 3),
          Text("Écouter en audio", style: Theme.of(context).textTheme.titleMedium),
          const CAudioPlayerWidgetComponent(),

          // --- COMMENTS :
          const SizedBox(height: CConstants.GOLDEN_SIZE * 3),
          Text("Laisser un commentaire", style: Theme.of(context).textTheme.titleMedium),
          const CCommentsViewHandlerComponent(),
        ]),
      ),
    );
  }
}
