import 'package:cfc_christ/configs/c_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

class UserFamilyCoupleScreen extends StatefulWidget {
  static const String routeName = 'family.couple';
  static const String routePath = 'my/couple';

  const UserFamilyCoupleScreen({super.key});

  @override
  State<UserFamilyCoupleScreen> createState() => _UserFamilyCoupleScreenState();
}

class _UserFamilyCoupleScreenState extends State<UserFamilyCoupleScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mon couple')),

      // --- Body :
      body: ListView(children: [
        Padding(
          padding: const EdgeInsets.all(CConstants.GOLDEN_SIZE),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            WidgetAnimator(
              incomingEffect: WidgetTransitionEffects.incomingSlideInFromLeft(duration: const Duration(milliseconds: 500)),
              child: const Column(children: [
                CircleAvatar(
                  radius: CConstants.GOLDEN_SIZE * 5,
                  backgroundImage: AssetImage('lib/assets/pictures/smil_man.jpg'),
                ),
                Text("hacp0012"),
              ]),
            ),
            const SizedBox(width: CConstants.GOLDEN_SIZE),
            const Icon(CupertinoIcons.link),
            const SizedBox(width: CConstants.GOLDEN_SIZE),
            WidgetAnimator(
              incomingEffect: WidgetTransitionEffects.incomingSlideInFromRight(duration: const Duration(milliseconds: 500)),
              child: const Column(children: [
                CircleAvatar(radius: CConstants.GOLDEN_SIZE * 5, child: Icon(CupertinoIcons.search)),
                Text("Aucune"),
              ]),
            ),
          ]),
        ),
        Column(children: [
          TextAnimator("Le couple : aliquid conceptam", incomingEffect: WidgetTransitionEffects.incomingScaleDown()),
        ]),

        // --- Infos :
        Card(
          margin: const EdgeInsets.symmetric(vertical: CConstants.GOLDEN_SIZE * 2, horizontal: CConstants.GOLDEN_SIZE),
          child: Padding(
            padding: const EdgeInsets.only(
              left: CConstants.GOLDEN_SIZE,
              right: CConstants.GOLDEN_SIZE,
              bottom: CConstants.GOLDEN_SIZE,
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Text('Nom Lorem ipsum dolor', style: Theme.of(context).textTheme.titleMedium),
                const Spacer(),
                IconButton(onPressed: () {}, icon: const Icon(Icons.settings)),
              ]),
              const SizedBox(height: CConstants.GOLDEN_SIZE),
              const Text("💍 Marié depuis 23/12/2003"),
              const Text("🏠 Habite : Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam"),
            ]),
          ),
        ),

        // --- Enfants :
        const SizedBox(height: CConstants.GOLDEN_SIZE * 3),
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: CConstants.GOLDEN_SIZE * 42),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text("NOS ENFANTS", style: TextStyle(fontWeight: FontWeight.w200)),
                const SizedBox(width: CConstants.GOLDEN_SIZE),
                Expanded(child: Divider(thickness: 0.0, color: Theme.of(context).colorScheme.primary)),
              ]),
            ]),
          ),
        ),

        // --- LIST :
        ...List<Widget>.generate(
          3,
          (int index) => ListTile(
            leading: Badge(
              isLabelVisible: index == 1 ? true : false,
              label: const Text("Utilisateur", style: TextStyle(fontSize: CConstants.GOLDEN_SIZE)),
              padding: const EdgeInsets.symmetric(
                horizontal: CConstants.GOLDEN_SIZE - 7,
                vertical: CConstants.GOLDEN_SIZE - 8,
              ),
              alignment: Alignment.bottomLeft,
              offset: const Offset(CConstants.GOLDEN_SIZE - 13, -9.0),
              child: const CircleAvatar(child: Icon(CupertinoIcons.person)),
            ),
            title: Text("${index + 1} : doctus tractatos sociosqu"),
            subtitle: Text(index == 2 ? "Celibataire" : "Marié"),
            trailing: PopupMenuButton(
              itemBuilder: (context) => [
                const PopupMenuItem(child: ListTile(title: Text("Modifie"), leading: Icon(Icons.edit))),
                const PopupMenuItem(child: ListTile(title: Text("Supprimer"), leading: Icon(CupertinoIcons.trash))),
              ],
            ),
          ),
        ),

        // --- ADD :
        const SizedBox(height: CConstants.GOLDEN_SIZE),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: CConstants.GOLDEN_SIZE * 2,
            vertical: CConstants.GOLDEN_SIZE * 1,
          ),
          child: FilledButton.tonal(onPressed: () {}, child: const Text("➕ Ajouter un enfant")),
        ),
      ]),
    );
  }
}
