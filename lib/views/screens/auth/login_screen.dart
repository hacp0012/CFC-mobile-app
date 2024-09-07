import 'package:cfc_christ/classes/c_form_validator.dart';
import 'package:cfc_christ/classes/c_misc_class.dart';
import 'package:cfc_christ/model_view/auth/login_mv.dart';
import 'package:cfc_christ/model_view/misc_data_handler_mv.dart';
import 'package:cfc_christ/theme/c_transition_thme.dart';
import 'package:cfc_christ/views/layouts/default_layout.dart';
import 'package:cfc_christ/configs/c_constants.dart';
import 'package:cfc_christ/views/screens/auth/otp_screen.dart';
import 'package:cfc_christ/views/screens/auth/register_otp_screen.dart';
import 'package:cfc_christ/views/screens/auth/register_screen.dart';
import 'package:cfc_christ/views/widgets/c_modal_widget.dart';
import 'package:cfc_christ/views/widgets/c_snackbar_widget.dart';
import 'package:easy_mask/easy_mask.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static String routeName = 'login.screen';

  @override
  createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, String> loginFieldsData = {
    'phone_code': '243',
    'phone_number': '',
  };

  @override
  Widget build(BuildContext context) {
    // var q = MediaQuery.sizeOf(context);

    return DefaultLayout(
      transparentStatusBar: true,
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: CMiscClass.whenBrightnessOf<Color>(context, dark: CConstants.LIGHT_COLOR),
                radius: CConstants.GOLDEN_SIZE * 9,
                child: Image.asset('lib/assets/icons/LOGO_CFC_512.png'),
              ).animate().fadeIn(duration: 500.ms),

              // Text.
              Text('Connexion', style: Theme.of(context).textTheme.headlineMedium).animate().fadeIn(duration: 500.ms),

              // Form.
              const SizedBox(height: CConstants.GOLDEN_SIZE),
              Padding(
                padding: const EdgeInsets.all(CConstants.GOLDEN_SIZE * 2),
                child: Column(
                  children: [
                    Text(
                      "Entrez votre numéro de téléphone que vous aviez renseigné au départ, "
                      "si vous êtes déjà utilisateur de cette application. Si vous êtes nouveau, cliquez "
                      "sur le lien indiqué en bas pour vous inscrire",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.labelMedium,
                    ),

                    // Fields.
                    const SizedBox(height: CConstants.GOLDEN_SIZE * 3),
                    Form(
                      key: _formKey,
                      child: Row(
                        children: [
                          Expanded(
                            child: DropdownButtonHideUnderline(
                              child: DropdownMenu(
                                onSelected: (value) => loginFieldsData['phone_code'] = value ?? '',
                                dropdownMenuEntries: MiscDataHandlerMv.countriesCodes.map((element) {
                                  return DropdownMenuEntry(
                                    value: "${element['code']}",
                                    label: "${element['country']} ${element['code']}",
                                  );
                                }).toList(),
                                initialSelection: loginFieldsData['phone_code'],
                              ),
                            ),
                          ),
                          const SizedBox(width: CConstants.GOLDEN_SIZE),
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              validator: CFormValidator([CFormValidator.required()]).validate,
                              decoration: const InputDecoration(hintText: "Numéro de téléphone"),
                              keyboardType: TextInputType.phone,
                              onChanged: (value) => loginFieldsData['phone_number'] = value,
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (value) => startProcess(),
                              inputFormatters: [
                                TextInputMask(mask: '999-999-999', placeholder: '_', maxPlaceHolders: 9),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Redirect to register.
                    Row(children: [
                      const Spacer(),
                      TextButton(
                        onPressed: () => context.pushNamed(RegisterScreen.routeName),
                        child: const Text("Nouveau? Cliquez ici pour vous inscrire"),
                      )
                    ]),

                    // Actions.
                    const SizedBox(height: CConstants.GOLDEN_SIZE * 3),
                    Row(children: [
                      // TextButton(onPressed: () {}, child: const Text("Recommencer")),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () => startProcess(),
                        child: const Text("Poursuivre"),
                      ),
                    ])
                  ],
                ),
              ),
            ],
          ),
          /*Stack(
            fit: StackFit.expand,
            children: [
              Stack(fit: StackFit.expand, children: [
                Positioned(width: q.width, child: Image.asset('lib/assets/pictures/final/picture_3.png', fit: BoxFit.cover)),
                Positioned(
                  height: q.height,
                  width: q.width,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: Container(color: Colors.black.withOpacity(0)),
                  ),
                ),
                Positioned(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: CMiscClass.whenBrightnessOf<Color>(context, dark: CConstants.LIGHT_COLOR),
                        radius: CConstants.GOLDEN_SIZE * 9,
                        child: Image.asset('lib/assets/icons/LOGO_CFC_512.png'),
                      ).animate().fadeIn(duration: 500.ms),

                      // Text.
                      Text('Connexion', style: Theme.of(context).textTheme.headlineMedium).animate().fadeIn(duration: 500.ms),

                      // Form.
                      const SizedBox(height: CConstants.GOLDEN_SIZE),
                      Padding(
                        padding: const EdgeInsets.all(CConstants.GOLDEN_SIZE * 2),
                        child: Column(
                          children: [
                            Text(
                              "Entrez votre numéro de téléphone que vous aviez renseigné au départ, "
                              "si vous êtes déjà utilisateur de cette application. Si vous êtes nouveau, cliquez "
                              "sur le lien indiqué en bas pour vous inscrire",
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.labelMedium,
                            ),

                            // Fields.
                            const SizedBox(height: CConstants.GOLDEN_SIZE * 3),
                            Form(
                              key: _formKey,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownMenu(
                                        onSelected: (value) => loginFieldsData['phone_code'] = value ?? '',
                                        dropdownMenuEntries: MiscDataHandlerMv.countriesCodes.map((element) {
                                          return DropdownMenuEntry(
                                            value: "${element['code']}",
                                            label: "${element['country']} ${element['code']}",
                                          );
                                        }).toList(),
                                        initialSelection: loginFieldsData['phone_code'],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: CConstants.GOLDEN_SIZE),
                                  Expanded(
                                    flex: 2,
                                    child: TextFormField(
                                      validator: CFormValidator([CFormValidator.required()]).validate,
                                      decoration: const InputDecoration(hintText: "Numéro de téléphone"),
                                      keyboardType: TextInputType.phone,
                                      onChanged: (value) => loginFieldsData['phone_number'] = value,
                                      textInputAction: TextInputAction.done,
                                      onFieldSubmitted: (value) => startProcess(),
                                      inputFormatters: [
                                        TextInputMask(mask: '999-999-999', placeholder: '_', maxPlaceHolders: 9),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Redirect to register.
                            Row(children: [
                              const Spacer(),
                              TextButton(
                                onPressed: () => context.pushNamed(RegisterScreen.routeName),
                                child: const Text("Nouveau? Cliquez ici pour vous inscrire"),
                              )
                            ]),

                            // Actions.
                            const SizedBox(height: CConstants.GOLDEN_SIZE * 3),
                            Row(children: [
                              // TextButton(onPressed: () {}, child: const Text("Recommencer")),
                              const Spacer(),
                              ElevatedButton(
                                onPressed: () => startProcess(),
                                child: const Text("Poursuivre"),
                              ),
                            ])
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
            ],
          ),*/
        ),
      ),
    );
  }

  // ACTIONS : -------------------------------------------------- >
  bool _inputFieldsControl() {
    _formKey.currentState!.validate();
    // Control PHONE ID :
    if ((loginFieldsData['phone_code'] as String).isEmpty ||
        CFormValidator.min(9).call((loginFieldsData['phone_number'] as String).replaceAll(RegExp('[-_]'), '')) != null) {
      CSnackbarWidget(
        context,
        content: const Text("Le numéro de téléphone est incomplet"),
        backgroundColor: Theme.of(context).colorScheme.error,
        defaultDuration: true,
      );
      return false;
    }
    return true;
  }

  void startProcess() {
    if ((_inputFieldsControl())) {
      CModalWidget(
        context: context,
        child: LoginScreenInnerDialog(
          phoneCode: loginFieldsData['phone_code'] ?? '',
          phoneNumber: loginFieldsData['phone_number'] ?? '',
        ),
      ).show(persistant: true);
    }
  }
}

