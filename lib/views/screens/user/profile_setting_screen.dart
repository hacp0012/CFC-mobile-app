import 'dart:async';

import 'package:cfc_christ/classes/c_form_validator.dart';
import 'package:cfc_christ/configs/c_api.dart';
import 'package:cfc_christ/configs/c_constants.dart';
import 'package:cfc_christ/configs/c_network_state.dart';
import 'package:cfc_christ/model_view/auth/login_mv.dart';
import 'package:cfc_christ/model_view/misc_data_handler_mv.dart';
import 'package:cfc_christ/model_view/user_mv.dart';
import 'package:cfc_christ/theme/c_transition_thme.dart';
import 'package:cfc_christ/views/layouts/default_layout.dart';
import 'package:cfc_christ/views/screens/home/home_screen.dart';
import 'package:cfc_christ/views/screens/user/partials/user_new_phone_validation_otp_screen.dart';
import 'package:cfc_christ/views/screens/user/user_delete_account_screen.dart';
import 'package:cfc_christ/views/widgets/c_modal_widget.dart';
import 'package:cfc_christ/views/widgets/c_snackbar_widget.dart';
import 'package:easy_mask/easy_mask.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:watch_it/watch_it.dart';

class ProfileSettingScreen extends StatefulWidget with WatchItStatefulWidgetMixin {
  // DATAS -------------------------------------------------------------------------------------------------------------------
  static const String routeName = 'user.setting';
  static const String routePath = 'setting';

  const ProfileSettingScreen({super.key});

  @override
  State<ProfileSettingScreen> createState() => _ProfileSettingScreenState();
}

class _ProfileSettingScreenState extends State<ProfileSettingScreen> {
  // DATAS -------------------------------------------------------------------------------------------------------------------
  bool appIsOnline = false;

  Map<String, dynamic>? userData = UserMv.data;

  final _userFormKey = GlobalKey<FormState>();
  final _phoneFormKey = GlobalKey<FormState>();

  Timer? _userAutoSaverTimer;

  String? oldPhoneNumber;

  TextEditingController nameInputController = TextEditingController();
  TextEditingController fullnameInputController = TextEditingController();
  TextEditingController brithDateInputController = TextEditingController();
  TextEditingController phoneNumberInputController = TextEditingController();

  // INITIALIZER -------------------------------------------------------------------------------------------------------------
  void _s(fn) => super.setState(fn);

  @override
  void initState() {
    DateTime bData = DateTime.parse(userData?['d_naissance']);

    nameInputController.text = userData?['name'] ?? '';
    fullnameInputController.text = userData?['fullname'] ?? '';
    brithDateInputController.text = "${bData.day}/${bData.month}/${bData.year}";
    phoneNumberInputController.text = userData?['telephone'][1] ?? '';

    oldPhoneNumber = userData?['telephone'][1] ?? '';

    super.initState();
  }

  // VIEW --------------------------------------------------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    appIsOnline = watchValue<CNetworkState, bool>((CNetworkState x) => x.online);

