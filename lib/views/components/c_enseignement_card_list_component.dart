import 'package:cfc_christ/classes/c_misc_class.dart';
import 'package:cfc_christ/views/screens/teaching/read_teaching_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cfc_christ/configs/c_constants.dart';
import 'package:go_router/go_router.dart';

class CEnseignementCardListComponent extends StatelessWidget {
  const CEnseignementCardListComponent({super.key, this.showTypeLabel = false, this.isInFavorite = false});

  final bool isInFavorite;
  final bool showTypeLabel;

  @override
  Widget build(BuildContext context) {
    return Card(
      // color: Colors.white,
      borderOnForeground: false,
      margin: const EdgeInsets.all(CConstants.GOLDEN_SIZE),
      child: InkWell(
        child: Padding(
          padding: const EdgeInsets.all(CConstants.GOLDEN_SIZE),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Badge(
              isLabelVisible: isInFavorite,
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              padding: const EdgeInsets.symmetric(horizontal: 1.0),
              label: const Icon(CupertinoIcons.heart, size: 12),
              offset: const Offset(-3.0, 0.0),
              child: const CircleAvatar(
                radius: CConstants.GOLDEN_SIZE * 4,
                backgroundImage: AssetImage('lib/assets/pictures/church_logo.jpg'),
              ),
            ),

            // --- Conconst const taints :
            const SizedBox(width: 9.0),
            Expanded(
              child: Column(children: [
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const SizedBox(width: CConstants.GOLDEN_SIZE / 2),
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

                  // --- Secondary :
                  const SizedBox(width: CConstants.GOLDEN_SIZE),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: CConstants.GOLDEN_SIZE - 6,
                      horizontal: CConstants.GOLDEN_SIZE - 4,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(CConstants.DEFAULT_RADIUS),
                    ),
                    child: Text('Pool de Bukavu', style: Theme.of(context).textTheme.labelSmall),
                  ),

                  // --- State badget :
                  const Spacer(),
                  Text("17 avr 2024", style: Theme.of(context).textTheme.labelSmall),
                ]),

                // --- Texts :
                const Text("Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam", maxLines: 2),

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
            ),
          ]),
        ),
        onTap: () => context.pushNamed(ReadTeachingScreen.routeName),
      ),
    );
  }
}
