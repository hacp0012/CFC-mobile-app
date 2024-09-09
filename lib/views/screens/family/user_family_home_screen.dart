import 'package:cfc_christ/configs/c_api.dart';
import 'package:cfc_christ/configs/c_constants.dart';
import 'package:cfc_christ/configs/c_network_state.dart';
import 'package:cfc_christ/configs/c_styled_text_tags.dart';
import 'package:cfc_christ/model_view/auth/login_mv.dart';
import 'package:cfc_christ/model_view/user_mv.dart';
import 'package:cfc_christ/theme/c_transition_thme.dart';
import 'package:cfc_christ/views/layouts/default_layout.dart';
import 'package:cfc_christ/views/screens/family/user_family_couple_screen.dart';
import 'package:cfc_christ/views/screens/family/user_family_godfather_screen.dart';
import 'package:cfc_christ/views/screens/family/user_family_parents_screen.dart';
import 'package:cfc_christ/views/widgets/c_snackbar_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:styled_text/widgets/styled_text.dart';
import 'package:watch_it/watch_it.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

class UserFamilyHomeScreen extends StatefulWidget with WatchItStatefulWidgetMixin {
  static const String routeName = 'family.user.home';
  static const String routePath = '/family';

  const UserFamilyHomeScreen({super.key});

  @override
  State<UserFamilyHomeScreen> createState() => _UserFamilyHomeScreenState();
}

class _UserFamilyHomeScreenState extends State<UserFamilyHomeScreen> {
  // DATAS -------------------------------------------------------------------------------------------------------------------
  bool appIsOnline = false;
  Map? userData = UserMv.data;

  // INITIALIZER -------------------------------------------------------------------------------------------------------------
  @override
  void initState() {
    super.initState();
  }

  // VIEW --------------------------------------------------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    appIsOnline = watchValue<CNetworkState, bool>((CNetworkState x) => x.online);

    return DefaultLayout(
      child: Scaffold(
        appBar: AppBar(title: const Text('Ma famille')),

        // --- body :
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: CConstants.GOLDEN_SIZE),
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
                    onTap: () => CNetworkState.ifOnline(context, appIsOnline, () => openMyCouple()),
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

  // METHODES ----------------------------------------------------------------------------------------------------------------
  void openMyCouple() {
    if (userData?['child_can_be_maried'] == 'YES') {
      context.pushNamed(UserFamilyCoupleScreen.routeName);
    } else {
      _openCanBeMariedDialog();
    }
  }

  _openCanBeMariedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(CupertinoIcons.exclamationmark_bubble),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        content: StyledText(
          text: "<bold>Amen ${userData?['civility'] == 'F' ? "mon frère" : "ma sœur"} ${userData?['name']}.</bold> "
              '<br/>'
              '<br/>'
              "En deput de votre profil, vous n'avez pas le droit à cette partie "
              "de la communauté. Pour ce faire vous devez avoir le droit de crée un couple. "
              "Appuyez sur <bold>Envoyer</bold> pour envoyer votre demande à vos parent, enfin qu'ils "
              "puissent vous donnez l'approbation de crée un couple.",
          tags: CStyledTextTags().tags,
        ),
        actionsPadding: const EdgeInsets.all(CConstants.GOLDEN_SIZE),
        actions: [
          TextButton(
            onPressed: () {
              _back();
              verifyIfCanOpenMyCouple();
            },
            child: const Text("Verifier"),
          ),
          TextButton(onPressed: () => context.pop(), child: const Text("Fermer")),
          FilledButton(
            style: const ButtonStyle(visualDensity: VisualDensity.compact),
            onPressed: () {
              _back();
              sendCanBeMariedRequest();
            },
            child: const Text("Envoyer"),
          ),
        ],
      ).animate(effects: CTransitionsTheme.model_1),
    );
  }

  sendCanBeMariedRequest() {
    _showLoadingDialog();

    Map data = {'s': 'child', 'f': 'send_can_be_maried_request'};

    CApi.request.post('/family/request/handler', data: data).then((res) {
      _back();
      if (res.data['state'] == 'SENT') {
        _showSnakbar("Demande soumis avec succès aux parents.");
      } else {
        _showSnakbar("Vous avez une autre demande en cours.");
      }
    }).catchError((e) {
      _back();
      _showSnakbar("Impossible d'envoyer la demande, vérifie l'état de vôtre connexion internet.");
    });
  }

  void verifyIfCanOpenMyCouple() {
    _showLoadingDialog();

    LoginMv().downloadAndInstallUserDatas(
      onFinish: () {
        var data = UserMv.data;
        if (data?['child_can_be_maried'] == 'YES') {
          _back();
          context.pushNamed(UserFamilyCoupleScreen.routeName);
        } else {
          _back();
          _showSnakbar("Vous n'êtes pas encore éligible pour avoir un couple.");
        }
      },
    );
  }

  checkIfCanBeMaried() {
    Map data = {'s': 'child', 'f': 'has_can_be_maried_request'};

    CApi.request.post('/family/request/handler', data: data).then((res) {
      if (res.data['state'] == 'OK') {
        //e
      } else {
        //
      }
    }).catchError((e) {
      _showSnakbar("Impossible d'envoyer la demande, vérifie l'état de vôtre connexion internet.");
    });
  }

  void _back() => context.pop();

  void _showSnakbar(String s) => CSnackbarWidget(context, content: Text(s), defaultDuration: true);

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        contentPadding: const EdgeInsets.all(CConstants.GOLDEN_SIZE),
        content: LinearProgressIndicator(
          borderRadius: BorderRadius.circular(CConstants.DEFAULT_RADIUS),
        ),
      ).animate(effects: CTransitionsTheme.model_1),
    );
  }
}
