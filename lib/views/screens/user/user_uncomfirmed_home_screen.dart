import 'dart:convert';

import 'package:cfc_christ/configs/c_api.dart';
import 'package:cfc_christ/configs/c_constants.dart';
import 'package:cfc_christ/configs/c_styled_text_tags.dart';
import 'package:cfc_christ/database/app_preferences.dart';
import 'package:cfc_christ/model_view/auth/login_mv.dart';
import 'package:cfc_christ/model_view/user_mv.dart';
import 'package:cfc_christ/theme/c_transition_thme.dart';
import 'package:cfc_christ/views/layouts/empty_layout.dart';
import 'package:cfc_christ/views/screens/app/contactus_screen.dart';
import 'package:cfc_christ/views/screens/user/partials/user_partial_profile_photo_component.dart';
import 'package:cfc_christ/views/screens/user/profile_setting_screen.dart';
import 'package:cfc_christ/views/widgets/c_snackbar_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:styled_text/widgets/styled_text.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

class UserUncomfirmedHomeScreen extends StatefulWidget {
  static const String routeName = 'child.uncofirmed.home';
  static const String routePath = 'child/uncofirmed/home';

  const UserUncomfirmedHomeScreen({super.key});

  static const String parentStoreKey = '292ccb4e-f867-4af1-a1df-23c82e0b9d26';

  @override
  State createState() => _UserUncomfirmedHomeScreenState();
}

class _UserUncomfirmedHomeScreenState extends State<UserUncomfirmedHomeScreen> {
  // DATAS -------------------------------------------------------------------------------------------------------------------
  bool loadingCheckConfirmation = false;
  Map? userData = UserMv.data;
  Map parentsDatas = {'father': null, 'mother': null, 'couple': null};

  // INITIALIZER -------------------------------------------------------------------------------------------------------------
  @override
  void setState(VoidCallback fn) => super.setState(fn);

  @override
  void initState() {
    super.initState();

    downloadParentDatas();
  }

  // VIEW --------------------------------------------------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('CFC'),
          actions: [
            TextButton.icon(
              onPressed: () => context.pushNamed(ProfileSettingScreen.routeName),
              icon: const Icon(Icons.edit, size: CConstants.GOLDEN_SIZE * 2),
              iconAlignment: IconAlignment.end,
              label: const Text('Modifier'),
            ),
          ],
        ),

        // Body.
        body: ListView(children: [
          const UserPartialProfilePhotoComponent(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: CConstants.GOLDEN_SIZE * 2),
            child: Visibility(
              visible: loadingCheckConfirmation,
              replacement: TextButton.icon(
                onPressed: () => startCheckingIfComfirmed(),
                icon: const Icon(CupertinoIcons.search_circle),
                label: const Text("Vérifier si c'est comfirmer"),
              ).animate(effects: CTransitionsTheme.model_1),
              child: Padding(
                padding: const EdgeInsets.all(CConstants.GOLDEN_SIZE * 2 + 4),
                child: const LinearProgressIndicator(
                  borderRadius: BorderRadius.all(Radius.circular(CConstants.GOLDEN_SIZE / 2)),
                ).animate(effects: CTransitionsTheme.model_1),
              ),
            ),
          ),
          // const Divider(),
          const SizedBox(height: CConstants.GOLDEN_SIZE * 3),
          WidgetAnimator(
            atRestEffect: WidgetRestingEffects.swing(),
            child: const Icon(CupertinoIcons.question_circle, size: CConstants.GOLDEN_SIZE * 5),
          ),
          Padding(
            padding: const EdgeInsets.all(CConstants.GOLDEN_SIZE),
            child: StyledText.selectable(
              text: "Amen ${userData?['civility'] == 'F' ? 'cher' : 'chere'} <bold>${userData?['name']}</bold>. "
                  '<br/>'
                  '<br/>'
                  "Merci de vous être inscrit sur cette plateforme. "
                  '<br/>'
                  "Selon notre politique, vous ne pouvez utiliser cette plateforme que "
                  "dans la mesure où vous avez un parent membre de la CFC. "
                  '<br/>'
                  '<br/>'
                  "Cela dit, nous avons envoyé une demande d'approbation de parenté au couple "
                  "<bold>${parentsDatas['couple']?['nom'] ?? 'inconnu'}</bold> "
                  "(Frère <bold>${parentsDatas['father']?['name'] ?? "<xsmall>indisponible pour l'instants</xsmall>"}</bold> et sœur "
                  "<bold>${parentsDatas['mother']?['name'] ?? "<xsmall>indisponible pour l'instants</xsmall>"})</bold>. Assurez vous que l'un d'eux la "
                  "validite. Si votre demande est rejetée, votre compte sera "
                  "bloqué voire même supprimé.",
              tags: CStyledTextTags().tags,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(CConstants.GOLDEN_SIZE * 2),
            child: FilledButton.icon(
              onPressed: () => context.pushNamed(ContactusScreen.routeName),
              label: const Text("Contactez un responsable"),
            ),
          ).animate(effects: CTransitionsTheme.model_1),
        ]),
      ),
    );
  }

  // METHODES ----------------------------------------------------------------------------------------------------------------
  void startCheckingIfComfirmed() {
    setState(() => loadingCheckConfirmation = true);

    LoginMv().downloadAndInstallUserDatas(
      onFinish: () {
        Map? userData = UserMv.data;

        if (userData?['child_state'] == 'COMFIRMED') {
          _cleanParentsData();

          context.go('/');
        } else {
          setState(() => loadingCheckConfirmation = false);
          CSnackbarWidget(context, content: const Text("Votre demande n'est pas encore confirmé."), defaultDuration: true);
        }
      },
      onFailed: () {
        setState(() => loadingCheckConfirmation = false);
        CSnackbarWidget(
          context,
          content: const Text("La vérification a échoué. \nVérifier l'état de votre connexion internet."),
          defaultDuration: true,
        );
      },
    );
  }

  void downloadParentDatas() {
    String? parentData = CAppPreferences().instance?.getString(UserUncomfirmedHomeScreen.parentStoreKey);

    if (parentData == null) {
      // Download data from server.
      CApi.request.get('/user/child/parents/via/validable').then(
        (response) {
          if (response.data['father'] != null && response.data['mother'] != null) {
            setState(() => parentsDatas = response.data);

            // Convert and store on var.
            CAppPreferences().instance?.setString(UserUncomfirmedHomeScreen.parentStoreKey, jsonEncode(response.data));
          } /*  else {
            _showSnackbar("Impossible de ce connecter pour télécharger les données parents.");
          } */
        },
        onError: (error) {
          _showSnackbar("Impossible de ce connecter pour télécharger les données parents.");
        },
      );
    } else {
      // Convert and store on var.
      parentsDatas = jsonDecode(parentData);
    }
  }

  void _showSnackbar(String text) => CSnackbarWidget(context, content: Text(text), defaultDuration: true);

  void _cleanParentsData() => CAppPreferences().instance?.remove(UserUncomfirmedHomeScreen.parentStoreKey);
}
