import 'package:cfc_christ/configs/c_constants.dart';
import 'package:cfc_christ/configs/c_styled_text_tags.dart';
import 'package:cfc_christ/views/components/c_images_grid_group_view_component.dart';
import 'package:cfc_christ/views/screens/echo/read_echo_screen.dart';
import 'package:faker/faker.dart' hide Image;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:styled_text/widgets/styled_text.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

class CEchoNewCardListComponent extends StatelessWidget {
  const CEchoNewCardListComponent({super.key});

  @override
  Widget build(BuildContext context) {
    // final TapGestureRecognizer openEcho = TapGestureRecognizer()
    //   ..onTap = () => GoRouter.of(context).pushNamed(ReadEchoScreen.routeName);

    return Card(
      elevation: .0,
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(CConstants.GOLDEN_SIZE),
        child: Column(
          children: [
            // --- POSTER -->
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Padding(
                padding: EdgeInsets.only(right: CConstants.GOLDEN_SIZE),
                child: CircleAvatar(
                  radius: CConstants.GOLDEN_SIZE * 2,
                  backgroundImage: AssetImage('lib/assets/pictures/smil_man.jpg'),
                ),
              ),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(Faker().person.name(), style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(
                  "Pool de ${Faker().address.city()}",
                  style: Theme.of(context).textTheme.labelSmall,
                  overflow: TextOverflow.ellipsis,
                ),
                Text("il y a 7h", style: Theme.of(context).textTheme.labelSmall),
              ]),
            ]),

            // --- Title -->
            Row(children: [
              const Padding(
                padding: EdgeInsets.all(CConstants.GOLDEN_SIZE / 2),
                child: Icon(CupertinoIcons.radiowaves_right, size: CConstants.GOLDEN_SIZE * 1.5),
              ),
              Expanded(
                child: Text(
                  Faker().lorem.words(7).join(' '),
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ]),

            // --- SMALL DESCRIPTIONS -->
            GestureAnimator(
              child: StyledText(
                text: "${Faker().lorem.sentences(7).join(' ')} <blue>Lire la suite</blue>",
                tags: CStyledTextTags().tags,
              ),
              onTap: () => context.pushNamed(ReadEchoScreen.routeName),
            ),

            // --- PICTURES -->
            const SizedBox(height: CConstants.GOLDEN_SIZE),
            const CImagesGridGroupViewComponent(),

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
                icon: const Icon(CupertinoIcons.heart, size: CConstants.GOLDEN_SIZE * 2),
                label: const Text("Favaris"),
                style: const ButtonStyle(visualDensity: VisualDensity.compact),
              ),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(CupertinoIcons.news, size: CConstants.GOLDEN_SIZE * 2),
                label: const Text("Lire"),
                style: const ButtonStyle(visualDensity: VisualDensity.compact),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
