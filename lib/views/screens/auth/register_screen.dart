import 'dart:async';

import 'package:cfc_christ/classes/c_form_validator.dart';
import 'package:cfc_christ/configs/c_constants.dart';
import 'package:cfc_christ/model_view/auth/register_mv.dart';
import 'package:cfc_christ/model_view/misc_data_handler_mv.dart';
import 'package:cfc_christ/model_view/pcn_data_handler_mv.dart';
import 'package:cfc_christ/theme/c_transition_thme.dart';
import 'package:cfc_christ/views/components/c_find_couple_component.dart';
import 'package:cfc_christ/views/layouts/default_layout.dart';
import 'package:cfc_christ/views/screens/auth/register_otp_screen.dart';
import 'package:cfc_christ/views/widgets/c_modal_widget.dart';
import 'package:cfc_christ/views/widgets/c_snackbar_widget.dart';
import 'package:easy_mask/easy_mask.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key, this.grState});

  static const String routeName = 'register';
  static const String routePath = '/enregistrement';

  final GoRouterState? grState;

  @override
  createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String typePersonne = 'parent'; // parent|jeune
  bool backState = false;
  bool processIsBegining = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController phoneInputControler = TextEditingController();
  final TextEditingController coupleTextFieldController = TextEditingController();

  // Couple search datas :
  Map coupleDatas = {
    'state': 'inputed', // inputed | selected.
    'selected': null,
  };

  Map inputDatas = {
    'nom': null,
    'prenom': null,
    'civilite': 'F',
    'd_naissance': null,
    'phone_code': '243',
    'phone_number': null,
    'deja_membre': false,
    'pool': '',
    'com': '',
    'na': '',
  };

  @override
  void setState(VoidCallback fn) => super.setState(fn);

  void _s(VoidCallback fn) => super.setState(fn);

  @override
  void initState() {
    Map extra = (widget.grState?.extra ?? {}) as Map;
    inputDatas['phone_code'] = extra['phone_code'] ?? '';
    inputDatas['phone_number'] = extra['phone_number'] ?? '';
    phoneInputControler.text = extra['phone_number'] ?? '';

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuEntry> dropDownPcnList = PcnDataHandlerMv.pools.map((element) {
      return DropdownMenuEntry(
        value: element['id'],
        label: element['nom'],
        leadingIcon: const Icon(CupertinoIcons.home),
      );
    }).toList();
    List<DropdownMenuEntry> dropDownComList(lab) => PcnDataHandlerMv.fitchCom(lab).map((element) {
          return DropdownMenuEntry(
            value: element['id'],
            label: element['nom'],
            leadingIcon: const Icon(CupertinoIcons.person_3),
          );
        }).toList();
    List<DropdownMenuEntry> dropDownNAList(lab) => PcnDataHandlerMv.fitchNa(lab).map((element) {
          return DropdownMenuEntry(
            value: element['id'],
            label: element['nom'],
            leadingIcon: const Icon(CupertinoIcons.link),
          );
        }).toList();
    List<DropdownMenuEntry> dropDownPhoneCodeList = MiscDataHandlerMv.countriesCodes.map((element) {
      return DropdownMenuEntry(value: element['code'], label: "${element['country']} ${element['code']}");
    }).toList();

    // -------------------------------------------------------------- :
    return DefaultLayout(
      child: Scaffold(
        appBar: AppBar(title: const Text("S'inscrire"), centerTitle: true),

        // Body.
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(CConstants.GOLDEN_SIZE),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: CConstants.GOLDEN_SIZE * 45),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SegmentedButton<String>(
                      segments: const [
                        ButtonSegment<String>(value: 'parent', label: Text('Parent')),
                        ButtonSegment<String>(value: 'jeune', label: Text('Jeune')),
                      ],
                      selected: <String>{typePersonne},
                      onSelectionChanged: (Set<String> selected) => _s(() {
                        typePersonne = selected.first;
                        coupleDatas['selected'] = null;
                        coupleTextFieldController.text = '';
                      }),
                    ),

                    // Form.
                    const SizedBox(height: CConstants.GOLDEN_SIZE * 3),
                    Form(
                      key: _formKey,
                      // autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        children: [
                          TextFormField(
                            validator: CFormValidator([CFormValidator.required(), CFormValidator.min(3)]).validate,
                            decoration: const InputDecoration(hintText: "Nom complet", labelText: 'Nom complet'),
                            textInputAction: TextInputAction.next,
                            onChanged: (value) => _s(() => inputDatas['nom'] = value),
                          ),
                          const SizedBox(height: CConstants.GOLDEN_SIZE * 1),
                          Row(children: [
                            Expanded(
                              child: TextFormField(
                                validator: CFormValidator([CFormValidator.required()]).validate,
                                decoration: const InputDecoration(hintText: "Prénom", labelText: 'Prénom'),
                                textInputAction: TextInputAction.next,
                                onChanged: (value) => _s(() => inputDatas['prenom'] = value),
                              ),
                            ),
                            const SizedBox(width: CConstants.GOLDEN_SIZE),
                            DropdownButtonHideUnderline(
                              child: DropdownMenu<String>(
                                label: const Text('Civilité'),
                                initialSelection: inputDatas['civilite'],
                                onSelected: (value) => _s(() => inputDatas['civilite'] = value),
                                dropdownMenuEntries: const [
                                  DropdownMenuEntry(value: 'F', label: 'Frère'),
                                  DropdownMenuEntry(value: 'S', label: 'Sœur'),
                                ],
                              ),
                            ),
                          ]),
                          const SizedBox(height: CConstants.GOLDEN_SIZE * 1),
                          TextFormField(
                            validator: CFormValidator([
                              CFormValidator.required(),
                              CFormValidator.max(10, message: "Data incomplete"),
                              CFormValidator.min(10, message: "Date incomplete"),
                            ]).validate,
                            decoration: const InputDecoration(hintText: "jj/mm/aaaa", label: Text("Date de naissance")),
                            keyboardType: TextInputType.datetime,
                            textInputAction: TextInputAction.next,
                            onChanged: (value) => _s(() => inputDatas['d_naissance'] = value),
                            inputFormatters: [TextInputMask(mask: '99/99/9999', placeholder: '-', maxPlaceHolders: 8)],
                          ),

                          // -- Couple :
                          const SizedBox(height: CConstants.GOLDEN_SIZE * 1),
                          TextFormField(
                            validator: CFormValidator([CFormValidator.required()]).validate,
                            controller: coupleTextFieldController,
                            textInputAction: TextInputAction.next,
                            readOnly: coupleDatas['state'] == 'selected' || typePersonne == 'jeune',
                            decoration: InputDecoration(
                              labelText:
                                  typePersonne == 'parent' ? (inputDatas['civilite'] == 'F' ? 'Épouse' : 'Épous') : 'Famille',
                              hintText:
                                  "Le nom de votre ${typePersonne == 'parent' ? 'partenaire (épous/épouse)' : 'Famille'}",
                              suffixIcon: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (coupleDatas['state'] == 'inputed')
                                    FilledButton.tonal(
                                      onPressed: () => openCoupleFitchModal(),
                                      style: const ButtonStyle(
                                        visualDensity: VisualDensity.compact,
                                        padding: WidgetStatePropertyAll(EdgeInsets.symmetric(
                                          horizontal: CConstants.GOLDEN_SIZE,
                                        )),
                                      ),
                                      child: const Text('Sélectionner'),
                                    )
                                  else
                                    IconButton(
                                      onPressed: () => setState(() {
                                        coupleDatas['state'] = 'inputed';
                                        coupleDatas['selected'] = null;
                                        coupleTextFieldController.text = '';
                                      }),
                                      icon: const Icon(Icons.clear),
                                      visualDensity: VisualDensity.compact,
                                    ),
                                  const SizedBox(width: CConstants.GOLDEN_SIZE),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: CConstants.GOLDEN_SIZE * 1),
                          Row(
                            children: [
                              Expanded(
                                child: DropdownButtonHideUnderline(
                                  child: DropdownMenu(
                                    onSelected: (value) => _s(() => inputDatas['phone_code'] = value),
                                    initialSelection: inputDatas['phone_code'],
                                    dropdownMenuEntries: dropDownPhoneCodeList,
                                  ),
                                ),
                              ),
                              const SizedBox(width: CConstants.GOLDEN_SIZE),
                              Expanded(
                                flex: 2,
                                child: TextFormField(
                                  validator: CFormValidator([CFormValidator.required()]).validate,
                                  controller: phoneInputControler,
                                  decoration: const InputDecoration(hintText: "Numéro de téléphone"),
                                  keyboardType: TextInputType.phone,
                                  textInputAction: TextInputAction.done,
                                  onChanged: (value) => _s(() => inputDatas['phone_number'] = value),
                                  inputFormatters: [TextInputMask(mask: '999-999-999', placeholder: '_', maxPlaceHolders: 9)],
                                ),
                              ),
                            ],
                          ),

                          // --- Membres :
                          const SizedBox(height: CConstants.GOLDEN_SIZE * 2),
                          CheckboxListTile(
                            value: inputDatas['deja_membre'],
                            controlAffinity: ListTileControlAffinity.leading,
                            visualDensity: VisualDensity.compact,
                            title: const Text("Je suis déjà membre d'une communauté, pool ou NA."),
                            onChanged: (bool? state) => setState(() => inputDatas['deja_membre'] = state ?? false),
                          ),

                          // -- Fileds list :
                          const SizedBox(height: CConstants.GOLDEN_SIZE * 2),
                          Visibility(
                            visible: inputDatas['deja_membre'],
                            child: Column(
                              children: [
                                DropdownButtonHideUnderline(
                                  child: DropdownMenu(
                                    label: const Text("Pool"),
                                    width: CConstants.MAX_CONTAINER_WIDTH,
                                    onSelected: (value) => _s(() {
                                      inputDatas['pool'] = value;
                                      inputDatas['com'] = '';
                                      inputDatas['na'] = '';
                                    }),
                                    dropdownMenuEntries: dropDownPcnList,
                                  ),
                                ),
                                const SizedBox(height: CConstants.GOLDEN_SIZE * 2),
                                DropdownButtonHideUnderline(
                                  child: DropdownMenu(
                                    initialSelection: inputDatas['com'],
                                    label: const Text("Communauté locale"),
                                    width: CConstants.MAX_CONTAINER_WIDTH,
                                    enabled: dropDownComList(inputDatas['pool']).isNotEmpty,
                                    onSelected: (value) => _s(() {
                                      inputDatas['com'] = value;
                                      inputDatas['na'] = '';
                                    }),
                                    dropdownMenuEntries: dropDownComList(inputDatas['pool']),
                                  ),
                                ),
                                const SizedBox(height: CConstants.GOLDEN_SIZE * 2),
                                DropdownButtonHideUnderline(
                                  child: DropdownMenu(
                                    initialSelection: inputDatas['na'],
                                    enabled: dropDownNAList(inputDatas['com']).isNotEmpty,
                                    label: const Text("Noyau d’affermissement"),
                                    width: CConstants.MAX_CONTAINER_WIDTH,
                                    onSelected: (value) => _s(() => inputDatas['na'] = value),
                                    dropdownMenuEntries: dropDownNAList(inputDatas['com']),
                                  ),
                                ),
                              ],
                            ).animate(effects: CTransitionsTheme.model_1),
                          ),
                        ],
                      ),
                    ),

                    // Actions.
                    const SizedBox(height: CConstants.GOLDEN_SIZE * 3),
                    Row(children: [
                      const BackButton(),
                      const Spacer(),
                      Visibility(
                        visible: processIsBegining,
                        replacement: FilledButton.tonal(
                          style: const ButtonStyle(),
                          onPressed: startProcess,
                          child: const Text("S'enregistrer"),
                        ).animate(effects: CTransitionsTheme.model_1),
                        child: const CircularProgressIndicator(),
                      ),
                    ]),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // -------------------------------------------------------------------------------------------------------------------------
  void openCoupleFitchModal() {
    CModalWidget.fullscreen(
      context: context,
      child: Padding(
        padding: const EdgeInsets.all(CConstants.GOLDEN_SIZE),
        child: CFindCoupleComponent(
          isParent: typePersonne == 'parent',
          civilite: inputDatas['civilite'],
          selected: coupleDatas['selected'],
          onSelected: (selected) => _s(() {
            if (selected != null) {
              coupleDatas['selected'] = selected;
              coupleDatas['state'] = 'selected';
              coupleTextFieldController.text = selected['nom'];
            }
          }),
        ),
      ),
    ).show();
  }

  bool inputFieldsControler() {
    // print((inputDatas['phone_number'] as String).replaceAll(RegExp('[-_]'), ''));
    if (_formKey.currentState!.validate()) {
      // Control for children :
      if (typePersonne == 'jeune' && coupleDatas['selected'] == null) {
        CSnackbarWidget(
          context,
          backgroundColor: Theme.of(context).colorScheme.error,
          content: const Text(
            "Un jeune doit avoir une famille avent de poursuive l'enregistrement. Sélectionnez une famille svp.",
          ),
        );

        return false;
      }

      // Control PHONE ID :
      if ((inputDatas['phone_code'] as String).isEmpty ||
          CFormValidator.min(9).call((inputDatas['phone_number'] as String).replaceAll(RegExp('[-_]'), '')) != null) {
        CSnackbarWidget(
          context,
          content: const Text("Le numéro de téléphone est incomplet"),
          backgroundColor: Colors.red,
          defaultDuration: true,
        );
        return false;
      }

      // Control PCN :
      if (inputDatas['deja_membre'] == true &&
          ((inputDatas['pool'] as String).isEmpty ||
              (inputDatas['com'] as String).isEmpty ||
              (inputDatas['na'] as String).isEmpty)) {
        CSnackbarWidget(
          context,
          content: const Text("Remplissez correctement les champs : Pool, Communauté locale et Noyau d'affermissement."),
          backgroundColor: Colors.red,
          defaultDuration: true,
        );
        return false;
      }

      return true;
    } else {
      return false;
    }
  }

  void startProcess() {
    if (inputFieldsControler()) {
      _s(() {
        processIsBegining = true;
      });
      _controlIfIsNotAlreadyRegistred();
    }
  }

  void _controlIfIsNotAlreadyRegistred() {
    RegisterMv().verifyIfRegistred(
      inputDatas['phone_code'],
      inputDatas['phone_number'],
      onRegistered: () {
        _s(() => processIsBegining = false);
        CSnackbarWidget(
          context,
          content: const Text("Ce compte est déjà enregistré \nVous devriez vous connecter."),
          // defaultDuration: true,
          backgroundColor: Theme.of(context).colorScheme.error,
          actionLabel: "D'accord",
          action: () => Navigator.pop(context),
        );
      },
      onUnregistered: () {
        _s(() => processIsBegining = false);
        _register();
      },
      onFailed: () {
        _s(() => processIsBegining = false);
        CSnackbarWidget(
          context,
          content: const Text("Erreur de processus d'enregistrement, veillez recommencer."),
          defaultDuration: true,
          backgroundColor: Colors.red,
        );
      },
    );
  }

  void _register() {
    CModalWidget(
      context: context,
      child: Padding(
        padding: const EdgeInsets.all(CConstants.GOLDEN_SIZE),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Enregistrement", style: Theme.of(context).textTheme.titleMedium),
            Text(
              "En cours d'enregistrement de votre profil. vous serez rediriger vers la "
              "validation OTP de votre nouveau compte.",
              style: Theme.of(context).textTheme.labelSmall,
            ),
            const SizedBox(height: CConstants.GOLDEN_SIZE),
            LinearProgressIndicator(borderRadius: BorderRadius.circular(CConstants.GOLDEN_SIZE / 2)),
          ],
        ),
      ),
    ).show(persistant: true);

    // Start:
    RegisterMv reg = RegisterMv();

    reg.register(
      name: inputDatas['prenom'],
      fullname: inputDatas['nom'],
      civility: inputDatas['civilite'],
      dBrith: inputDatas['d_naissance'],
      phoneCode: inputDatas['phone_code'],
      phoneNumber: inputDatas['phone_number'],
      alreadyMember: inputDatas['deja_membre'],
      isParent: typePersonne == 'parent',
      familyName: coupleTextFieldController.text,
      familyId: coupleDatas['selected'] != null ? coupleDatas['selected']['id'] : null,
      pool: inputDatas['pool'],
      cl: inputDatas['com'],
      na: inputDatas['na'],
      onSuccess: (data) {
        CModalWidget.close(context);
        Timer(450.ms, () {
          context.pushNamed(RegisterOtpScreen.routeName, extra: {
            'phone_code': inputDatas['phone_code'],
            'phone_number': inputDatas['phone_number'],
            '_otp': data['_otp'],
          });
        });
      },
      onFailed: (error) {
        context.pop();
        CSnackbarWidget(
          context,
          content: const Text("Échec ! Une erreur est survenue lors de l'enregistrement."),
          backgroundColor: Theme.of(context).colorScheme.error,
        );

        // TODO: remove because is for debug. {#f00,8}
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Registration error verif"),
            // content: Text(error.toString()),
            content: Text(error.toString()),
          ),
        );
      },
    );
  }
}
