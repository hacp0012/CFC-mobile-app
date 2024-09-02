import 'package:cfc_christ/configs/c_api.dart';
import 'package:cfc_christ/configs/c_constants.dart';
import 'package:cfc_christ/model_view/auth/login_mv.dart';
import 'package:cfc_christ/model_view/pcn_data_handler_mv.dart';
import 'package:cfc_christ/model_view/user_mv.dart';
import 'package:cfc_christ/theme/c_transition_thme.dart';
import 'package:cfc_christ/views/layouts/default_layout.dart';
import 'package:cfc_christ/views/screens/app/contactus_screen.dart';
import 'package:cfc_christ/views/widgets/c_snackbar_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

class UserEditPcnScreen extends StatefulWidget {
  static const String routeName = 'user.edit.pcn';
  static const String routePath = 'edit/pcn';

  const UserEditPcnScreen({super.key});

  @override
  State<UserEditPcnScreen> createState() => _UserEditPcnScreenState();
}

class _UserEditPcnScreenState extends State<UserEditPcnScreen> {
  // DATAS -------------------------------------------------------------------------------------------------------------------
  Map<String, dynamic>? userDate = UserMv.data;
  int viewState = 1;
  Map<String, String> pcnData = {'pool': '', 'cl': '', 'na': ''};

  Map saveButtonState = {'loading': false, 'disable': false};

  // INTIALIZER --------------------------------------------------------------------------------------------------------------
  void _s(fn) => super.setState(fn);

  @override
  void initState() {
    initView();

    _updateUserData();

    super.initState();
  }

  // VIEW --------------------------------------------------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: Scaffold(
        appBar: AppBar(title: const Text('PCN'), actions: [
          Builder(builder: (context) {
            if (saveButtonState['loading']) {
              return const Padding(
                padding: EdgeInsets.only(right: 9.0),
                child: CircularProgressIndicator(strokeCap: StrokeCap.round),
              );
            } else {
              return TextButton.icon(
                onPressed: viewState == 2 || saveButtonState['disable'] ? null : () => saveChanger(),
                label: const Text("Enregistrer"),
                icon: const Icon(CupertinoIcons.square_favorites_alt, size: CConstants.GOLDEN_SIZE * 2),
              );
            }
          }),
        ]),

