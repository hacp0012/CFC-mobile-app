import 'package:cfc_christ/configs/c_api.dart';
import 'package:cfc_christ/configs/c_constants.dart';
import 'package:cfc_christ/configs/c_network_state.dart';
import 'package:cfc_christ/configs/c_styled_text_tags.dart';
import 'package:cfc_christ/model_view/auth/login_mv.dart';
import 'package:cfc_christ/model_view/misc_data_handler_mv.dart';
import 'package:cfc_christ/model_view/pcn_data_handler_mv.dart';
import 'package:cfc_christ/model_view/user_mv.dart';
import 'package:cfc_christ/theme/c_transition_thme.dart';
import 'package:cfc_christ/views/layouts/default_layout.dart';
import 'package:cfc_christ/views/screens/app/contactus_screen.dart';
import 'package:cfc_christ/views/screens/user/user_edit_pcn_screen.dart';
import 'package:cfc_christ/views/widgets/c_snackbar_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:styled_text/styled_text.dart';
import 'package:watch_it/watch_it.dart';

class UserResponsabilityScreen extends StatefulWidget with WatchItStatefulWidgetMixin {
  static const String routeName = 'user.responsability';
  static const String routePath = 'responsability';

  const UserResponsabilityScreen({super.key});

  @override
  State<UserResponsabilityScreen> createState() => _UserResponsabilityScreenState();
}

class _UserResponsabilityScreenState extends State<UserResponsabilityScreen> {
  // DATAS -------------------------------------------------------------------------------------------------------------------
  /// what view to show.
  /// - If value is [1] show No PCN alert.
  /// - else if value is [2] show respobility editor.
  /// - else value is [3] show the in wait aprobation.
  int viewState = 1;
  bool appIsOnline = false;
  bool submissionLoading = false;
  Map<String, dynamic>? userData = UserMv.data;
  List roles = MiscDataHandlerMv.roles;
  Map<String, dynamic> setedData = {'role': null, 'level': null};
  Map<String, dynamic> userCurrentPcn = {'pool': '', 'com_loc': '', 'noyau_af': ''};
  Map<String, dynamic> userRoleDatail = {};

  // INITIALIZER -------------------------------------------------------------------------------------------------------------
  @override
  void initState() {
    _initView();

    userCurrentPcn['pool'] = PcnDataHandlerMv.getPool(userData?['pool'] ?? '');
    userCurrentPcn['com_loc'] = PcnDataHandlerMv.getPool(userData?['com_loc'] ?? '');
    userCurrentPcn['noyau_af'] = PcnDataHandlerMv.getPool(userData?['noyau_af'] ?? '');

    for (var role in roles) {
      if (userData?['role'] == role['role']) {
        userRoleDatail = role;
      }
    }

    setedData['role'] = userData?['role']?['role'];
    setedData['level'] = userData?['role']?['level'];

    super.initState();
  }

  void _s(fn) => super.setState(fn);

  // VIEW --------------------------------------------------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    appIsOnline = watchValue<CNetworkState, bool>((CNetworkState state) => state.online);

