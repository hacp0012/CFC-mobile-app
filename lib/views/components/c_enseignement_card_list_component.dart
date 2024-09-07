import 'package:cfc_christ/classes/c_misc_class.dart';
import 'package:cfc_christ/views/screens/teaching/read_teaching_screen.dart';
import 'package:faker/faker.dart' hide Color, Image;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cfc_christ/configs/c_constants.dart';
import 'package:go_router/go_router.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

class CEnseignementCardListComponent extends StatelessWidget {
  const CEnseignementCardListComponent({super.key, this.showTypeLabel = false, this.isInFavorite = false});

  final bool isInFavorite;
  final bool showTypeLabel;

  @override
  Widget build(BuildContext context) {
    return Card(
      // color: Colors.white,
      borderOnForeground: false,
      elevation: 0,
      margin: const EdgeInsets.all(CConstants.GOLDEN_SIZE),
      child: GestureAnimator(
        child: Padding(
          padding: const EdgeInsets.all(CConstants.GOLDEN_SIZE),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // --> User state :
            Row(children: [
              Badge(
                isLabelVisible: isInFavorite,
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                padding: const EdgeInsets.symmetric(horizontal: 1.0),
                label: const Icon(CupertinoIcons.heart, size: 12),
                offset: const Offset(3.0, 0.0),
                child: const CircleAvatar(
                  radius: CConstants.GOLDEN_SIZE * 2,
                  backgroundImage: AssetImage('lib/assets/pictures/church_logo.jpg'),
                ),
              ),
              const SizedBox(width: CConstants.GOLDEN_SIZE),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  if (showTypeLabel == false)
                    const Icon(CupertinoIcons.book, size: 18)
                  else
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: CConstants.GOLDEN_SIZE - 6,
                        horizontal: CConstants.GOLDEN_SIZE - 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade200,
                        borderRadius: BorderRadius.circular(CConstants.DEFAULT_RADIUS),
                      ),
                      child: Text(
                        'ENSEIGNEMENT',
                        style: TextStyle(
                          color: CMiscClass.whenBrightnessOf<Color>(context, dark: Colors.black),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          fontFamily: CConstants.FONT_FAMILY_PRIMARY,
                        ),
                      ),
                    ),
                  Text(
                    'Pool de ${Faker().company.name()}',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ]),
              ),
            ]),

            // --> Conconst const taints :
            const SizedBox(width: 9.0),
            Column(children: [
              // --- Texts :
              Row(children: [
                Expanded(
                  child: Text(
                    Faker().lorem.sentence(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
              ]),

              const ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(CConstants.DEFAULT_RADIUS)),
                child: Image(
                  image: AssetImage('lib/assets/pictures/pray_hand.jpg'),
                  fit: BoxFit.cover,
                  height: CConstants.GOLDEN_SIZE * 17,
                  width: double.infinity,
                ),
              ),

              Text(
                Faker().lorem.sentences(4).join(' '),
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
                // style: Theme.of(context).textTheme.bodyMedium,
              ),

              // --- Actions :
              Padding(
                padding: const EdgeInsets.only(top: 9.0),
                child: FittedBox(
                  child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                    Row(children: [
                      const Icon(CupertinoIcons.clock, size: 16),
                      const SizedBox(width: CConstants.GOLDEN_SIZE / 2),
                      Text("il y a 15 mins", style: Theme.of(context).textTheme.labelSmall)
                    ]),

                    // --- VIEWS :
                    const SizedBox(width: CConstants.GOLDEN_SIZE),
                    Row(children: [
                      const Icon(CupertinoIcons.eye, size: 16),
                      const SizedBox(width: CConstants.GOLDEN_SIZE / 2),
                      Text("29 vues", style: Theme.of(context).textTheme.labelSmall)
                    ]),

                    // --- LIKES :
                    const SizedBox(width: CConstants.GOLDEN_SIZE),
                    Row(children: [
                      const Icon(CupertinoIcons.hand_thumbsup, size: 16),
                      const SizedBox(width: CConstants.GOLDEN_SIZE / 2),
                      Text("8 j'aims", style: Theme.of(context).textTheme.labelSmall)
                    ]),

                    // --- COMMENTS :
                    const SizedBox(width: CConstants.GOLDEN_SIZE),
                    Row(children: [
                      const Icon(CupertinoIcons.chat_bubble_2, size: 16),
                      const SizedBox(width: CConstants.GOLDEN_SIZE / 2),
                      Text("4 Commentaires", style: Theme.of(context).textTheme.labelSmall)
                    ]),
                  ]),
                ),
              ),
            ]),
          ]),
        ),
        onTap: () => context.pushNamed(ReadTeachingScreen.routeName),
      ),
    );
  }
}
