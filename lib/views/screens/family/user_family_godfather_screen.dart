import 'package:cfc_christ/configs/c_constants.dart';
import 'package:cfc_christ/configs/c_styled_text_tags.dart';
import 'package:cfc_christ/theme/c_transition_thme.dart';
import 'package:cfc_christ/views/layouts/empty_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:styled_text/styled_text.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

class UserFamilyGodfatherScreen extends StatefulWidget {
  static const String routeName = 'family.godfather';
  static const String routePath = 'godfather';

  const UserFamilyGodfatherScreen({super.key});

  @override
  State<UserFamilyGodfatherScreen> createState() => _UserFamilyGodfatherScreenState();
}

class _UserFamilyGodfatherScreenState extends State<UserFamilyGodfatherScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: Scaffold(
        appBar: AppBar(title: const Text('Parrainage')),

        // BODY.
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: CConstants.GOLDEN_SIZE),
          children: [
            const SizedBox(height: CConstants.GOLDEN_SIZE * 3),
            Card.filled(
              child: Padding(
                padding: const EdgeInsets.all(CConstants.GOLDEN_SIZE),
                child: Column(
                  children: [
                    WidgetAnimator(
                      atRestEffect: WidgetRestingEffects.swing(),
                      child: const Icon(CupertinoIcons.exclamationmark_circle, size: CConstants.GOLDEN_SIZE * 4),
                    ),
                    const SizedBox(height: CConstants.GOLDEN_SIZE),
                    StyledText(
                      text: "Ici apparaîtra la liste des enfants dont vous n'êtes pas le parent biologique "
                          "mais dont vous êtes le responsable, le représentant ou le parent moral.",
                      tags: CStyledTextTags().tags,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ).animate(effects: CTransitionsTheme.model_1),
          ],
        ),
      ),
    );
  }
}
