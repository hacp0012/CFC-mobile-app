import 'package:cfc_christ/configs/c_api.dart';
import 'package:cfc_christ/configs/c_constants.dart';
import 'package:cfc_christ/model_view/auth/login_mv.dart';
import 'package:cfc_christ/theme/c_transition_thme.dart';
import 'package:cfc_christ/views/components/c_otp_component.dart';
import 'package:cfc_christ/views/layouts/empty_layout.dart';
import 'package:cfc_christ/views/widgets/c_snackbar_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

class UserNewPhoneValidationOtpScreen extends StatefulWidget {
  static const String routeName = "new.user.phone.number.otp.validation";
  static const String routePath = "new/user/phone/otp/validation";

  const UserNewPhoneValidationOtpScreen({super.key, this.grState});

  final GoRouterState? grState;

  @override
  State<UserNewPhoneValidationOtpScreen> createState() => _UserNewPhoneValidationOtpScreenState();
}

class _UserNewPhoneValidationOtpScreenState extends State<UserNewPhoneValidationOtpScreen> {
  // DATAS -------------------------------------------------------------------------------------------------------------------
  String phoneCode = '';
  String phoneNumber = '';
  String oldPhoneNumber = '';
  String _otp = "";

  // INITIALIZERS ------------------------------------------------------------------------------------------------------------
  void _s(fn) => super.setState(fn);

  @override
  void initState() {
    var data = (widget.grState?.extra ?? {}) as Map;
    phoneCode = data['phone_code'] ?? '';
    phoneNumber = data['phone_number'] ?? '';
    oldPhoneNumber = data['old_phone_number'] ?? '';

    super.initState();

    autoRequestOtpCode();
  }

  // VIEW --------------------------------------------------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return EmptyLayout(
      child: Scaffold(
        appBar: AppBar(title: const Text('Nouveau numéro')),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: CConstants.MAX_CONTAINER_WIDTH),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: CConstants.GOLDEN_SIZE),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Icon(CupertinoIcons.phone, size: CConstants.GOLDEN_SIZE * 9)
                    .animate(effects: CTransitionsTheme.model_1),
                const SizedBox(height: CConstants.GOLDEN_SIZE),
                Text(
                  "Valider le nouveau numéro de téléphone",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: CConstants.GOLDEN_SIZE),
                Text(
                  "Un code OTP vous a été envoyé sur le nouveau numéro de téléphone ($phoneCode) $phoneNumber. "
                  "Veuillez l'entrer dans les champs ci-dessous. [$_otp]",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: CConstants.GOLDEN_SIZE),
                COtpComponent(
                  phoneCode: phoneCode,
                  phoneNumber: phoneNumber,
                  onSuccess: (data) {
                    if(data['state'] == 'VALIDE') {
                      validateNewPhoneNumber();
                    } else {
                      _showSnackbar("Le code OTP que vous avez fourni est incorrect.");
                    }
                  },
                  onFailed: () => _showSnackbar("Erreur réseau, vérifier votre connexion internet."),
                ),
                const SizedBox(height: CConstants.GOLDEN_SIZE * 3),
                Row(children: [
                  const Spacer(),
                  FilledButton.tonalIcon(
                    icon: const Icon(CupertinoIcons.check_mark),
                    label: const Text("Valider"),
                    onPressed: () {},
                  )
                ]),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  // METHODES ----------------------------------------------------------------------------------------------------------------
  void autoRequestOtpCode() {
    CApi.request.post('/feature/otp/send', data: {'phone_code': phoneCode, 'phone_number': phoneNumber}).then(
      (response) {
        if (response.data['state'] == 'SENT') {
          _s(() => _otp = response.data['otp']);
        }
      },
      onError: (error) => _showSnackbar(
        "Le serveur est injouable pour vous livrer votre code OTP. "
        "Vérifier votre connexion internet.",
      ),
    );
  }

  void validateNewPhoneNumber() {
    Map data = {
      'phone_code': phoneCode,
      'phone_number': phoneNumber,
      'old_phone_number': oldPhoneNumber,
    };

    CApi.request.post("/user/phone/update", data: data).then(
          (response) {
            if (response.data['state'] == 'SUCCESS') {
              // Download user data.
              LoginMv().downloadAndInstallUserDatas();

              _showSnackbar("Numéro changé avec succès", Colors.green.shade200);

              _back();
            } else {
              _showSnackbar("Votre numéro est déjà changé.", Colors.red);
            }
          },
          onError: (error) {
            _showSnackbar("Erreur réseau, vérifier votre connexion internet.");
          },
        );
  }

  void _back() => Navigator.pop(context);

  void _showSnackbar(String message, [Color? color]) {
    CSnackbarWidget(
      context,
      content: Text(message),
      backgroundColor: color ?? Theme.of(context).colorScheme.error,
      defaultDuration: true,
    );
  }
}