        // --- BODY :
        body: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: CConstants.MAX_CONTAINER_WIDTH),
              child: Column(
                children: [
                  const SizedBox(height: CConstants.GOLDEN_SIZE),
                  Text(
                    "Pool, Communauté locale et Noyau d’affermissement",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: CConstants.GOLDEN_SIZE * 2),
                  Builder(builder: (context) {
                    // Creation.
                    if (viewState == 1) {
                      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        const SizedBox(height: CConstants.GOLDEN_SIZE),
                        Padding(
                          padding: const EdgeInsets.only(bottom: CConstants.GOLDEN_SIZE),
                          child: Text(
                            "Spécifier vous appartenance dans la famille chrétienne :",
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ),
                        DropdownButtonHideUnderline(
                          child: DropdownMenu(
                            label: const Text("Pool"),
                            width: CConstants.MAX_CONTAINER_WIDTH,
                            onSelected: (value) => _s(() {
                              pcnData['pool'] = value;
                              pcnData['cl'] = '';
                              pcnData['na'] = '';
                            }),
                            dropdownMenuEntries: PcnDataHandlerMv.pools
                                .map((pool) => DropdownMenuEntry(value: pool['id'], label: pool['nom']))
                                .toList(),
                          ),
                        ),
                        const SizedBox(height: CConstants.GOLDEN_SIZE * 2),
                        DropdownButtonHideUnderline(
                          child: DropdownMenu(
                            label: const Text("Communauté locale"),
                            width: CConstants.MAX_CONTAINER_WIDTH,
                            onSelected: (value) => _s(() {
                              pcnData['na'] = '';
                              pcnData['cl'] = value;
                            }),
                            dropdownMenuEntries: PcnDataHandlerMv.fitchCom(pcnData['pool'] ?? '')
                                .map(
                                  (com) => DropdownMenuEntry(value: com['id'], label: com['nom']),
                                )
                                .toList(),
                          ),
                        ),
                        const SizedBox(height: CConstants.GOLDEN_SIZE * 2),
                        DropdownButtonHideUnderline(
                          child: DropdownMenu(
                            label: const Text("Noyau d’affermissement"),
                            width: CConstants.MAX_CONTAINER_WIDTH,
                            onSelected: (value) => _s(() => pcnData['na'] = value),
                            dropdownMenuEntries: PcnDataHandlerMv.fitchNa(pcnData['cl'] ?? '')
                                .map((na) => DropdownMenuEntry(value: na['id'], label: na['nom']))
                                .toList(),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: CConstants.GOLDEN_SIZE * 2),
                          child: Text("Important !", style: Theme.of(context).textTheme.titleMedium),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: CConstants.GOLDEN_SIZE / 2),
                          child: Text(
                            "Amen ${userDate?['civility'] == 'F' ? 'frère' : 'sœur'} ${userDate?['name']}. Les informations "
                            "fournies devront être validé par le responsable du Pool ou l'administrateur, après "
                            "vérification auprès des membres de la famille chrétienne dont vous avez indiqué vôtre "
                            "appartenance.",
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ),
                      ]);
                    } else if (viewState == 2) {
                      return Column(children: [
                        const Icon(CupertinoIcons.clock, size: CConstants.GOLDEN_SIZE * 7),
                        const Text("En attente de validation par le responsable"),
                        Text(
                          "Les informations que vous aviez fourni, qui spécifiant votre appartenance dans une "
                          "communauté, sont en attente de validation par l'administrateur ou le chef du pool.",
                          style: Theme.of(context).textTheme.labelSmall,
                          textAlign: TextAlign.center,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: CConstants.GOLDEN_SIZE),
                          child: FilledButton.tonalIcon(
                            icon: const Icon(CupertinoIcons.question_circle),
                            onPressed: () => context.pushNamed(ContactusScreen.routeName),
                            label: const Text("Contactez un responsable"),
                          ),
                        ),
                      ]);
                    } else if (viewState == 3) {
                      return Column(children: [
                        const SizedBox(height: CConstants.GOLDEN_SIZE),
                        Padding(
                          padding: const EdgeInsets.only(bottom: CConstants.GOLDEN_SIZE),
                          child: Text(
                            "Vous appartienne dans la famille chrétienne suivante:",
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ),
                        DropdownButtonHideUnderline(
                          child: DropdownMenu(
                            label: const Text("Pool"),
                            width: CConstants.MAX_CONTAINER_WIDTH,
                            initialSelection: pcnData['pool'],
                            onSelected: (value) => _s(() {
                              pcnData['pool'] = value;
                              pcnData['cl'] = '';
                              pcnData['na'] = '';
                            }),
                            dropdownMenuEntries: PcnDataHandlerMv.pools
                                .map((pool) => DropdownMenuEntry(value: pool['id'], label: pool['nom']))
                                .toList(),
                          ),
                        ),
                        const SizedBox(height: CConstants.GOLDEN_SIZE * 2),
                        DropdownButtonHideUnderline(
                          child: DropdownMenu(
                            label: const Text("Communauté locale"),
                            width: CConstants.MAX_CONTAINER_WIDTH,
                            initialSelection: pcnData['cl'],
                            onSelected: (value) => _s(() {
                              pcnData['na'] = '';
                              pcnData['cl'] = value;
                            }),
                            dropdownMenuEntries: PcnDataHandlerMv.fitchCom(pcnData['pool'] ?? '')
                                .map(
                                  (com) => DropdownMenuEntry(value: com['id'], label: com['nom']),
                                )
                                .toList(),
                          ),
                        ),
                        const SizedBox(height: CConstants.GOLDEN_SIZE * 2),
                        DropdownButtonHideUnderline(
                          child: DropdownMenu(
                            label: const Text("Noyau d’affermissement"),
                            width: CConstants.MAX_CONTAINER_WIDTH,
                            initialSelection: pcnData['na'],
                            onSelected: (value) => _s(() => pcnData['na'] = value),
                            dropdownMenuEntries: PcnDataHandlerMv.fitchNa(pcnData['cl'] ?? '')
                                .map((na) => DropdownMenuEntry(value: na['id'], label: na['nom']))
                                .toList(),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: CConstants.GOLDEN_SIZE * 4),
                          child: Text(
                            "Shalom ${userDate?['civility'] == 'F' ? 'frère' : 'sœur'} ${userDate?['name']}. "
                            "Si vous apportez des modifications aux infirmations ci-dessus, ils devront être validé par "
                            "le responsable du Pool ou l'administrateur, après vérification auprès des membres de la "
                            "famille chrétienne dont vous avez indiqué vôtre appartenance.",
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ),
                      ]);
                    }

                    return Center(child: Text("Fermer la page.", style: Theme.of(context).textTheme.titleLarge));
                  }).animate(effects: CTransitionsTheme.model_1),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // METHODES ----------------------------------------------------------------------------------------------------------------
  void initView() {
    bool state = userDate?['pool'] == null && userDate?['com_loc'] == null && userDate?['noyau_af'] == null;

    if (state && userDate?['pcn_in_waiting_validation'] == null) {
      // Create.
      viewState = 1;
    } else if (state == false && userDate?['pcn_in_waiting_validation'] != null) {
      viewState = 3;
    } else if (state && userDate?['pcn_in_waiting_validation'] != null) {
      // In wait.
      viewState = 2;
    } else if ((state == false && userDate?['pcn_in_waiting_validation'] != null) || (state == false)) {
      // Edit.
      viewState = 3;
      userDate?['pool'] = userDate?['pool'] ?? '';
      userDate?['cl'] = userDate?['com_loc'] ?? '';
      userDate?['na'] = userDate?['noyau_af'] ?? '';
    }
  }

  bool fieldsValidation() {
    if (pcnData['pool']!.isEmpty || pcnData['cl']!.isEmpty || pcnData['na']!.isEmpty) {
      CSnackbarWidget(
        context,
        content: const Text("Veuillez remplir toutes les champs !"),
        backgroundColor: Theme.of(context).colorScheme.error,
        defaultDuration: true,
      );
      return false;
    }
    return true;
  }

  void saveChanger() {
    if (fieldsValidation()) {
      if (viewState == 1) {
        _saveNewSubscription();
      } else if (viewState == 3) {
        _updateSubscription();
      }
    }
  }

  void _saveNewSubscription() {
    _s(() => saveButtonState['loading'] = true);

    Map data = {
      'pool': pcnData['pool'],
      'com_loc': pcnData['cl'],
      'noyau_af': pcnData['na'],
    };

    CApi.request.post('/user/update/pcn', data: data).then(
      (response) {
        _s(() => saveButtonState['loading'] = false);

        if (response.data['state'] == 'UPDATED') {
          LoginMv().downloadAndInstallUserDatas(
            onFinish: () {
              _showSnackbar("Mises à jour", backgroundColor: Colors.green);
              _s(() {
                userDate = UserMv.data;
                initView();
              });
            },
            onFailed: () => _showSnackbar("Impossible de mettre à jour les donnés utilisateur. Veuillez recommencer."),
          );
        } else {
          _showSnackbar("Problème de mises à jour. Veuillez recommencer.");
        }
      },
      onError: (error) {
        _s(() => saveButtonState['loading'] = false);
        _showSnackbar("Une erreur est survenue, veillez vérifié votre connexion internet.");
      },
    );
  }

  void _updateSubscription() => _saveNewSubscription();

  void _updateUserData() {
    LoginMv().downloadAndInstallUserDatas(
      onFinish: () {
        userDate = UserMv.data;
        initView();
      },
      onFailed: () {},
    );
  }

  void _showSnackbar(String text, {Color? backgroundColor}) => CSnackbarWidget(
        context,
        content: Text(text),
        backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.error,
        defaultDuration: true,
      );
}
