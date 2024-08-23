import 'package:cfc_christ/configs/c_constants.dart';
import 'package:cfc_christ/configs/c_styled_text_tags.dart';
import 'package:cfc_christ/model_view/validable_mv.dart';
import 'package:cfc_christ/views/screens/user/validable/child_validable_screen.dart';
import 'package:cfc_christ/views/screens/user/validable/partner_validable_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:styled_text/widgets/styled_text.dart';
import 'package:date_time_format/date_time_format.dart';

class CValidableListCardComponent extends StatelessWidget {
  final BuildContext context;

  const CValidableListCardComponent({super.key, required this.context, required this.validable});
  // DATAS -------------------------------------------------------------------------------------------------------------------
  final Map validable;

  // INITIALIZER -------------------------------------------------------------------------------------------------------------

  // VIEW --------------------------------------------------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    DateTime date = DateTime.parse(validable['created_at']);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: CConstants.GOLDEN_SIZE / 2),
      elevation: .0,
      child: Padding(
        padding: const EdgeInsets.all(CConstants.GOLDEN_SIZE),
        child: Builder(builder: (context) {
          if (validable['type'] == ValidableMv.TYPE_CHILD_BIND || validable['type'] == ValidableMv.TYPE_CHILD_CAN_MARIED) {
            return Column(mainAxisSize: MainAxisSize.min, children: [
              // HEEAD :
              Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                const CircleAvatar(child: Icon(CupertinoIcons.person_add, size: CConstants.GOLDEN_SIZE * 3)),
                const SizedBox(width: CConstants.GOLDEN_SIZE),
                Expanded(
                  child: Text(
                    "Demande d'approbation pour un enfant",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ]),

              // DETAIL :
              const SizedBox(height: CConstants.GOLDEN_SIZE),
              StyledText(
                text: "Cette demande vous est soumis par un utilisateur qui indique que vous "
                    "faites partie des ses parents. Vous devez savoir que une fois la demande "
                    "accordée, la personne sera ajouté dans votre liste d'enfants que vous pouvez "
                    "retrouver dans la rubrique famille puis mon couple dans votre profil."
                    "<br/>"
                    "<br/>"
                    '<italic>'
                    "Appuyé sur le bouton plus des détails pour procéder à la validation ou rejeter cette demande"
                    '</italic>',
                tags: CStyledTextTags().tags,
              ),

              // ACTIONS :
              const SizedBox(height: CConstants.GOLDEN_SIZE),
              Row(children: [
                Text(date.format('D, j M à H:i')),
                const Spacer(),
                FilledButton(
                  onPressed: () => openValidation(ValidableMv.TYPE_CHILD_BIND),
                  style: const ButtonStyle(
                    visualDensity: VisualDensity.compact,
                    // foregroundColor: WidgetStatePropertyAll(Colors.red),
                  ),
                  child: const Text("Plus des details"),
                ),
              ])
            ]);
          } else if (validable['type'] == ValidableMv.TYPE_COUPLE_BIND) {
            return Column(mainAxisSize: MainAxisSize.min, children: [
              // HEEAD :
              Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                const CircleAvatar(child: Icon(CupertinoIcons.person_2, size: CConstants.GOLDEN_SIZE * 3)),
                const SizedBox(width: CConstants.GOLDEN_SIZE),
                Expanded(
                  child: Text(
                    "Demande d'approbation pour un partenaire conjugale",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ]),

              // DETAIL :
              const SizedBox(height: CConstants.GOLDEN_SIZE),
              StyledText(
                text: "Cette demande vous est soumis par une personne qui indique que vous êtes "
                    "sont partenaire. Vous devez savoir que une fois la demande accordée, "
                    "la personne sera considérée comme votre époue ou épouse. "
                    '<br/>'
                    '<br/>'
                    '<italic>'
                    "Appuyé sur le bouton plus des détails pour procéder à la validation ou rejeter cette demande"
                    '</italic>',
                tags: CStyledTextTags().tags,
              ),

              // ACTIONS :
              const SizedBox(height: CConstants.GOLDEN_SIZE),
              Row(children: [
                Text(date.format('D, j M à H:i')),
                const Spacer(),
                FilledButton(
                  onPressed: () => openValidation(ValidableMv.TYPE_COUPLE_BIND),
                  style: const ButtonStyle(
                    visualDensity: VisualDensity.compact,
                    // foregroundColor: WidgetStatePropertyAll(Colors.red),
                  ),
                  child: const Text("Plus des details"),
                ),
              ])
            ]);
          } else {
            return const Column(mainAxisSize: MainAxisSize.min, children: [
              Text("Element no reconue"),
            ]);
          }
        }),
      ),
    );
  }

  // METHODES ----------------------------------------------------------------------------------------------------------------
  void openValidation(String type) {
    // showDialog(
    //   context: context,
    //   builder: (context) {
    //     return const AlertDialog(
    //       content: Text("En attente de la partie familiale. Pour enfin développer cette fonctionnalité."),
    //     ).animate(effects: CTransitionsTheme.model_1);
    //   },
    // );

    if (type == ValidableMv.TYPE_CHILD_BIND || type == ValidableMv.TYPE_CHILD_CAN_MARIED) {
      context.pushNamed(ChildValidableScreen.routeName, extra: validable);
    } else if (type == ValidableMv.TYPE_COUPLE_BIND) {
      context.pushNamed(PartnerValidableScreen.routeName, extra: validable);
    }
  }
}