    return DefaultLayout(
      child: Scaffold(
        appBar: AppBar(title: const Text('Mon compte')),

        //
        body: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: CConstants.MAX_CONTAINER_WIDTH),
              child: Column(children: [
                // --- USER :
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(CConstants.GOLDEN_SIZE),
                    child: Form(
                      key: _userFormKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text("Utilisateur", style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: CConstants.GOLDEN_SIZE),
                        TextFormField(
                          validator: CFormValidator([CFormValidator.required()]).validate,
                          controller: nameInputController,
                          decoration: const InputDecoration(hintText: "Nom", labelText: "Nom"),
                          onChanged: (value) => _userAutoSaver(),
                        ),
                        const SizedBox(height: CConstants.GOLDEN_SIZE),
                        TextFormField(
                          validator: CFormValidator([CFormValidator.required()]).validate,
                          controller: fullnameInputController,
                          decoration: const InputDecoration(hintText: "Nom complet", labelText: "Nom complet"),
                          onChanged: (value) => _userAutoSaver(),
                        ),
                        const SizedBox(height: CConstants.GOLDEN_SIZE),
                        Row(children: [
                          Expanded(
                            child: TextFormField(
                              decoration: const InputDecoration(hintText: "Date de naissance"),
                              validator: CFormValidator([CFormValidator.required()]).validate,
                              controller: brithDateInputController,
                              onChanged: (value) => _userAutoSaver(),
                              keyboardType: TextInputType.datetime,
                              inputFormatters: [TextInputMask(mask: '99/99/9999', placeholder: '-', maxPlaceHolders: 8)],
                            ),
                          ),
                          const SizedBox(width: CConstants.GOLDEN_SIZE),
                          DropdownButtonHideUnderline(
                            child: DropdownMenu<String>(
                              initialSelection: userData?['civility'] == 'F' ? 'F' : 'S',
                              onSelected: (value) {
                                userData?['civility'] = value;
                                _userAutoSaver();
                              },
                              label: const Text('Civilité'),
                              dropdownMenuEntries: const [
                                DropdownMenuEntry(value: 'F', label: "Frère"),
                                DropdownMenuEntry(value: 'S', label: "Sœur"),
                              ],
                            ),
                          ),
                        ]),
                      ]),
                    ),
                  ),
                ),

                // --- LOGIN :
                const SizedBox(height: CConstants.GOLDEN_SIZE * 2),
                Card(
                  surfaceTintColor: Theme.of(context).colorScheme.primary,
                  child: Padding(
                    padding: const EdgeInsets.all(CConstants.GOLDEN_SIZE),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text("Idenitifiant", style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: CConstants.GOLDEN_SIZE),
                      Form(
                        key: _phoneFormKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Row(children: [
                          DropdownButtonHideUnderline(
                            child: DropdownMenu(
                              initialSelection: userData?['telephone'][0] ?? '243',
                              label: const Text('Code pays'),
                              onSelected: (value) => userData?['telephone'][0] = value,
                              dropdownMenuEntries: MiscDataHandlerMv.countriesCodes.map((element) {
                                return DropdownMenuEntry(
                                  value: element?['code'] ?? '243',
                                  label: "${element?["country"]} ${element?['code'] ?? 'non trouver'}",
                                );
                              }).toList(),
                            ),
                          ),
                          const SizedBox(width: CConstants.GOLDEN_SIZE),
                          Expanded(
                            child: TextFormField(
                              controller: phoneNumberInputController,
                              validator: CFormValidator([CFormValidator.required()]).validate,
                              decoration: const InputDecoration(hintText: "000-000-000", labelText: 'Téléphone'),
                              inputFormatters: [TextInputMask(mask: '999-999-999', placeholder: '_', maxPlaceHolders: 9)],
                              onChanged: (value) => _s(() {}),
                            ),
                          ),
                        ]),
                      ),
                      const SizedBox(height: CConstants.GOLDEN_SIZE),
                      Text(
                        "Ici vous pouvez changer votre numéro de téléphone. \nMais vous devez avoir sur "
                        "la conscience que cette numéro de téléphone est celui qui vous sert d'identifiant unique "
                        "de connexion à cette application. Donc conserver le. Et malgré cela on va passer à la "
                        "vérification OTP (SMS) pour nous assurer que cet nouveau numéro de téléphone est le vôtre.",
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      const SizedBox(height: CConstants.GOLDEN_SIZE),
                      Visibility(
                        visible: oldPhoneNumber != phoneNumberInputController.text,
                        child: Row(children: [
                          const Spacer(),
                          ElevatedButton(
                            onPressed: openPhoneValidationOtpScreen,
                            child: const Text("Valider par OTP"),
                          ).animate(effects: CTransitionsTheme.model_1),
                        ]),
                      ),
                    ]),
                  ),
                ),

                // --- ADVENCED :
                const SizedBox(height: CConstants.GOLDEN_SIZE * 2),
                Card(
                  surfaceTintColor: Colors.red,
                  child: Padding(
                    padding: const EdgeInsets.all(CConstants.GOLDEN_SIZE),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Text("DANGER"),
                      Text("Actions à effectuer avec précautions.", style: Theme.of(context).textTheme.labelSmall),
                      const SizedBox(height: CConstants.GOLDEN_SIZE),
                      ListTile(
                        title: const Text("Déconnectez"),
                        subtitle: const Text("Déconnectez votre session de cette application."),
                        leading: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.logout),
                        ),
                        onTap: () => CModalWidget(
                          context: context,
                          child: Padding(
                            padding: const EdgeInsets.all(CConstants.GOLDEN_SIZE),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Attention", style: Theme.of(context).textTheme.titleMedium),
                                const Text("Déconnecter votre compte de cette appareil ?"),
                                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                  TextButton(
                                    onPressed: () {
                                      CModalWidget.close(context);
                                    },
                                    child: const Text("Annuler"),
                                  ),
                                  TextButton(
                                    style: ButtonStyle(
                                      foregroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.error),
                                    ),
                                    onPressed: () {
                                      context.pop();
                                      CNetworkState.ifOnline(context, appIsOnline, () => logout());
                                    },
                                    child: const Text("OUI, déconnecter"),
                                  ),
                                ]),
                              ],
                            ),
                          ),
                        ).show(),
                      ),
                      const SizedBox(height: CConstants.GOLDEN_SIZE),
                      ListTile(
                        title: const Text("Supprimer mon compte"),
                        // subtitle: const Text("Déconnectez votre session."),
                        leading: IconButton.filledTonal(
                          style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.red.shade100)),
                          onPressed: () {},
                          icon: const Icon(CupertinoIcons.trash, color: Colors.red),
                        ),
                        onTap: () => context.pushNamed(UserDeleteAccountScreen.routeName),
                      ),
                    ]),
                  ),
                )
              ]),
            ),
          ),
        ),
      ),
    );
  }

  // FUNCTIONS ---------------------------------------------------------------------------------------------------------------
  void logout() {
    CModalWidget(
      context: context,
      child: Padding(
        padding: const EdgeInsets.all(CConstants.GOLDEN_SIZE),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Déconnexion", style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: CConstants.GOLDEN_SIZE),
            LinearProgressIndicator(borderRadius: BorderRadius.circular(CConstants.GOLDEN_SIZE / 2)),
          ],
        ),
      ),
    ).show(unRoute: true, persistant: false);

    // Logout :
    LoginMv().logout(
      onSuccess: () => context.goNamed(HomeScreen.routeName),
      onFailed: () {
        CModalWidget.close(context);
        CSnackbarWidget(
          context,
          backgroundColor: Theme.of(context).colorScheme.error,
          content: const Text(
            "Un problème est survenue, veuillez réessayer. Il peut être du à la connexion internet. "
            "Mais vous êtes quand même déconnectés; une partie de votre session est rester enregistré sur nos serveurs. ",
          ),
        );
        context.pushNamed(HomeScreen.routeName);
      },
    );
  }

  void _userAutoSaver() {
    const int seconds = 2;

    if (_userAutoSaverTimer != null) {
      _userAutoSaverTimer?.cancel();
      _userAutoSaverTimer = Timer(const Duration(seconds: seconds), () => userSaveData());
    } else {
      _userAutoSaverTimer = Timer(const Duration(seconds: seconds), () => userSaveData());
    }
  }

  void userSaveData() {
    if (_userFormKey.currentState!.validate()) {
      if (brithDateInputController.text.replaceAll(RegExp(r"[\-/]"), '').length == 8) {
        Map data = {
          'name': nameInputController.text,
          'fullname': fullnameInputController.text,
          'brith_date': brithDateInputController.text,
          'civility': userData?['civility'] ?? 'F',
        };

        CApi.request.post("/user/update/infos", data: data).then(
          (response) {
            if (response.data['state'] == 'SUCCESS') {
              _showSnackbar("Informations enregistrés avec succès", Colors.green.shade200);
            }

            // Download user data.
            LoginMv().downloadAndInstallUserDatas();
          },
          onError: (error) {
            _showSnackbar(
              "Impossible d'enregistrer les modifications que vous venez d'apporte. "
              "Vérifier votre connexion internet.",
            );
          },
        );
      } else {
        CSnackbarWidget(context, content: const Text("Date de naissance incomplet"), defaultDuration: true);
      }
    }
  }

  void openPhoneValidationOtpScreen() {
    if (_phoneFormKey.currentState!.validate()) {
      if (phoneNumberInputController.text.replaceAll(RegExp(r"[\-_]"), '').length < 9) {
        CSnackbarWidget(
          context,
          content: const Text("Numéro de téléphone incomplet"),
          backgroundColor: Theme.of(context).colorScheme.error,
          defaultDuration: false,
        );
      } else if (oldPhoneNumber == phoneNumberInputController.text) {
        _showSnackbar("Aucun modification n'a été apporté sur le numéro de téléphone.");
      } else {
        // Open OTP screen.
        context.pushNamed(UserNewPhoneValidationOtpScreen.routeName, extra: {
          'phone_code': userData?['telephone'][0],
          'phone_number': phoneNumberInputController.text,
          'old_phone_number': oldPhoneNumber,
        });
      }
    }
  }

  void _showSnackbar(String message, [Color? color]) {
    CSnackbarWidget(
      context,
      content: Text(message),
      backgroundColor: color ?? Theme.of(context).colorScheme.error,
      defaultDuration: true,
    );
  }
}
