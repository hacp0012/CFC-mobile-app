import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_loading/card_loading.dart';
import 'package:cfc_christ/classes/c_image_handler_class.dart';
import 'package:cfc_christ/configs/c_api.dart';
import 'package:cfc_christ/configs/c_constants.dart';
import 'package:cfc_christ/configs/c_styled_text_tags.dart';
import 'package:cfc_christ/model_view/user_mv.dart';
import 'package:cfc_christ/theme/c_transition_thme.dart';
import 'package:cfc_christ/views/components/c_find_couple_component.dart';
import 'package:cfc_christ/views/layouts/empty_layout.dart';
import 'package:cfc_christ/views/screens/app/contactus_screen.dart';
import 'package:cfc_christ/views/screens/user/user_profile_details_screen.dart';
import 'package:cfc_christ/views/widgets/c_modal_widget.dart';
import 'package:cfc_christ/views/widgets/c_snackbar_widget.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_cache_manager_dio/flutter_cache_manager_dio.dart';
import 'package:go_router/go_router.dart';
import 'package:styled_text/styled_text.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

class UserFamilyParentsScreen extends StatefulWidget {
  static const String routeName = 'family.parents';
  static const String routePath = 'parents';

  const UserFamilyParentsScreen({super.key});

  @override
  State<UserFamilyParentsScreen> createState() => _UserFamilyParentsScreenState();
}

class _UserFamilyParentsScreenState extends State<UserFamilyParentsScreen> {
  // DATAS -------------------------------------------------------------------------------------------------------------------
  Map? userData = UserMv.data;
  Map familyData = {"father": null, "mother": null, "couple": null};
  bool isInLoading = true;
  bool hasRequestInWaiting = false;
  bool makeChildRequest = false;
  Map? selectedCouple;

  // INITIALIZER -------------------------------------------------------------------------------------------------------------
  @override
  void initState() {
    super.initState();

    checkValidableStatus();
  }

  @override
  void setState(VoidCallback fn) => super.setState(fn);

  // VIEW --------------------------------------------------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: Scaffold(
        appBar: AppBar(title: const Text('Mes Parents')),

