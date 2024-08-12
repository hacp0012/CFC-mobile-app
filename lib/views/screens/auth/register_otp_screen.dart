import 'package:cfc_christ/classes/c_otp_handler_class.dart';
import 'package:cfc_christ/configs/c_constants.dart';
import 'package:cfc_christ/model_view/auth/login_mv.dart';
import 'package:cfc_christ/model_view/auth/register_mv.dart';
import 'package:cfc_christ/views/components/c_otp_component.dart';
import 'package:cfc_christ/views/layouts/empty_layout.dart';
import 'package:cfc_christ/views/screens/home/home_screen.dart';
import 'package:cfc_christ/views/widgets/c_modal_widget.dart';
import 'package:cfc_christ/views/widgets/c_snackbar_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RegisterOtpScreen extends StatefulWidget {
  static String routeName = "register.otp";
  static String routePath = "otp";

  const RegisterOtpScreen({super.key, this.grState});

  final GoRouterState? grState;

  @override
  State<RegisterOtpScreen> createState() => _RegisterOtpScreenState();
}

class _RegisterOtpScreenState extends State<RegisterOtpScreen> {
  TapGestureRecognizer resendOtp = TapGestureRecognizer();
  String phoneNumber = "";
  String phoneCode = "";
  String _otp = "";

  @override
  void initState() {
    resendOtp.onTap = () => _sendOtp();

    Map extra = (widget.grState?.extra ?? {}) as Map;
    phoneCode = extra['phone_code'] ?? '';
    phoneNumber = extra['phone_number'] ?? '';
    _otp = extra['_otp'] ?? '';

    if (extra['SEND_OTP'] == true) {
      _sendOtp();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: Scaffold(
        appBar: AppBar(title: const Text("Vérification OTP")),

        // Body.
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: CConstants.MAX_CONTAINER_WIDTH),
            child: Padding(
              padding: const EdgeInsets.all(CConstants.GOLDEN_SIZE),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: CConstants.GOLDEN_SIZE * 2),
                        Text("Code de verification.", style: Theme.of(context).textTheme.headlineSmall),

                        // Message text.
                        const SizedBox(height: CConstants.GOLDEN_SIZE * 2),
                        SizedBox(
                          width: CConstants.GOLDEN_SIZE * 36,
                          child: Text(
                            "Nous avons envoyé un code de vérification sur votre "
                            "numéro de téléphone ($phoneCode) $phoneNumber, saisissez-le sur le champs "
                            "ci-dessous pour confirmer et poursuivre, ou "
                            "cliquez sur le bouton ci-dessous pour modifier le "
                            "numéro de téléphone [$_otp]",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ),

                        // OTP Row.
                        const SizedBox(height: CConstants.GOLDEN_SIZE * 2),
                        COtpComponent(
                          phoneCode: phoneCode,
                          phoneNumber: phoneNumber,
                          onSuccess: (data) => startAccountValidation(data),
                          onFailed: () {
                            CSnackbarWidget(
                              context,
                              content: const Text(
                                "Le code fourni est invalide. Veuillez entrer un code correcte ou "
                                "renvoyer la demande si vous avez reçu le code avec une grand retard.",
                              ),
                              backgroundColor: Theme.of(context).colorScheme.error,
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  // Actions buttons.
                  const SizedBox(height: CConstants.GOLDEN_SIZE * 4),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    const Text("Vous n'avez pas reçus le code ?"),
                    TextButton(
                      style: const ButtonStyle(visualDensity: VisualDensity.compact),
                      onPressed: () => _sendOtp(
                        onSuccess: (otp, expireAt) => CSnackbarWidget(
                          context,
                          defaultDuration: true,
                          content: const Text("Demande envoyer"),
                        ),
                      ),
                      child: const Text("Renvoyer"),
                    ),
                  ]),

                  // --- Actions :
                  const SizedBox(height: CConstants.GOLDEN_SIZE * 3),
                  Row(children: [
                    const Spacer(),
                    TextButton(onPressed: () => Navigator.pop(context), child: const Text("Corriger le numéro")),
                    // FilledButton(onPressed: () {}, child: const Text("OK")),
                  ]),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // -------------------------------------------------------------------------------------------------------------------------
  void startAccountValidation(Map data) {
    CModalWidget(
      context: context,
      child: Padding(
        padding: const EdgeInsets.all(CConstants.GOLDEN_SIZE),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Installation des donnés utilisateur", style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: CConstants.GOLDEN_SIZE),
            LinearProgressIndicator(borderRadius: BorderRadius.circular(CConstants.GOLDEN_SIZE / 2)),
          ],
        ),
      ),
    ).show(persistant: true);

    // Validate account.
    RegisterMv().validateAccount(
      phoneCode,
      phoneNumber,
      onSuccess: () {
        startAccountAutoLogin();
      },
      onFailed: () {
        debugPrint("ACCOUNT VALIDATION ERROR ******************************");
      },
    );
  }

  void startAccountAutoLogin() {
    LoginMv loginMv = LoginMv();
    loginMv.login(phoneCode, phoneNumber, onFinish: () {
      loginMv.downloadAndInstallUserDatas(
        onFinish: () => goAtHomeScreen(),
        onFailed: () => __showSnackBar(
          "Impossible de télécharger les données utilisateurs. "
          "Veuillez recommencer le processus et vérifier votre connexion internet.",
        ),
      );
    });
  }

  void goAtHomeScreen() {
    context.goNamed(HomeScreen.routeName);
  }

  void __showSnackBar(String message) {
    CSnackbarWidget(context, content: Text(message), backgroundColor: Theme.of(context).colorScheme.error);
  }

  void _sendOtp({Function(String otp, int expireAt)? onSuccess}) {
    COtpHandlerClass.request(
      phoneCode,
      phoneNumber,
      onSuccess: (otp, expir) {
        setState(() => _otp = otp);
        onSuccess?.call(otp, expir);
      },
      onFailed: () {
        __showSnackBar(
          "Impossible de faire la demande d'un nouveau code OTP. "
          "Veuillez recommencer le processus ou appuyez sur le bouton Renvoyer et vérifier votre connexion internet.",
        );
      },
    );
  }
}
