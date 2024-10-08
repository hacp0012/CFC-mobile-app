import 'package:cfc_christ/views/screens/echo/read_echo_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cfc_christ/configs/c_constants.dart';
import 'package:go_router/go_router.dart';

class CEchoCardListComponent extends StatelessWidget {
  const CEchoCardListComponent({super.key, this.showTypeLabel = false, this.isInFavorite = false});

  final bool isInFavorite;
  final bool showTypeLabel;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Card(
        // color: Colors.white,
        borderOnForeground: false,
        margin: const EdgeInsets.all(CConstants.GOLDEN_SIZE),
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
                radius: CConstants.GOLDEN_SIZE * 3,
                backgroundImage: AssetImage('lib/assets/pictures/pray_wonam.jpg'),
              ),
            ),

            // --- Conconst const taints :
            const SizedBox(width: 9.0),
            Expanded(
              child: Column(children: [
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  if (showTypeLabel == false)
                    const Icon(CupertinoIcons.radiowaves_right, size: 18)
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
                      child: const Text(
                        'ECHO',
                        style: TextStyle(
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
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: CConstants.GOLDEN_SIZE - 6,
                      horizontal: CConstants.GOLDEN_SIZE - 4,
                    ),
                    decoration: BoxDecoration(
                      // color: Colors.greenAccent.shade100, // Green.
                      // color: Colors.red.shade100, // Red.
                      color: Colors.black, // Black.
                      borderRadius: BorderRadius.circular(CConstants.DEFAULT_RADIUS),
                    ),
                    child: Text("Prévu", style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.white)),
                  ),
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
      ),
      onTap: () => context.pushNamed(ReadEchoScreen.routeName),
    );
  }
}
