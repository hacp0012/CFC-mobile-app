import 'dart:async';

import 'package:card_loading/card_loading.dart';
import 'package:cfc_christ/classes/c_misc_class.dart';
import 'package:cfc_christ/configs/c_constants.dart';
import 'package:cfc_christ/configs/c_styled_text_tags.dart';
import 'package:cfc_christ/model_view/main/com_mv.dart';
import 'package:cfc_christ/model_view/main/echo_mv.dart';
import 'package:cfc_christ/model_view/main/teaching_mv.dart';
import 'package:cfc_christ/theme/c_transition_thme.dart';
import 'package:cfc_christ/views/layouts/default_layout.dart';
import 'package:cfc_christ/views/screens/comm/edit_comm_screen.dart';
import 'package:cfc_christ/views/screens/comm/new_comm_screen.dart';
import 'package:cfc_christ/views/screens/echo/new_echo_screen.dart';
import 'package:cfc_christ/views/screens/teaching/new_teaching_screen.dart';
import 'package:cfc_christ/views/widgets/c_snackbar_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:go_router/go_router.dart';
import 'package:styled_text/styled_text.dart';

class UserPublicationsListScreen extends StatefulWidget {
  static const String routeName = 'user.publications';
  static const String routePath = 'publications';

  const UserPublicationsListScreen({super.key});

  @override
  State<UserPublicationsListScreen> createState() => _UserPublicationsListScreenState();
}

class _UserPublicationsListScreenState extends State<UserPublicationsListScreen> with SingleTickerProviderStateMixin {
  // DATAS ------------------------------------------------------------------------------------------------------------------>
  late TabController tabController;
  int tabIndex = 0;
  PageController pageController = PageController(initialPage: 0);

  // --> COM ----------------------------------:
  GlobalKey<RefreshIndicatorState> comRefreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  bool? comLoadingState;
  List comList = [];
  String? comProcessPlug;

  // --> TEACH --------------------------------:
  GlobalKey<RefreshIndicatorState> teachingRefreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  bool? teachLoadingState;
  List teachList = [];
  String? teachProcessPlug;

  // --> ECHO ---------------------------------:
  GlobalKey<RefreshIndicatorState> echoRefreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  bool? echoLoadingState;
  List echoList = [];
  String? echoProcessPlug;

  // INITIALIZER ------------------------------------------------------------------------------------------------------------>
  @override
  void initState() {
    super.initState();

    tabController = TabController(length: 3, initialIndex: 0, vsync: this);

    init();
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }

  @override
  void dispose() {
    tabController.dispose();

    super.dispose();
  }

  // VIEW ------------------------------------------------------------------------------------------------------------------->
  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: DefaultTabController(
        initialIndex: 0,
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Mes publications'),
            bottom: TabBar(
              controller: tabController,
              dividerHeight: 0.0,
              tabs: const [
                Tab(text: "Echos"),
                Tab(text: "Communiqués"),
                Tab(text: "Enseignements"),
              ],
              onTap: (index) {
                pageController.animateToPage(index, duration: 900.ms, curve: Curves.ease);
              },
            ),
          ),

