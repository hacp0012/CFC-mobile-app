import 'package:cfc_christ/configs/c_constants.dart';
import 'package:cfc_christ/configs/c_styled_text_tags.dart';
import 'package:cfc_christ/views/screens/echo/read_echo_screen.dart';
import 'package:faker/faker.dart' hide Image;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:styled_text/widgets/styled_text.dart';

class CEchoNewCardListComponent extends StatelessWidget {
  const CEchoNewCardListComponent({super.key});

  @override
  Widget build(BuildContext context) {
    // final TapGestureRecognizer openEcho = TapGestureRecognizer()
    //   ..onTap = () => GoRouter.of(context).pushNamed(ReadEchoScreen.routeName);

    return Card(
      elevation: .0,
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          // --- POSTER -->
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
                Text(Faker().person.name(), style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(
                  Faker().address.city(),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.grey.shade600, height: 1),
                ),
                Text("il y a 7h", style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.grey.shade600)),
              ]),
            ]),
          ),

          // --- Title -->
          Text(
            Faker().lorem.words(7).join(' '),
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleMedium,
          ),

          // --- SMALL DESCRIPTIONS -->
          InkWell(
            child: StyledText(
              text: "${Faker().lorem.sentences(7).join(' ')} <blue>Lire la suite</blue>",
              tags: CStyledTextTags().tags,
            ),
            onTap: () => context.pushNamed(ReadEchoScreen.routeName),
          ),

          // --- PICTURES -->
          const SizedBox(height: CConstants.GOLDEN_SIZE),
          SizedBox(
            height: 270,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(CConstants.GOLDEN_SIZE),
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
        ],
      ),
    );
  }
}