    return DefaultLayout(
      child: Scaffold(
        appBar: AppBar(title: const Text('Responsibility')),
        body: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: CConstants.MAX_CONTAINER_WIDTH),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: CConstants.GOLDEN_SIZE),
                child: Builder(builder: (context) {
                  if (viewState == 1) {
                    return Column(children: [
                      const Padding(
                        padding: EdgeInsets.only(top: CConstants.GOLDEN_SIZE * 4),
                        child: Icon(CupertinoIcons.exclamationmark_circle, size: CConstants.GOLDEN_SIZE * 7),
                      ),
                      Text("Alert", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                      StyledText(
                        text: "Votre responsabilité vous donne un rôle à jouer dans la communauté, un pool ou un noyau "
                            "d'affermissement. Mais il ce peut que vous n'êtes dans aucun pool ni communauté local pour avoir "
                            "un rôle à jouer. \n\n<italic>Veuillez d'abord demander votre place dans une communauté</italic>.",
                        tags: CStyledTextTags().tags,
                        textAlign: TextAlign.center,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: CConstants.GOLDEN_SIZE * 4),
                        child: FilledButton.tonal(
                          onPressed: () => CNetworkState.ifOnline(
                            context,
                            appIsOnline,
                            () => context.goNamed(UserEditPcnScreen.routeName),
                          ),
                          child: const Text("Demander ma place"),
                        ),
                      ),
                    ]);
                  } else if (viewState == 2) {
                    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Icon(CupertinoIcons.person_2_alt, size: CConstants.GOLDEN_SIZE * 5, color: Colors.grey),
                      Text("Responsabilité", style: Theme.of(context).textTheme.labelSmall),
                      Container(
                        padding: const EdgeInsets.all(1.0),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainer,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: StyledText(
                          text: "<bold>${userRoleDatail['name'] ?? 'Aucun'}</bold>",
                          tags: CStyledTextTags().tags,
                        ),
                      ),
                      const SizedBox(height: CConstants.GOLDEN_SIZE * 2),
                      StyledText(
                        text: "Pool de <bold>${userCurrentPcn['pool']?['name'] ?? 'Non specifié'}</bold>",
                        tags: CStyledTextTags().tags,
                      ),
                      StyledText(
                        text: "Com local <bold>${userCurrentPcn['com_loc']?['name'] ?? 'Non specifié'}</bold>",
                        tags: CStyledTextTags().tags,
                      ),
                      StyledText(
                        text: "NA <bold>${userCurrentPcn['noyau_af']?['name'] ?? 'Non specifié'}</bold>",
                        tags: CStyledTextTags().tags,
                      ),
                      const SizedBox(height: CConstants.GOLDEN_SIZE * 2),
                      DropdownButtonHideUnderline(
                        child: DropdownMenu<String>(
                          label: const Text("À quel niveau"),
                          width: CConstants.MAX_CONTAINER_WIDTH,
                          initialSelection: userData?['role']?['level'],
                          onSelected: (value) => setedData['level'] = value,
                          dropdownMenuEntries: const [
                            DropdownMenuEntry(value: 'POOL', label: "Pool"),
                            DropdownMenuEntry(value: 'COM', label: "Communauté locale"),
                            DropdownMenuEntry(value: 'NA', label: "Noyau d'affermissement"),
                          ],
                        ),
                      ),
                      const SizedBox(height: CConstants.GOLDEN_SIZE * 2),
                      DropdownButtonHideUnderline(
                        child: DropdownMenu(
                          label: const Text("Rôle"),
                          width: CConstants.MAX_CONTAINER_WIDTH,
                          initialSelection: userData?['role']?['role'],
                          onSelected: (value) => setedData['role'] = value,
                          dropdownMenuEntries: roles
                              .map(
                                (role) => DropdownMenuEntry(value: role['role'], label: role['name']),
                              )
                              .toList(),
                        ),
                      ),
                      const SizedBox(height: CConstants.GOLDEN_SIZE * 2),
                      const Text("A votre attention"),
                      StyledText(
                        text:
                            "<italic><small>Shalom à vous. Si vous soumettez vos changements, vous aurez à attendre quelques temps "
                            "ou quelques jours, durée pour laquelle l'administrateur aura vérifié votre demande et "
                            "vous autorisera à jouer ce rôle. <italic>Mais sachez que, si une autre personne joué déjà ce rôle, "
                            "votre demande pourra être rejeté.</italic></small>"
                            "\n\n"
                            "<bold>⚠️ Après la soumission de vôtre demande, vous serez suspendu dans le role que vous exercer pour "
                            "l'instants. Par défaut vous serez considéré comme un utilisateur standard.</bold></italic>",
                        tags: CStyledTextTags().tags,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: CConstants.GOLDEN_SIZE),
                        child: Visibility(
                          visible: !submissionLoading,
                          replacement: const CircularProgressIndicator(strokeCap: StrokeCap.round).animate(
                            effects: CTransitionsTheme.model_1,
                          ),
                          child: FilledButton.tonal(
                            onPressed: () => saveSubmition(),
                            child: const Text("Soumettre la demande"),
                          ).animate(effects: CTransitionsTheme.model_1),
                        ),
                      ),
                    ]);
                  } else if (viewState == 3) {
                    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      const Padding(
                        padding: EdgeInsets.all(CConstants.GOLDEN_SIZE * 3),
                        child: Icon(CupertinoIcons.clock, size: CConstants.GOLDEN_SIZE * 7),
                      ),
                      StyledText(
                        text: "<bold>En attente d'approbation</bold>",
                        tags: CStyledTextTags().tags,
                      ),
                      StyledText(
                        text: "Votre demande pour le rôle que vous aviez choisi est en attente "
                            "d'approbation de l'administrateur.",
                        tags: CStyledTextTags().tags,
                        textAlign: TextAlign.center,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: CConstants.GOLDEN_SIZE),
                        child: FilledButton.tonal(
                          onPressed: () => context.pushNamed(ContactusScreen.routeName),
                          child: const Text("Contacter un responsable"),
                        ),
                      ),
                    ]);
                  } else {
                    return const Center(child: Text("Fermer cette fenêtre"));
                  }
                }).animate(effects: CTransitionsTheme.model_1),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // METHODES ----------------------------------------------------------------------------------------------------------------
  void _initView() {
    bool state = userData?['pool'] == null || userData?['com_loc'] == null || userData?['noyau_af'] == null;

    if (state) {
      viewState = 1;
    } else if (state == false && userData?['role'] != null && userData?['role']['state'] == 'ACTIVE') {
      viewState = 2;
    } else if (userData?['role'] != null && userData?['role']['state'] == 'ACTIVE') {
      viewState = 3;
    } else {
      viewState = 1;
    }
  }

  void saveSubmition() {
    CApi.request.post('/user/update/role', data: setedData).then(
      (response) {
        if (response.data['state'] == 'UPDATED') {
          LoginMv().downloadAndInstallUserDatas(onFinish: () {
            _s(() {
              userData = UserMv.data;
              _initView();
            });
          }, onFailed: () {
            _showSnackbar(
              "Erreur, lors du mises à jour des données utilisateur. Veuillez vérifier "
              "l'état de votre connexion internet.",
            );
          });
        } else {
          _showSnackbar("Les donnés soumises ne sont pas correct.");
        }
      },
      onError: (error) {
        _showSnackbar("Une erreur est survenue, veuillez resoumettre votre requête.");
      },
    );
  }

  void _showSnackbar(String text, [Color? bg]) {
    CSnackbarWidget(context, content: Text(text), backgroundColor: bg ?? Theme.of(context).colorScheme.error);
  }
}