// ---------------------------------------------------------------------------------------------------------------------------
class LoginScreenInnerDialog extends StatefulWidget {
  const LoginScreenInnerDialog({super.key, required this.phoneCode, required this.phoneNumber});

  final String phoneCode;
  final String phoneNumber;

  @override
  State<LoginScreenInnerDialog> createState() => _LoginScreenInnerDialogState();
}

class _LoginScreenInnerDialogState extends State<LoginScreenInnerDialog> {
  String? loginState;

  @override
  void initState() {
    super.initState();

    _controleUserAccountState();
  }

  void _s(fn) => super.setState(fn);

  // FUNCNTIONS ------------------- >
  void _controleUserAccountState() async {
    LoginMv loger = LoginMv();

    await loger.verifyIfRegistred(
      phoneCode: widget.phoneCode,
      phoneNumber: widget.phoneNumber,

      // Callbacks :--------------------------------- >
      onAvalable: () {
        _s(() => loginState = 'VALIDATED');
        _login();
      },
      onUnregistred: () => _s(() => loginState = 'UNREGISTED'),
      onInvalide: () => _s(() => loginState = 'INVALIDE'),
    );
  }

  void _login() {
    LoginMv().login(widget.phoneCode, widget.phoneNumber, onFinish: () {
      _openOtpScreen();
    });
  }

