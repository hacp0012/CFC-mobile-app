import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_loading/card_loading.dart';
import 'package:cfc_christ/classes/c_image_handler_class.dart';
import 'package:cfc_christ/configs/c_api.dart';
import 'package:cfc_christ/configs/c_constants.dart';
import 'package:cfc_christ/configs/c_styled_text_tags.dart';
import 'package:cfc_christ/model_view/misc_data_handler_mv.dart';
import 'package:cfc_christ/model_view/pcn_data_handler_mv.dart';
import 'package:cfc_christ/theme/c_transition_thme.dart';
import 'package:cfc_christ/views/layouts/empty_layout.dart';
import 'package:cfc_christ/views/widgets/c_snackbar_widget.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_cache_manager_dio/flutter_cache_manager_dio.dart';
import 'package:go_router/go_router.dart';
import 'package:styled_text/styled_text.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';
import 'package:url_launcher/url_launcher.dart';

class UserProfileDetailsScreen extends StatefulWidget {
  static const String routeName = 'all.user.profile.detail';
  static const String routePath = 'profile/detail';

  final GoRouterState? grState;

  const UserProfileDetailsScreen({super.key, this.grState});

  @override
  State createState() => _UserProfileDetailsScreenState();
}

class _UserProfileDetailsScreenState extends State<UserProfileDetailsScreen> {
  // DATA ------------------------------------------------------------------------------------------------------------------
  String? userId;
  bool isInLoading = false;

  Map? userData;
  Map? coupleData;

  // INITIALIZER -----------------------------------------------------------------------------------------------------------
  @override
  void initState() {
    userId = ((widget.grState?.extra ?? {}) as Map)['user_id'];

    super.initState();

    downloadUserInfos();
  }

  @override
  void setState(VoidCallback fn) => super.setState(fn);

  // VIEW ------------------------------------------------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: Scaffold(
        appBar: AppBar(title: Text('Profil ${userData?['name'] ?? ''}'), centerTitle: true),

