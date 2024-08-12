import 'package:cfc_christ/configs/c_constants.dart';
import 'package:cfc_christ/views/components/c_audio_player_widget_component.dart';
import 'package:cfc_christ/views/components/c_comments_view_handler_component.dart';
import 'package:cfc_christ/views/layouts/empty_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
        appBar: AppBar(title: const Text('Echo'), actions: [
          IconButton(onPressed: () {}, icon: const Icon(CupertinoIcons.heart)),
        ]),

        // --- Body :
        body: ListView(padding: const EdgeInsets.symmetric(horizontal: CConstants.GOLDEN_SIZE), children: [
          const SizedBox(height: CConstants.GOLDEN_SIZE),
          Padding(
            padding: const EdgeInsets.all(CConstants.GOLDEN_SIZE),
            child: Row(children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: CConstants.GOLDEN_SIZE),
                child: CircleAvatar(
                  radius: CConstants.GOLDEN_SIZE * 2.5,
                  backgroundImage: AssetImage('lib/assets/pictures/smil_man.jpg'),
                ),
              ),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text("nom erroribus fastidii", style: TextStyle(fontWeight: FontWeight.bold)),
                Text(
                  "pool de je ne sais ou",
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.grey.shade600, height: 1),
                ),
                Text("il y a 7h", style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.grey.shade600)),
              ]),
            ]),
          ),

          // --- Title -->
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: CConstants.GOLDEN_SIZE),
            child: Row(children: [
              Text(
                "nec vix docendi eget sapientem",
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontWeight: FontWeight.bold, color: Colors.grey.shade700),
              ),
            ]),
          ),

          // --- SMALL DESCRIPTIONS -->
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(children: [
              Expanded(
                child: RichText(
                  text: TextSpan(
                    text: "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod "
                        "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod "
                        "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod \n\n"
                        "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod "
                        "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod "
                        "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod \n\n"
                        "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod "
                        "tempor invidunt ut labore et dolore... ",
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.grey.shade700, height: 1.1),
                    // children: <TextSpan>[
                    //   TextSpan(
                    //     text: 'voir plus',
                    //     style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.blue, height: 1.1),
                    //   ),
                    // ],
                  ),
                ),
              ),
            ]),
          ),

          // --- PICTURES -->
          const SizedBox(height: CConstants.GOLDEN_SIZE),
          SizedBox(
            height: 270,
            child: Row(children: [
              Flexible(
                flex: 2,
                child: Image.asset(
                  'lib/assets/pictures/family_1.jpg',
                  fit: BoxFit.cover,
                  height: double.infinity,
                ),
              ),
              const SizedBox(width: 3.0),
              Flexible(
                flex: 1,
                child: Column(
                  children: [
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: (270 / 2) - 1.5),
                      child:
                          Image.asset('lib/assets/pictures/praying_people.jpg', fit: BoxFit.cover, height: double.infinity),
                    ),
                    const SizedBox(height: 3.0),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: (270 / 2) - 1.5),
                      child: Image.asset('lib/assets/pictures/family_2.jpg', fit: BoxFit.cover, height: double.infinity),
                    ),
                  ],
                ),
              ),
            ]),
          ),

          // --- LIKES AND COMMENT TEXT -->
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
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(CupertinoIcons.chat_bubble, size: CConstants.GOLDEN_SIZE * 2),
              label: const Text("Commenter"),
              style: const ButtonStyle(visualDensity: VisualDensity.compact),
            ),
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(CupertinoIcons.heart, size: CConstants.GOLDEN_SIZE * 2),
              label: const Text("Favaris"),
              style: const ButtonStyle(visualDensity: VisualDensity.compact),
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