        // BODY.
        body: SingleChildScrollView(
          child: Builder(builder: (context) {
            if (isInLoading) {
              return const Padding(
                padding: EdgeInsets.all(CConstants.GOLDEN_SIZE),
                child: Column(
                  children: [
                    CardLoading(
                      height: CConstants.GOLDEN_SIZE * 12,
                      borderRadius: BorderRadius.all(Radius.circular(CConstants.DEFAULT_RADIUS)),
                      child: Padding(
                        padding: EdgeInsets.all(CConstants.GOLDEN_SIZE),
                        child: Text("Chargement"),
                      ),
                    ),
                    SizedBox(height: CConstants.GOLDEN_SIZE),
                    CardLoading(
                      height: CConstants.GOLDEN_SIZE * 12,
                      borderRadius: BorderRadius.all(Radius.circular(CConstants.DEFAULT_RADIUS)),
                    ),
                    SizedBox(height: CConstants.GOLDEN_SIZE),
                    CardLoading(
                      height: CConstants.GOLDEN_SIZE * 12,
                      borderRadius: BorderRadius.all(Radius.circular(CConstants.DEFAULT_RADIUS)),
                    ),
                    SizedBox(height: CConstants.GOLDEN_SIZE),
                    CardLoading(
                      height: CConstants.GOLDEN_SIZE * 12,
                      borderRadius: BorderRadius.all(Radius.circular(CConstants.DEFAULT_RADIUS)),
                    ),
                  ],
                ),
              ).animate(effects: CTransitionsTheme.model_1);
            } else if (familyData['couple'] != null) {
              String mariedDate = DateTime.parse(familyData['couple']['d_mariage']).format('j M Y');

              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(CConstants.GOLDEN_SIZE),
                  child: Column(children: [
                    Text("Le couple", style: Theme.of(context).textTheme.labelMedium),
                    Text(familyData['couple']['nom'], style: Theme.of(context).textTheme.titleMedium),
                    Text("Marié depuis le $mariedDate"),
                    Text("Une famille chrétienne", style: Theme.of(context).textTheme.labelSmall),

                    // FATHER.
                    const SizedBox(height: CConstants.GOLDEN_SIZE),
                    if (familyData['father'] != null)
                      ListTile(
                        leading: CachedNetworkImage(
                          imageUrl: CImageHandlerClass.byPid(familyData['father']?['photo']),
                          cacheManager: DioCacheManager.instance,
                          imageBuilder: (context, imageProvider) => CircleAvatar(backgroundImage: imageProvider),
                        ),
                        title: Text(familyData['father']?['fullname']),
                        subtitle: Text(
                          "${familyData['father']?['name']} est le père de la famille chrétienne ${familyData['couple']?['nom']} qui votre famille.",
                        ),
                        onTap: () => context.pushNamed(
                          UserProfileDetailsScreen.routeName,
                          extra: {'user_id': familyData['father']['id']},
                        ),
                      ).animate(effects: CTransitionsTheme.model_1),

                    // MOTHER.
                    const SizedBox(height: CConstants.GOLDEN_SIZE),
                    if (familyData['mother'] != null)
                      ListTile(
                        leading: CachedNetworkImage(
                          imageUrl: CImageHandlerClass.byPid(familyData['mother']?['photo']),
                          cacheManager: DioCacheManager.instance,
                          imageBuilder: (context, imageProvider) => CircleAvatar(backgroundImage: imageProvider),
                        ),
                        title: Text(familyData['mother']?['fullname']),
                        subtitle: Text(
                          "${familyData['mother']?['name']} est la mère de la famille chrétienne ${familyData['couple']?['nom']} qui votre famille.",
                        ),
                        onTap: () => context.pushNamed(
                          UserProfileDetailsScreen.routeName,
                          extra: {'user_id': familyData['mother']['id']},
                        ),
                      ).animate(effects: CTransitionsTheme.model_1),
                  ]),
                ),
              );
            } else if (hasRequestInWaiting) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(CConstants.GOLDEN_SIZE),
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    const Icon(CupertinoIcons.clock, size: CConstants.GOLDEN_SIZE * 4),
                    const SizedBox(height: CConstants.GOLDEN_SIZE),
                    StyledText(
                      text: "<bold>Il y a une demande qui est en cours</bold> "
                          '<br/>'
                          '<br/>'
                          "Car vous aviez demandé à une famille de vous accepter parmis leurs enfant. "
                          "Et la demande est en attente d'approbation par les responsables de la famille.",
                      tags: CStyledTextTags().tags,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: CConstants.GOLDEN_SIZE),
                    FilledButton.tonalIcon(
                      onPressed: () => checkValidableStatus(),
                      icon: const Icon(CupertinoIcons.upload_circle),
                      label: const Text("Vérifier l'état de la demande"),
                    ),
                    const SizedBox(height: CConstants.GOLDEN_SIZE * 3),
                    Text(
                      "Si vous soupçonnez que, quelque chose ne vas pas, vous pouvez "
                      "contacter un responsable de la plate-forme CFC.",
                      style: Theme.of(context).textTheme.labelSmall,
                      textAlign: TextAlign.center,
                    ),
                    TextButton(
                      onPressed: () => context.pushNamed(ContactusScreen.routeName),
                      style: const ButtonStyle(visualDensity: VisualDensity.compact),
                      child: const Text("Contacter un responsable"),
                    ),
                  ]),
                ),
              ).animate(effects: CTransitionsTheme.model_1);
            } else if (makeChildRequest) {
              return Center(
                child: Column(children: [
                  const SizedBox(height: CConstants.GOLDEN_SIZE * 3),
                  const Icon(CupertinoIcons.person_2_square_stack, size: CConstants.GOLDEN_SIZE * 6),
                  const SizedBox(height: CConstants.GOLDEN_SIZE),
                  StyledText(
                    text: "<bold>Vous n'avez pas des parents</bold> "
                        '<br/>'
                        '<br/>'
                        "Pour en avoir, vous devez sélectionner un couple et une demande d'approbation leurs sera envoyé.",
                    tags: CStyledTextTags().tags,
                    textAlign: TextAlign.center,
                  ),

                  // Selected couple.
                  const SizedBox(height: CConstants.GOLDEN_SIZE * 2),
                  if (selectedCouple != null) ...[
                    Text(
                      "Vous venez de sélectionner la famille ${selectedCouple?['nom']}",
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    Chip(
                      avatar: const Icon(CupertinoIcons.person_2),
                      label: Text(selectedCouple?['nom']),
                      deleteIcon: const Icon(CupertinoIcons.xmark),
                      onDeleted: () => setState(() => selectedCouple = null),
                    ).animate(effects: CTransitionsTheme.model_1),
                  ],

                  // Search button.
                  const SizedBox(height: CConstants.GOLDEN_SIZE),
                  TextButton.icon(
                    icon: const Icon(CupertinoIcons.search),
                    onPressed: () => openCoupleFitchModal(),
                    label: const Text("Chercher une famille"),
                  ),

                  // Send request.
                  if (selectedCouple != null) ...[
                    const SizedBox(height: CConstants.GOLDEN_SIZE * 2),
                    Text(
                      "Si vous avez sélectionné la bonne famille (couple), vous pouvez poursuivre en envoyant la demande.",
                      style: Theme.of(context).textTheme.labelSmall,
                      textAlign: TextAlign.center,
                    ),
                    FilledButton.tonalIcon(
                      icon: const Icon(CupertinoIcons.paperplane),
                      onPressed: () => sendDemande(),
                      label: const Text("Envoyer la demande"),
                    ).animate(effects: CTransitionsTheme.model_1),
                  ],
                ]),
              );
            }

            return Padding(
              padding: const EdgeInsets.all(CConstants.GOLDEN_SIZE),
              child: Column(children: [
                const SizedBox(height: CConstants.GOLDEN_SIZE),
                Card.filled(
                  child: Padding(
                    padding: const EdgeInsets.all(CConstants.GOLDEN_SIZE),
                    child: Column(
                      children: [
                        WidgetAnimator(
                          atRestEffect: WidgetRestingEffects.swing(),
                          child: const Icon(CupertinoIcons.exclamationmark_circle, size: CConstants.GOLDEN_SIZE * 4),
                        ),
                        const SizedBox(height: CConstants.GOLDEN_SIZE),
                        StyledText(
                          text: "Ici paraîtra les informations concernant la famille. "
                              "À laquelle vous est membres. Les identités concernant les parents qui "
                              "sont les votre.",
                          tags: CStyledTextTags().tags,
                        ),
                      ],
                    ),
                  ),
                ).animate(effects: CTransitionsTheme.model_1),
              ]),
            );
          }),
        ),
      ),
    );
  }

  // METHODES ----------------------------------------------------------------------------------------------------------------
  void downloadParentData() {
    setState(() => isInLoading = true);

    CApi.request.get('/user/child/parents').then((res) {
      setState(() {
        isInLoading = false;
        familyData = res.data;

        if (familyData['couple'] == null) {
          makeChildRequest = true;
        }
      });
    }).catchError((e) {
      setState(() => isInLoading = false);
      _showSnackbar("Impossible de télécharger des données de la famille. Veuillez réessayer plus tard.");
    });
  }

  void _showSnackbar(String s) => CSnackbarWidget(context, content: Text(s), defaultDuration: true);

  void checkValidableStatus() {
    Map data = {
      's': 'child',
      'f': 'has_validable_to_parent',
    };
    setState(() => isInLoading = true);

    CApi.request.post('/family/request/handler', data: data).then((res) {
      if (res.data['state'] == 'NO') {
        downloadParentData();
      } else {
        setState(() {
          hasRequestInWaiting = true;
          isInLoading = false;
        });
      }
    }).catchError((e) {
      setState(() => isInLoading = false);
      _showSnackbar("Impossible de contacter le serveur. Vérifier la qualité de votre connexion internet.");
    });
  }

  void sendDemande() {
    if (selectedCouple != null) {
      _showLoadingDialog();

      Map data = {
        's': 'child',
        'f': 'send_demande_to_couple',
        'couple_id': selectedCouple?['id'],
      };

      CApi.request.post('/family/request/handler', data: data).then((res) {
        _back();
        if (res.data['state'] == 'SENT') {
          setState(() => makeChildRequest = false);
          checkValidableStatus();
        } else {
          _showSnackbar("Votre demande n'a pas pus être résolu.");
        }
      }).catchError((e) {
        _back();
        _showSnackbar("Impossible d'envoyer la demande, vérifie l'état de vôtre connexion internet.");
      });
    } else {
      _showSnackbar("sVous n'avez encore sélectionné un couple.");
    }
  }

  void openCoupleFitchModal() {
    CModalWidget.fullscreen(
      context: context,
      child: Padding(
        padding: const EdgeInsets.all(CConstants.GOLDEN_SIZE),
        child: CFindCoupleComponent(
          isParent: false,
          civilite: userData?['civilite'] ?? '---',
          selected: selectedCouple,
          onSelected: (selected) => setState(() {
            selectedCouple = selected;
          }),
        ),
      ),
    ).show();
  }

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

  void _back() => context.pop();
}
