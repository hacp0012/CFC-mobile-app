import 'package:cfc_christ/configs/c_constants.dart';
import 'package:cfc_christ/configs/c_styled_text_tags.dart';
import 'package:cfc_christ/services/validable/c_s_validable.dart';
import 'package:cfc_christ/views/components/c_validable_list_card_component.dart';
import 'package:cfc_christ/views/layouts/default_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:styled_text/styled_text.dart';
import 'package:watch_it/watch_it.dart';

class ValidableScreen extends StatefulWidget with WatchItStatefulWidgetMixin {
  static const String routeName = 'validables';
  static const String routePath = 'validables';

  const ValidableScreen({super.key});

  @override
  State<ValidableScreen> createState() => _ValidableScreenState();
}

class _ValidableScreenState extends State<ValidableScreen> {
  // DATAS -------------------------------------------------------------------------------------------------------------------
  int validableCount = 0;
  Map validableData = {};

  // INITIALIZER -------------------------------------------------------------------------------------------------------------

  // VIEW --------------------------------------------------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    validableCount = watchValue<CSValidable, int>((CSValidable x) => x.counter);
    validableData = watchValue<CSValidable, Map>((CSValidable x) => x.list);

    List forCouple = validableData['couple'] ?? [];
    List forUser = validableData['user'] ?? [];
    return DefaultLayout(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Approbation'),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.all(CConstants.GOLDEN_SIZE),
              child: Badge.count(count: validableCount),
            )
          ],
        ),

        // BODY.
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: CConstants.GOLDEN_SIZE),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                // IS EMPTY.
                if (forUser.isEmpty && forCouple.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: CConstants.GOLDEN_SIZE * 3),
                    child: Card.filled(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            const Icon(CupertinoIcons.info),
                            StyledText(
                              textAlign: TextAlign.center,
                              text: "Vous n'avez aucune demande d'approbation. "
                                  '<br/>'
                                  '<br/>'
                                  "Les demandes d'approbations sont envoyés par des personnes "
                                  "désirent devenir votre partenaire, votre enfant ou autres.",
                              tags: CStyledTextTags().tags,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                // FOR COUPLE CARD.
                ...forCouple.map((element) => CValidableListCardComponent(context: context, validable: element)),

                // FOR USER CARD.
                const SizedBox(height: CConstants.GOLDEN_SIZE),
                ...forUser.map((element) => CValidableListCardComponent(context: context, validable: element)),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  // METHODES ----------------------------------------------------------------------------------------------------------------
}