        // Body.
        body: Builder(builder: (context) {
          if (isInLoading) {
            return ListView(children: const [
              SizedBox(height: CConstants.GOLDEN_SIZE),
              Column(children: [
                CardLoading(
                  height: CConstants.GOLDEN_SIZE * 16,
                  width: CConstants.GOLDEN_SIZE * 16,
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                ),
                SizedBox(height: CConstants.GOLDEN_SIZE),
                CardLoading(
                  height: CConstants.GOLDEN_SIZE * 3,
                  width: CConstants.GOLDEN_SIZE * 12,
                  borderRadius: BorderRadius.all(Radius.circular(CConstants.DEFAULT_RADIUS)),
                ),
                SizedBox(height: CConstants.GOLDEN_SIZE * 2),
                Padding(
                  padding: EdgeInsets.all(9.0),
                  child: CardLoading(
                    height: CConstants.GOLDEN_SIZE * 6,
                    borderRadius: BorderRadius.all(Radius.circular(CConstants.DEFAULT_RADIUS)),
                  ),
                ),
              ]),
              SizedBox(height: CConstants.GOLDEN_SIZE * 4),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: CConstants.GOLDEN_SIZE * 2),
                  child: CardLoading(
                    height: CConstants.GOLDEN_SIZE * 3,
                    width: CConstants.GOLDEN_SIZE * 18,
                    borderRadius: BorderRadius.all(Radius.circular(CConstants.DEFAULT_RADIUS)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: CConstants.GOLDEN_SIZE * 2, vertical: CConstants.GOLDEN_SIZE),
                  child: CardLoading(
                    height: CConstants.GOLDEN_SIZE * 3,
                    width: CConstants.GOLDEN_SIZE * 12,
                    borderRadius: BorderRadius.all(Radius.circular(CConstants.DEFAULT_RADIUS)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: CConstants.GOLDEN_SIZE * 2, vertical: CConstants.GOLDEN_SIZE),
                  child: CardLoading(
                    height: CConstants.GOLDEN_SIZE * 3,
                    width: CConstants.GOLDEN_SIZE * 23,
                    borderRadius: BorderRadius.all(Radius.circular(CConstants.DEFAULT_RADIUS)),
                  ),
                ),
              ]),
            ]);
          } else {
            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: CConstants.GOLDEN_SIZE),
              children: [
                const SizedBox(height: CConstants.GOLDEN_SIZE * 2),
                Column(children: [
                  GestureAnimator(
                    child: CachedNetworkImage(
                      cacheManager: DioCacheManager.instance,
                      imageUrl: CImageHandlerClass.byPid(userData?['photo']),
                      imageBuilder: (context, imageProvider) => CircleAvatar(
                        radius: CConstants.GOLDEN_SIZE * 8,
                        backgroundImage: imageProvider,
                      ),
                    ),
                    onTap: () => CImageHandlerClass.show(context, [userData?['photo']]),
                  ),
                  const SizedBox(height: CConstants.GOLDEN_SIZE),
                  StyledText.selectable(
                    text: "${userData?['civility'] == 'F' ? 'Frère' : 'Sœur'} "
                        "<bold>${userData?['name']}</bold>",
                    tags: CStyledTextTags().tags,
                  ),
                  SelectableText("${userData?['fullname']}"),
                  SelectableText(
                    "${MiscDataHandlerMv.getRole(userData?['role']?['role'])['name']} "
                    "[${MiscDataHandlerMv.getRole(userData?['role']?['role'])['level'] ?? 'App'}]",
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ]),

                // ETAT CIVIL.
                const SizedBox(height: CConstants.GOLDEN_SIZE),
                Builder(builder: (context) {
                  String partnerHand = userData?['civility'] == 'F' ? 'epouse' : 'epoue';
                  String? mariedDate = coupleData?['d_mariage'] != null
                      ? DateTime.parse(coupleData?['d_mariage'] ?? '').format('D, j M Y')
                      : null;

                  return Card.filled(
                    child: Padding(
                      padding: const EdgeInsets.all(CConstants.GOLDEN_SIZE),
                      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        const Icon(CupertinoIcons.person_2),
                        const SizedBox(width: CConstants.GOLDEN_SIZE),
                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            StyledText(
                              text: "Etat civil <bold>${coupleData?[partnerHand] == null ? 'Célibataire' : 'Marié'}</bold>",
                              tags: CStyledTextTags().tags,
                            ),
                            if (coupleData != null) ...[
                              Row(children: [
                                GestureAnimator(
                                  child: CachedNetworkImage(
                                    imageUrl: CImageHandlerClass.byPid(userData?['photo']),
                                    cacheManager: DioCacheManager.instance,
                                    imageBuilder: (context, imageProvider) =>
                                        CircleAvatar(radius: CConstants.GOLDEN_SIZE * 3, backgroundImage: imageProvider),
                                  ),
                                  onTap: () => CImageHandlerClass.show(context, [userData?['photo']]),
                                ),
                                const SizedBox(width: CConstants.GOLDEN_SIZE),
                                Expanded(
                                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                    StyledText(
                                      text: "<bold>${coupleData?[partnerHand]?['fullname']}</bold>",
                                      tags: CStyledTextTags().tags,
                                    ),
                                    StyledText(
                                        text: "<xsmall>Couple</xsmall> ${coupleData?['nom'] ?? '---'}",
                                        tags: CStyledTextTags().tags),
                                  ]),
                                ),
                              ]),
                              StyledText.selectable(
                                text: "<br/>"
                                    "Depuis ${mariedDate ?? '---'} <br/>"
                                    "Adresse ${coupleData?['adresse'] ?? '---'} <br/>"
                                    "Téléphone ${coupleData?['phone'] ?? '---'}"
                                    "",
                                tags: CStyledTextTags().tags,
                              ),
                            ]
                          ]),
                        ),
                      ]),
                    ),
                  );
                }),

                // PHONE.
                const SizedBox(height: CConstants.GOLDEN_SIZE),
                Card.filled(
                  child: Padding(
                    padding: const EdgeInsets.all(CConstants.GOLDEN_SIZE),
                    child: Row(children: [
                      IconButton(
                        icon: const Icon(CupertinoIcons.phone),
                        style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.surface)),
                        onPressed: () => openPhoneNumber(userData?['telephone']),
                      ),
                      const SizedBox(width: CConstants.GOLDEN_SIZE),
                      SelectableText("${userData?['telephone']?[0]} ${userData?['telephone']?[1]}"),
                    ]),
                  ),
                ),

                // PCN
                const SizedBox(height: CConstants.GOLDEN_SIZE),
                Card.filled(
                  child: Padding(
                    padding: const EdgeInsets.all(CConstants.GOLDEN_SIZE),
                    child: Builder(builder: (context) {
                      if (userData?['pool'] != null && userData?['com_loc'] != null && userData?['noyau_af'] != null) {
                        String pool = (PcnDataHandlerMv.getPool(userData?['pool'] ?? '') ?? {})['nom'] ?? '';
                        String cl = (PcnDataHandlerMv.getPool(userData?['com_loc'] ?? '') ?? {})['nom'] ?? '';
                        String na = (PcnDataHandlerMv.getPool(userData?['noyau_af'] ?? '') ?? {})['nom'] ?? '';

                        return StyledText.selectable(
                          text: "PCN <xsmall>(Pool, Communauté locale et Noyau d'affermissement)</xsmall>"
                              "<br/>"
                              "<br/>"
                              "Pool  <bold>$pool</bold>"
                              "<br/>"
                              "CL     <bold>$cl</bold>"
                              "<br/>"
                              "NA    <bold>$na</bold>"
                              "",
                          tags: CStyledTextTags().tags,
                        );
                      } else {
                        return const Text("La personne n'appartient à aucune communauté.");
                      }
                    }),
                  ),
                ),

                // INFO.
                const SizedBox(height: CConstants.GOLDEN_SIZE),
                Card.filled(
                  color: Theme.of(context).colorScheme.surface,
                  child: Padding(
                    padding: const EdgeInsets.all(CConstants.GOLDEN_SIZE),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Icon(CupertinoIcons.exclamationmark_circle, size: CConstants.GOLDEN_SIZE * 2),
                      SelectableText(
                        "Cette page fournit quelques informations sur l'utilisateur ${userData?['name'] ?? ''}. "
                        "Pour plus d'informations, vous pouvez contacter un responsable de la plate-forme.",
                      ),
                    ]),
                  ),
                ),

                const SizedBox(height: CConstants.GOLDEN_SIZE * 9),
              ],
            ).animate(effects: CTransitionsTheme.model_1);
          }
        }),
      ),
    );
  }

  // METHODES ----------------------------------------------------------------------------------------------------------------
  void downloadUserInfos() async {
    setState(() => isInLoading = true);

    CApi.request.get('/user/medium/info', data: {'user_id': userId ?? '---'}).then((res) {
      setState(() {
        isInLoading = false;
        userData = res.data['user'];
        coupleData = res.data['couple'];
      });
    }).catchError((e) {
      _back();
      _showSnackbar(
        "Échec de téléchargement des données utilisateur. Vérifier l'état de vôtre connexion internet.",
        true,
        true,
      );
    });
  }

  void _showSnackbar(String s, [bool danger = true, bool action = false]) {
    CSnackbarWidget(
      context,
      content: Text(s),
      backgroundColor: danger ? Theme.of(context).colorScheme.error : null,
      actionLabel: action ? 'Réessayer' : null,
      action: action ? () => downloadUserInfos() : null,
    );
  }

  void _back() => context.pop();

  openPhoneNumber(List? phone) async {
    if (phone != null) {
      String phoneNumber = (phone[1] as String).replaceAll(RegExp(r'[\- ]'), '');

      await launchUrl(Uri.parse("tel:${phone[0]}$phoneNumber"));
    }
  }
}