          // --> BODY
          body: PageView(
            controller: pageController,
            onPageChanged: (index) => tabController.animateTo(index, duration: 900.ms, curve: Curves.ease),
            children: [
              // --> Echo :
              RefreshIndicator(
                key: echoRefreshIndicatorKey,
                onRefresh: () async {
                  echoLoading();

                  await Future.delayed(3.seconds);
                },
                child: ListView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: CConstants.GOLDEN_SIZE,
                    vertical: CConstants.GOLDEN_SIZE,
                  ),
                  children: [
                    if (echoList.isEmpty && echoLoadingState == null)
                      SizedBox(
                        height: CConstants.GOLDEN_SIZE * 12,
                        child: Center(
                          child: StyledText(
                            text: "<bold>Aucun Écho en vu</bold> <br>Vous n'avez encore rien publié.",
                            tags: CStyledTextTags().tags,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )

                    // --- Loading card :
                    else if (echoLoadingState == true)
                      const CardLoading(
                        height: CConstants.GOLDEN_SIZE * 7,
                        borderRadius: BorderRadius.all(Radius.circular(CConstants.DEFAULT_RADIUS)),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: CConstants.GOLDEN_SIZE,
                            vertical: CConstants.GOLDEN_SIZE * 6,
                          ),
                          child: Center(child: Text("Chargement des communiqués")),
                        ),
                      )

                    // CEchoCardListComponent(showTypeLabel: true),
                    else
                      ...echoList.map<Widget>((element) {
                        return Card.filled(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(
                              CConstants.GOLDEN_SIZE,
                              CConstants.GOLDEN_SIZE,
                              CConstants.GOLDEN_SIZE,
                              0,
                            ),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Row(children: [
                                const Spacer(),
                                Text(CMiscClass.date(DateTime.parse(element['echo']['created_at'])).ago()),
                              ]),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: CConstants.GOLDEN_SIZE),
                                child: Text(element['echo']['title'], style: Theme.of(context).textTheme.titleMedium),
                              ),
                              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                Row(children: [
                                  const Icon(CupertinoIcons.hand_thumbsup, size: CConstants.GOLDEN_SIZE * 1.5),
                                  const SizedBox(width: CConstants.GOLDEN_SIZE / 2),
                                  Text(
                                    CMiscClass.numberAbrev((element['reactions']['likes'] as int).toDouble()),
                                    style: Theme.of(context).textTheme.labelMedium,
                                  ),
                                  const SizedBox(width: CConstants.GOLDEN_SIZE / 2),
                                  Text("J'aimes", style: Theme.of(context).textTheme.labelMedium),
                                ]),
                                Row(children: [
                                  const Icon(CupertinoIcons.eye, size: CConstants.GOLDEN_SIZE * 1.5),
                                  const SizedBox(width: CConstants.GOLDEN_SIZE / 2),
                                  Text(
                                    CMiscClass.numberAbrev((element['reactions']['views'] as int).toDouble()),
                                    style: Theme.of(context).textTheme.labelMedium,
                                  ),
                                  const SizedBox(width: CConstants.GOLDEN_SIZE / 2),
                                  Text("Vues", style: Theme.of(context).textTheme.labelMedium),
                                ]),
                                Row(children: [
                                  const Icon(CupertinoIcons.chat_bubble_text, size: CConstants.GOLDEN_SIZE * 1.5),
                                  const SizedBox(width: CConstants.GOLDEN_SIZE / 2),
                                  Text(
                                    CMiscClass.numberAbrev((element['reactions']['comments'] as int).toDouble()),
                                    style: Theme.of(context).textTheme.labelMedium,
                                  ),
                                  const SizedBox(width: CConstants.GOLDEN_SIZE / 2),
                                  Text("Commentaires", style: Theme.of(context).textTheme.labelMedium),
                                ]),
                              ]),

                              // --> ACTIONS :
                              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                TextButton.icon(
                                  onPressed: () => echoToggleShow(element['echo']['id']),
                                  icon: echoProcessPlug == 'HIDE_${element['echo']['id']}'
                                      ? const SizedBox(
                                          height: 13.5,
                                          width: 13.5,
                                          child: CircularProgressIndicator(strokeCap: StrokeCap.round))
                                      : Icon(element['echo']['deleted_at'] != null
                                          ? CupertinoIcons.eye
                                          : CupertinoIcons.eye_slash),
                                  label: Text(element['echo']['deleted_at'] != null ? 'Démasquer' : "Masquer"),
                                ),
                                TextButton.icon(
                                  style: const ButtonStyle(foregroundColor: WidgetStatePropertyAll(Colors.red)),
                                  onPressed: () => echoLazyRemove(element['echo']['id']),
                                  icon: echoProcessPlug == 'REMOVE_${element['echo']['id']}'
                                      ? const SizedBox(
                                          height: 13.5,
                                          width: 13.5,
                                          child: CircularProgressIndicator(strokeCap: StrokeCap.round))
                                      : const Icon(CupertinoIcons.trash),
                                  label: const Text("Supp."),
                                ),
                                TextButton.icon(
                                  onPressed: () => echoOpen(element['echo']['id']),
                                  icon: const Icon(CupertinoIcons.pencil_ellipsis_rectangle),
                                  label: const Text("Mod."),
                                ),
                              ]),
                            ]),
                          ),
                        ).animate(effects: CTransitionsTheme.model_1);
                      }),

                    // Bottom space :
                    const SizedBox(height: CConstants.GOLDEN_SIZE * 12),
                  ],
                ),
              ),

              // --> Comminquer
              RefreshIndicator(
                key: comRefreshIndicatorKey,
                onRefresh: () async {
                  comLoading();
                  await Future.delayed(3.seconds);
                },
                child: ListView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: CConstants.GOLDEN_SIZE / 2,
                    vertical: CConstants.GOLDEN_SIZE,
                  ),
                  children: [
                    if (comLoadingState == null && comList.isEmpty)
                      SizedBox(
                        height: CConstants.GOLDEN_SIZE * 12,
                        child: Center(
                          child: StyledText(
                            text: "<bold>Aucun Communiqué en vu</bold> <br>Vous n'avez encore rien publié.",
                            tags: CStyledTextTags().tags,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )

                    // Loading
                    else if (comLoadingState == true)
                      const CardLoading(
                        height: CConstants.GOLDEN_SIZE * 7,
                        borderRadius: BorderRadius.all(Radius.circular(CConstants.DEFAULT_RADIUS)),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: CConstants.GOLDEN_SIZE,
                            vertical: CConstants.GOLDEN_SIZE * 6,
                          ),
                          child: Center(child: Text("Chargement des communiqués")),
                        ),
                      ).animate(effects: CTransitionsTheme.model_1)

                    // CComCardListComponent(showTypeLabel: true),
                    else
                      ...comList.map<Widget>((element) {
                        return Card.filled(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(
                              CConstants.GOLDEN_SIZE,
                              CConstants.GOLDEN_SIZE,
                              CConstants.GOLDEN_SIZE,
                              0,
                            ),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Row(children: [
                                Text(
                                  {
                                        'NONE': 'Non prévu',
                                        'REALIZED': 'Réalise',
                                        'INWAIT': 'Prévu',
                                      }[element['com']['status']] ??
                                      'Aucun statut définis',
                                  style: const TextStyle(color: Colors.blue),
                                ),
                                const Spacer(),
                                Text(CMiscClass.date(DateTime.parse(element['com']['created_at'])).ago()),
                              ]),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: CConstants.GOLDEN_SIZE),
                                child: Text(element['com']['title'], style: Theme.of(context).textTheme.titleMedium),
                              ),
                              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                Row(children: [
                                  const Icon(CupertinoIcons.hand_thumbsup, size: CConstants.GOLDEN_SIZE * 1.5),
                                  const SizedBox(width: CConstants.GOLDEN_SIZE / 2),
                                  Text(
                                    CMiscClass.numberAbrev((element['reactions']['likes'] as int).toDouble()),
                                    style: Theme.of(context).textTheme.labelMedium,
                                  ),
                                  const SizedBox(width: CConstants.GOLDEN_SIZE / 2),
                                  Text("J'aimes", style: Theme.of(context).textTheme.labelMedium),
                                ]),
                                Row(children: [
                                  const Icon(CupertinoIcons.eye, size: CConstants.GOLDEN_SIZE * 1.5),
                                  const SizedBox(width: CConstants.GOLDEN_SIZE / 2),
                                  Text(
                                    CMiscClass.numberAbrev((element['reactions']['views'] as int).toDouble()),
                                    style: Theme.of(context).textTheme.labelMedium,
                                  ),
                                  const SizedBox(width: CConstants.GOLDEN_SIZE / 2),
                                  Text("Vues", style: Theme.of(context).textTheme.labelMedium),
                                ]),
                                Row(children: [
                                  const Icon(CupertinoIcons.chat_bubble_text, size: CConstants.GOLDEN_SIZE * 1.5),
                                  const SizedBox(width: CConstants.GOLDEN_SIZE / 2),
                                  Text(
                                    CMiscClass.numberAbrev((element['reactions']['comments'] as int).toDouble()),
                                    style: Theme.of(context).textTheme.labelMedium,
                                  ),
                                  const SizedBox(width: CConstants.GOLDEN_SIZE / 2),
                                  Text("Commentaires", style: Theme.of(context).textTheme.labelMedium),
                                ]),
                              ]),

                              // --> ACTIONS :
                              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                TextButton.icon(
                                  onPressed: () => comToggleShow(element['com']['id']),
                                  icon: comProcessPlug == 'HIDE_${element['com']['id']}'
                                      ? const SizedBox(
                                          height: 13.5,
                                          width: 13.5,
                                          child: CircularProgressIndicator(strokeCap: StrokeCap.round))
                                      : Icon(element['com']['deleted_at'] != null
                                          ? CupertinoIcons.eye
                                          : CupertinoIcons.eye_slash),
                                  label: Text(element['com']['deleted_at'] != null ? 'Démasquer' : "Masquer"),
                                ),
                                TextButton.icon(
                                  style: const ButtonStyle(foregroundColor: WidgetStatePropertyAll(Colors.red)),
                                  onPressed: () => comLazyRemove(element['com']['id']),
                                  icon: comProcessPlug == 'REMOVE_${element['com']['id']}'
                                      ? const SizedBox(
                                          height: 13.5,
                                          width: 13.5,
                                          child: CircularProgressIndicator(strokeCap: StrokeCap.round))
                                      : const Icon(CupertinoIcons.trash),
                                  label: const Text("Supp."),
                                ),
                                TextButton.icon(
                                  onPressed: () => comOpen(element['com']['id']),
                                  icon: const Icon(CupertinoIcons.pencil_ellipsis_rectangle),
                                  label: const Text("Mod."),
                                ),
                              ]),
                            ]),
                          ),
                        ).animate(effects: CTransitionsTheme.model_1);
                      }),

                    // Bottom space :
                    const SizedBox(height: CConstants.GOLDEN_SIZE * 12),
                  ],
                ),
              ),

              // --> Teachings
              RefreshIndicator(
                key: teachingRefreshIndicatorKey,
                onRefresh: () async {
                  teachLoading();

                  await Future.delayed(3.seconds);
                },
                child: ListView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: CConstants.GOLDEN_SIZE / 2,
                    vertical: CConstants.GOLDEN_SIZE,
                  ),
                  children: [
                    if (teachLoadingState == null && teachList.isEmpty)
                      SizedBox(
                        height: CConstants.GOLDEN_SIZE * 12,
                        child: Center(
                          child: StyledText(
                            text: "<bold>Aucun Enseignement en vu</bold> <br>Vous n'avez encore rien publié.",
                            tags: CStyledTextTags().tags,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )

                    // Loading :
                    else if (echoLoadingState == true)
                      const CardLoading(
                        height: CConstants.GOLDEN_SIZE * 7,
                        borderRadius: BorderRadius.all(Radius.circular(CConstants.DEFAULT_RADIUS)),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: CConstants.GOLDEN_SIZE,
                            vertical: CConstants.GOLDEN_SIZE * 6,
                          ),
                          child: Center(child: Text("Chargement des enseignements")),
                        ),
                      )

                    // CEnseignementCardListComponent(showTypeLabel: true),
                    else
                      ...teachList.map<Widget>((element) {
                        return Card.filled(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(
                              CConstants.GOLDEN_SIZE,
                              CConstants.GOLDEN_SIZE,
                              CConstants.GOLDEN_SIZE,
                              0,
                            ),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Row(children: [
                                if (element['teaching']['date'] != null)
                                  Text('du, ${CMiscClass.date(DateTime.parse(element['teaching']['date'])).sementic()}'),
                                const Spacer(),
                                Text(CMiscClass.date(DateTime.parse(element['teaching']['created_at'])).ago()),
                              ]),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: CConstants.GOLDEN_SIZE),
                                child: Text(element['teaching']['title'], style: Theme.of(context).textTheme.titleMedium),
                              ),
                              Row(children: [
                                Expanded(
                                  child: Text(
                                    "Prédicat : ${element['teaching']['predicator']}",
                                    style: Theme.of(context).textTheme.labelSmall,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    "Versé : ${element['teaching']['verse'] ?? 'Non précisé'}",
                                    style: Theme.of(context).textTheme.labelSmall,
                                  ),
                                ),
                              ]),
                              const SizedBox(height: CConstants.GOLDEN_SIZE),
                              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                Row(children: [
                                  const Icon(CupertinoIcons.hand_thumbsup, size: CConstants.GOLDEN_SIZE * 1.5),
                                  const SizedBox(width: CConstants.GOLDEN_SIZE / 2),
                                  Text(
                                    CMiscClass.numberAbrev((element['reactions']['likes'] as int).toDouble()),
                                    style: Theme.of(context).textTheme.labelMedium,
                                  ),
                                  const SizedBox(width: CConstants.GOLDEN_SIZE / 2),
                                  Text("J'aimes", style: Theme.of(context).textTheme.labelMedium),
                                ]),
                                Row(children: [
                                  const Icon(CupertinoIcons.eye, size: CConstants.GOLDEN_SIZE * 1.5),
                                  const SizedBox(width: CConstants.GOLDEN_SIZE / 2),
                                  Text(
                                    CMiscClass.numberAbrev((element['reactions']['views'] as int).toDouble()),
                                    style: Theme.of(context).textTheme.labelMedium,
                                  ),
                                  const SizedBox(width: CConstants.GOLDEN_SIZE / 2),
                                  Text("Lectures", style: Theme.of(context).textTheme.labelMedium),
                                ]),
                                Row(children: [
                                  const Icon(CupertinoIcons.chat_bubble_text, size: CConstants.GOLDEN_SIZE * 1.5),
                                  const SizedBox(width: CConstants.GOLDEN_SIZE / 2),
                                  Text(
                                    CMiscClass.numberAbrev((element['reactions']['comments'] as int).toDouble()),
                                    style: Theme.of(context).textTheme.labelMedium,
                                  ),
                                  const SizedBox(width: CConstants.GOLDEN_SIZE / 2),
                                  Text("Commentaires", style: Theme.of(context).textTheme.labelMedium),
                                ]),
                              ]),

                              // --> ACTIONS :
                              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                TextButton.icon(
                                  onPressed: () => teachToogleShow(element['teaching']['id']),
                                  icon: teachProcessPlug == 'HIDE_${element['teaching']['id']}'
                                      ? const SizedBox(
                                          height: 13.5,
                                          width: 13.5,
                                          child: CircularProgressIndicator(strokeCap: StrokeCap.round))
                                      : Icon(element['teaching']['deleted_at'] != null
                                          ? CupertinoIcons.eye
                                          : CupertinoIcons.eye_slash),
                                  label: Text(element['teaching']['deleted_at'] != null ? 'Démasquer' : "Masquer"),
                                ),
                                TextButton.icon(
                                  style: const ButtonStyle(foregroundColor: WidgetStatePropertyAll(Colors.red)),
                                  onPressed: () => teachLazyRemove(element['teaching']['id']),
                                  icon: teachProcessPlug == 'REMOVE_${element['teaching']['id']}'
                                      ? const SizedBox(
                                          height: 13.5,
                                          width: 13.5,
                                          child: CircularProgressIndicator(strokeCap: StrokeCap.round))
                                      : const Icon(CupertinoIcons.trash),
                                  label: const Text("Supp."),
                                ),
                                TextButton.icon(
                                  onPressed: () => teachOpen(element['teaching']['id']),
                                  icon: const Icon(CupertinoIcons.pencil_ellipsis_rectangle),
                                  label: const Text("Mod."),
                                ),
                              ]),
                            ]),
                          ),
                        ).animate(effects: CTransitionsTheme.model_1);
                      }),

                    // Bottom space :
                    const SizedBox(height: CConstants.GOLDEN_SIZE * 12),
                  ],
                ),
              ),
            ],
          ),

          // --> Floating button :
          floatingActionButton: SpeedDial(
            // visible: showFloatingActionButton,
            shape: const StadiumBorder(),
            activeIcon: CupertinoIcons.xmark,
            icon: CupertinoIcons.plus,
            overlayColor: Theme.of(context).colorScheme.surfaceContainer,
            foregroundColor: CMiscClass.whenBrightnessOf(context, dark: Colors.white70),
            childMargin: const EdgeInsets.all(CConstants.GOLDEN_SIZE * 1),
            label: const Text("Publier"),
            activeLabel: const Text("Fermer"),
            children: [
              SpeedDialChild(
                label: "Publier un communiquer",
                child: const Icon(CupertinoIcons.news),
                onTap: () => context.pushNamed(NewCommScreen.routeName),
              ),
              SpeedDialChild(
                label: "Publier un écho de la CFC",
                child: const Icon(CupertinoIcons.radiowaves_right),
                onTap: () => context.pushNamed(NewEchoScreen.routeName),
              ),
              SpeedDialChild(
                label: "Publier un enseignement",
                child: const Icon(CupertinoIcons.book),
                onTap: () => context.pushNamed(NewTeachingScreen.routeName),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // METHOD ----------------------------------------------------------------------------------------------------------------->
  void init() {
    comLoading();

    teachLoading();

    echoLoading();
  }

  // --> ECOM ------------------------------------------------:
  bool _comCanProcess() {
    if (comProcessPlug != null) {
      CSnackbarWidget.direct(const Text("Un autre processus est en cours."), defaultDuration: true);
      return false;
    }

    return true;
  }

  void comLoading({bool showShimer = true}) {
    if (_comCanProcess()) {
      if (showShimer) setState(() => comLoadingState = true);

      ComMv().getListOfPublisheds((coms) {
        if (coms.isNotEmpty) {
          setState(() {
            comLoadingState = false;
            comList = coms;
          });
        } else {
          setState(() {
            comList = [];
            comLoadingState = null;
          });
        }
      }, (e) => setState(() => comLoadingState = null));
    }
  }

  void comToggleShow(String id) {
    if (_comCanProcess()) {
      setState(() => comProcessPlug = "HIDE_$id");

      ComMv().toggleHide(id).then(
            (value) => setState(() {
              comProcessPlug = null;

              if (value['state'] == 'HIDDEN') {
                CSnackbarWidget.direct(
                    const Text("Le communiqué est caché (masqué), donc rendu invisible à tout les mondes."));
              } else if (value['state'] == 'VISIBLE') {
                CSnackbarWidget.direct(const Text("Le communiqué est démasqué, donc rendu visible à tout les mondes."));
              }

              comLoading(showShimer: false);
            }),
            onError: (e) => setState(() => comProcessPlug = null),
          );
    }
  }

  void comRemove(String id) {
    if (_comCanProcess()) {
      setState(() => comProcessPlug = "REMOVE_$id");

      ComMv().remove(id).then(
            (value) => setState(() {
              comProcessPlug = null;

              comLoading(showShimer: false);
            }),
            onError: (e) => setState(() => comProcessPlug = null),
          );
    }
  }

  void comLazyRemove(String id) {
    Timer timer = Timer(5.seconds, () => comRemove(id));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Suppression du communiqué"),
        duration: 5.seconds,
        // backgroundColor: Colors.red,
        action: SnackBarAction(label: "Annuler", onPressed: () => timer.cancel()),
      ),
    );
  }

  void comOpen(String id) {
    setState(() => comProcessPlug = null);

    context.pushNamed(EditCommScreen.routeName, extra: {'com_id': id});
  }

  // --> TEACH -----------------------------------------------:
  bool _teachCanProcess() {
    if (teachProcessPlug != null) {
      CSnackbarWidget.direct(const Text("Un autre processus est en cours."), defaultDuration: true);
      return false;
    }

    return true;
  }

  void teachLoading({bool showShimer = true}) {
    if (_teachCanProcess()) {
      if (showShimer) setState(() => teachLoadingState = true);

      TeachingMv().getListOfPublisheds((teachings) {
        if (teachings.isNotEmpty) {
          setState(() {
            teachLoadingState = false;
            teachList = teachings;
          });
        } else {
          setState(() {
            teachList = [];
            teachLoadingState = null;
          });
        }
      }, (e) => setState(() => teachLoadingState = null));
    }
  }

  void teachToogleShow(String id) {
    if (_teachCanProcess()) {
      setState(() => teachProcessPlug = "HIDE_$id");

      TeachingMv().toggleHide(id).then(
            (value) => setState(() {
              teachProcessPlug = null;

              if (value['state'] == 'HIDDEN') {
                CSnackbarWidget.direct(
                    const Text("Cet enseignement est caché (masqué), donc rendu invisible à tout les mondes."));
              } else if (value['state'] == 'VISIBLE') {
                CSnackbarWidget.direct(const Text("L'enseignement est démasqué, donc rendu visible à tout les mondes."));
              }

              teachLoading(showShimer: false);
            }),
            onError: (e) => setState(() => teachProcessPlug = null),
          );
    }
  }

  void teachRemove(String id) {
    if (_teachCanProcess()) {
      setState(() => teachProcessPlug = "REMOVE_$id");

      TeachingMv().remove(id).then(
            (value) => setState(() {
              teachProcessPlug = null;

              teachLoading(showShimer: false);
            }),
            onError: (e) => setState(() => teachProcessPlug = null),
          );
    }
  }

  void teachLazyRemove(String id) {
    Timer timer = Timer(5.seconds, () => teachRemove(id));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Suppression du communiqué"),
        duration: 5.seconds,
        action: SnackBarAction(label: "Annuler", onPressed: () => timer.cancel()),
      ),
    );
  }

  void teachOpen(String id) {
    setState(() => teachLoadingState = null);
  }

  // --> ECHO ------------------------------------------------:
  bool _echoCanProcess() {
    if (echoProcessPlug != null) {
      CSnackbarWidget.direct(const Text("Un autre processus est en cours."), defaultDuration: true);
      return false;
    }

    return true;
  }

  void echoLoading({bool showShimer = true}) {
    if (_echoCanProcess()) {
      if (showShimer) setState(() => echoLoadingState = true);

      EchoMv().getListOfPublisheds((echos) {
        if (echos.isNotEmpty) {
          setState(() {
            echoLoadingState = false;
            echoList = echos;
          });
        } else {
          setState(() {
            echoList = [];
            echoLoadingState = null;
          });
        }
      }, (e) => setState(() => echoLoadingState = null));
    }
  }

  void echoToggleShow(String id) {
    if (_echoCanProcess()) {
      setState(() => echoProcessPlug = "HIDE_$id");

      EchoMv().toggleHide(id).then(
            (value) => setState(() {
              echoProcessPlug = null;

              if (value['state'] == 'HIDDEN') {
                CSnackbarWidget.direct(const Text("Le écho est caché (masqué), donc rendu invisible à tout les mondes."));
              } else if (value['state'] == 'VISIBLE') {
                CSnackbarWidget.direct(const Text("Le écho est démasqué, donc rendu visible à tout les mondes."));
              }

              echoLoading(showShimer: false);
            }),
            onError: (e) => setState(() => echoProcessPlug = null),
          );
    }
  }

  void echoRemove(String id) {
    if (_echoCanProcess()) {
      setState(() => echoProcessPlug = "REMOVE_$id");

      EchoMv().remove(id).then(
            (value) => setState(() {
              echoProcessPlug = null;

              echoLoading(showShimer: false);
            }),
            onError: (e) => setState(() => echoProcessPlug = null),
          );
    }
  }

  void echoLazyRemove(String id) {
    Timer timer = Timer(5.seconds, () => echoRemove(id));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Suppression du communiqué"),
        duration: 5.seconds,
        action: SnackBarAction(label: "Annuler", onPressed: () => timer.cancel()),
      ),
    );
  }

  void echoOpen(String id) {
    setState(() => echoProcessPlug = null);
  }
}