  void _openOtpScreen() {
    context.pushNamed(
      OtpScreen.routeName,
      extra: {'phone_code': widget.phoneCode, 'phone_number': widget.phoneNumber, 'SEND_OTP': true},
    );
  }

  void _openRegisterScren() {
    context.pushNamed(
      RegisterScreen.routeName,
      extra: {'phone_code': widget.phoneCode, 'phone_number': widget.phoneNumber},
    );
  }

  /// Open register opt and request OTP automaticaly.
  void _openRegisterOtp() {
    context.pushNamed(
      RegisterOtpScreen.routeName,
      extra: {'SEND_OTP': true, 'phone_code': widget.phoneCode, 'phone_number': widget.phoneNumber},
    );
  }

  // VIEW ------------------------ >
  Widget changeView(String name) {
    switch (name) {
      case 'UNREGISTED':
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              CupertinoIcons.exclamationmark_circle,
              size: CConstants.GOLDEN_SIZE * 3,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: CConstants.GOLDEN_SIZE),
            Text(
              "Votre numéro de téléphone (${widget.phoneCode}) ${widget.phoneNumber} n’existe pas dans notre "
              "base de données. \n\nCeci signifie que vous pourriez "
              "avoir fourni un numéro de téléphone différent lors de "
              "votre inscription ou vous êtes un nouvel utilisateur.",
            ),
            const SizedBox(height: CConstants.GOLDEN_SIZE),
            Row(children: [
              const Spacer(),
              TextButton(onPressed: () => CModalWidget.close(context), child: const Text('Non')),
              const SizedBox(width: CConstants.GOLDEN_SIZE),
              FilledButton.tonal(
                style: const ButtonStyle(visualDensity: VisualDensity.compact),
                onPressed: _openRegisterScren,
                child: const Text("S'enregistrer"),
              ),
            ]),
          ],
        ).animate(effects: CTransitionsTheme.model_1);
      case 'INVALIDE':
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              CupertinoIcons.exclamationmark_circle,
              size: CConstants.GOLDEN_SIZE * 3,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: CConstants.GOLDEN_SIZE),
            Text(
              "Un compte enregistré sur votre numéro (${widget.phoneCode}) ${widget.phoneNumber} est "
              "en attente de validation OTP. \n\n"
              "Ce code vous a était envoyé au numéro ci-dessus, veuillez le saisir pour valider votre compte.",
            ),
            const SizedBox(height: CConstants.GOLDEN_SIZE),
            Row(children: [
              const Spacer(),
              TextButton(onPressed: () => CModalWidget.close(context), child: const Text('Non')),
              const SizedBox(width: CConstants.GOLDEN_SIZE),
              FilledButton.tonal(
                style: const ButtonStyle(visualDensity: VisualDensity.compact),
                onPressed: _openRegisterOtp,
                child: const Text("Valider le Code OTP"),
              ),
            ]),
          ],
        ).animate(effects: CTransitionsTheme.model_1);
      default:
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Authentification", style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: CConstants.GOLDEN_SIZE),
            LinearProgressIndicator(borderRadius: BorderRadius.circular(CConstants.GOLDEN_SIZE / 2)),
          ],
        ).animate(effects: CTransitionsTheme.model_1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.all(CConstants.GOLDEN_SIZE), child: changeView(loginState ?? ''));
  }
}
