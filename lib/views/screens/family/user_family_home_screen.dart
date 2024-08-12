import 'package:cfc_christ/configs/c_constants.dart';
import 'package:cfc_christ/views/layouts/empty_layout.dart';
import 'package:cfc_christ/views/screens/family/user_family_couple_screen.dart';
import 'package:cfc_christ/views/screens/family/user_family_godfather_screen.dart';
import 'package:cfc_christ/views/screens/family/user_family_parents_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

class UserFamilyHomeScreen extends StatefulWidget {
  static const String routeName = 'family.user.home';
  static const String routePath = '/family';

  const UserFamilyHomeScreen({super.key});

  @override
  State<UserFamilyHomeScreen> createState() => _UserFamilyHomeScreenState();
}

class _UserFamilyHomeScreenState extends State<UserFamilyHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: Scaffold(
        appBar: AppBar(title: const Text('Ma famille')),

        // --- body :
        body: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: CConstants.GOLDEN_SIZE * 42),
              child: Column(children: [
                const SizedBox(height: CConstants.GOLDEN_SIZE * 2),
                WidgetAnimator(
                  atRestEffect: WidgetRestingEffects.fidget(),
                  child: const Icon(CupertinoIcons.flame, size: CConstants.GOLDEN_SIZE * 5, color: CConstants.PRIMARY_COLOR),
                ),
                Text(
                  "La famille c'est sacrée et surtout quent il est chrétienne.",
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                const SizedBox(height: CConstants.GOLDEN_SIZE * 2),
                Card(
                  child: ListTile(
                    leading: const Icon(CupertinoIcons.person_2_fill),
                    title: const Text("Mon couple"),
                    subtitle: const Text("Gérer mon couple et mes enfants."),
                    onTap: () => context.pushNamed(UserFamilyCoupleScreen.routeName),
                  ),
                ),
                Card(
                  child: ListTile(
                    title: const Text("Mes parents"),
                    leading: const Icon(CupertinoIcons.person_2_square_stack),
                    subtitle: const Text("Qui sont mes parents, le couple qui me parraine comme enfant."),
                    onTap: () => context.pushNamed(UserFamilyParentsScreen.routeName),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: const Icon(CupertinoIcons.person_2_alt),
                    title: const Text("Parrainage"),
                    subtitle: const Text("Les enfants dont je suis parrain."),
                    onTap: () => context.pushNamed(UserFamilyGodfatherScreen.routeName),
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
