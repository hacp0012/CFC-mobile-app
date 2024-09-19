import 'package:cached_network_image/cached_network_image.dart';
import 'package:cfc_christ/classes/c_image_handler_class.dart';
import 'package:cfc_christ/classes/c_misc_class.dart';
import 'package:cfc_christ/classes/c_sections_types_enum.dart';
import 'package:cfc_christ/configs/c_api.dart';
import 'package:cfc_christ/configs/c_constants.dart';
import 'package:cfc_christ/model_view/pcn_data_handler_mv.dart';
import 'package:cfc_christ/theme/c_transition_thme.dart';
import 'package:cfc_christ/views/components/c_comments_view_handler_component.dart';
import 'package:cfc_christ/views/components/c_images_grid_group_view_component.dart';
import 'package:cfc_christ/views/layouts/default_layout.dart';
import 'package:cfc_christ/views/screens/user/user_profile_details_screen.dart';
import 'package:cfc_christ/views/widgets/c_tts_reader_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

class ReadCommScreen extends StatefulWidget {
  static const String routeName = 'comm.read';
  static const String routePath = 'read';

  const ReadCommScreen({super.key, this.comId});

  final String? comId;

  @override
  State<ReadCommScreen> createState() => _ReadCommScreenState();
}

class _ReadCommScreenState extends State<ReadCommScreen> {
  // DATAS -->--------------------------------------------------------------------------------------------------------------->
  String? demoAudioFile;

  Map comData = {};
  Map reactionsData = {};
  List picturesList = [null];

  bool isInLoadingReactions = false;
  bool isInLoading = false;
  bool isInMainLoading = true;

  Map echoData = {};
  Map posterData = {};

  String comLevel = '';

  // INITIALIZER -->--------------------------------------------------------------------------------------------------------->
  @override
  void initState() {
    super.initState();

    if (widget.comId == null) {
      context.pop();
    } else {
      load();
      loadReactions();
      putAReadReaction();
    }
  }

  // VIEW -->---------------------------------------------------------------------------------------------------------------->
  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: Scaffold(
        // appBar: AppBar(title: const Text('Communiquer'), actions: [
        //   IconButton(onPressed: () {}, icon: const Icon(CupertinoIcons.heart)),
        // ]),

        // --- Body :
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: false,
              floating: true,
              snap: false,
              title: const Text('Communiquer'),
              actions: [IconButton(onPressed: isInLoading ? null : toggleFaveState, icon: const Icon(CupertinoIcons.heart))],
            ),

            // --- BODY :
            SliverList(
              delegate: SliverChildListDelegate([
                Builder(builder: (context) {
                  if (isInMainLoading) {
                    return Padding(
                      padding: const EdgeInsets.all(CConstants.GOLDEN_SIZE),
                      child: Shimmer.fromColors(
                        baseColor: Theme.of(context).colorScheme.surface,
                        highlightColor: Theme.of(context).colorScheme.surfaceContainer,
                        child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Card(child: SizedBox(height: 9.0 * 3, width: double.infinity)),
                          SizedBox(height: 9.0),
                          Card(child: SizedBox(height: 9.0 * 14, width: double.infinity)),
                          SizedBox(height: 9.0),
                          Card(child: SizedBox(height: 9.0 * 3, width: double.infinity)),
                          SizedBox(height: 9.0),
                          Row(
                            children: [
                              Expanded(child: Card(child: SizedBox(height: 9.0 * 5, width: double.infinity))),
                              SizedBox(width: 9.0),
                              Expanded(child: Card(child: SizedBox(height: 9.0 * 5, width: double.infinity))),
                            ],
                          ),
                          SizedBox(height: 9.0 * 2),
                          Card(child: SizedBox(height: 9.0 * 3, width: 9.0 * 18)),
                          SizedBox(height: 9.0 / 2),
                          Card(child: SizedBox(height: 9.0 * 3, width: 9.0 * 36)),
                          SizedBox(height: 9.0 / 2),
                          Card(child: SizedBox(height: 9.0 * 3, width: 9.0 * 27)),
                          SizedBox(height: 9.0 / 2),
                          Card(child: SizedBox(height: 9.0 * 3, width: 9.0 * 18)),
                          SizedBox(height: 9.0 / 2),
                          Card(child: SizedBox(height: 9.0 * 3, width: 9.0 * 18)),
                          SizedBox(height: 9.0 / 2),
                          Card(child: SizedBox(height: 9.0 * 3, width: 9.0 * 30)),
                          SizedBox(height: 9.0 / 2),
                          Card(child: SizedBox(height: 9.0 * 3, width: 9.0 * 27)),
                          SizedBox(height: 9.0 / 2),
                          Card(child: SizedBox(height: 9.0 * 3, width: 9.0 * 36)),
                          SizedBox(height: 9.0),
                        ]),
                      ),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: CConstants.GOLDEN_SIZE),
                    child: Column(children: [
                      const SizedBox(height: CConstants.GOLDEN_SIZE),
                      Row(children: [
                        const Icon(CupertinoIcons.news),
                        const SizedBox(width: CConstants.GOLDEN_SIZE),
                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(CConstants.DEFAULT_RADIUS),
                              ),
                              child: Text(
                                "COMMUNIQUER",
                                style: Theme.of(context).textTheme.labelMedium?.copyWith(color: CConstants.LIGHT_COLOR),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                              decoration: BoxDecoration(
                                // color: Colors.grey.shade400,
                                borderRadius: BorderRadius.circular(CConstants.DEFAULT_RADIUS),
                              ),
                              child: Text(
                                comLevel,
                                style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.black),
                              ),
                            ),
                          ]),
                        ),
                        const SizedBox(width: CConstants.GOLDEN_SIZE),
                        if (comData['status'] != 'NONE')
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                            decoration: BoxDecoration(
                              color: Colors.green.shade400,
                              borderRadius: BorderRadius.circular(CConstants.DEFAULT_RADIUS),
                            ),
                            child: Text(
                              comData['status'] == '' ? "Prévu" : 'Réalisé',
                              style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.black),
                            ),
                          ),
                      ]),

                      // --- PICTURES -->
                      const SizedBox(height: CConstants.GOLDEN_SIZE),
                      Visibility(
                        visible: comData['picture'] != null,
                        child: CImagesGridGroupViewComponent(pictures: [comData['picture']]),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: CConstants.GOLDEN_SIZE),
                        child: Row(
                          children: [
                            Expanded(
                              child: SelectableText(
                                comData['title'] ?? '...',
                                style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),

                            // TTS reader :
                            CTtsReaderWidget.icon(text: () => comData['text'] ?? '')
                          ],
                        ),
                      ),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Row(children: [
                          const Icon(CupertinoIcons.clock, size: CConstants.GOLDEN_SIZE * 1.5),
                          const SizedBox(width: CConstants.GOLDEN_SIZE / 2),
                          if (comData['created_at'] != null)
                            Text(
                              CMiscClass.date(DateTime.parse(comData['created_at'])).ago(),
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                        ]),
                        // const SizedBox(width: CConstants.GOLDEN_SIZE),
                        Row(children: [
                          const Icon(CupertinoIcons.eye, size: CConstants.GOLDEN_SIZE * 1.5),
                          const SizedBox(width: CConstants.GOLDEN_SIZE / 2),
                          Text(
                            "${CMiscClass.numberAbrev(((reactionsData['views']?['count'] ?? 0) as int).toDouble())} vus",
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ]),
                        // const SizedBox(width: CConstants.GOLDEN_SIZE),
                        Row(children: [
                          const Icon(CupertinoIcons.hand_thumbsup, size: CConstants.GOLDEN_SIZE * 1.5),
                          const SizedBox(width: CConstants.GOLDEN_SIZE / 2),
                          Text(
                            "${CMiscClass.numberAbrev(((reactionsData['likes']?['count'] ?? 0) as int).toDouble())} "
                            "j'aimes",
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ]),
                        // const SizedBox(width: CConstants.GOLDEN_SIZE),
                        Row(children: [
                          const Icon(CupertinoIcons.chat_bubble_2, size: CConstants.GOLDEN_SIZE * 1.5),
                          const SizedBox(width: CConstants.GOLDEN_SIZE / 2),
                          Text(
                            "${CMiscClass.numberAbrev(((reactionsData['comments']?['count'] ?? 0) as int).toDouble())} "
                            "Commantaires",
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ]),
                      ]),
                      // const Divider(),

                      // --- TEXT BODY :
                      const SizedBox(height: CConstants.GOLDEN_SIZE * 1),
                      SelectableText(
                        comData['text'] ?? '...',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),

                      // --- Download document -->
                      const SizedBox(height: CConstants.GOLDEN_SIZE),
                      Visibility(
                        visible: comData['document'] == null,
                        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                          Expanded(
                            child: TextButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.download, size: CConstants.GOLDEN_SIZE * 2),
                              label: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Télécharger le document associé"),
                                    Text("document.ext", style: Theme.of(context).textTheme.labelSmall),
                                  ]),
                              style: const ButtonStyle(visualDensity: VisualDensity.compact, alignment: Alignment.centerLeft),
                            ),
                          ),
                        ]),
                      ),

                      // --- POSTER :
                      const SizedBox(height: CConstants.GOLDEN_SIZE * 3),
                      Row(children: [
                        GestureAnimator(
                          child: CircleAvatar(
                            backgroundImage: CachedNetworkImageProvider(CImageHandlerClass.userById(posterData['id'])),
                          ),
                          onTap: () => openUserProfile(posterData['id'] ?? '---'),
                        ),
                        const SizedBox(width: CConstants.GOLDEN_SIZE),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Publié par ${(posterData['civility'] ?? 'F') == 'F' ? 'le frère' : 'la soeur'}",
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            Text(
                              posterData['fullname'] ?? '---',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ]),

                      // --- ACTION BUTTONS :
                      const SizedBox(height: CConstants.GOLDEN_SIZE * 3),
                      Card.filled(
                        child: Row(children: [
                          Expanded(
                            child: Column(mainAxisSize: MainAxisSize.min, children: [
                              if ((reactionsData['likes']?['count'] ?? 0) == 1)
                                const Text("Une personnee aime cet écho")
                              else
                                Text("${(reactionsData['likes']?['count'] ?? 0)} personnes aiment cet écho"),
                              TextButton.icon(
                                onPressed: isInLoadingReactions ? null : likeThis,
                                icon: Icon(
                                  (reactionsData['likes']?['user'] ?? false)
                                      ? CupertinoIcons.hand_thumbsdown
                                      : CupertinoIcons.hand_thumbsup,
                                  size: CConstants.GOLDEN_SIZE * 2,
                                ),
                                label: (reactionsData['likes']?['user'] ?? false)
                                    ? const Text("Je n'aime pas")
                                    : const Text("J'aime aussi"),
                                style: const ButtonStyle(visualDensity: VisualDensity.compact),
                              ),
                            ]),
                          ),
                          TextButton(
                              onPressed: toggleFaveState,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(CupertinoIcons.heart, size: CConstants.GOLDEN_SIZE * 2),
                                  Text("L'enregistrer", style: Theme.of(context).textTheme.labelSmall),
                                ],
                              ))
                        ]),
                      ),

                      // --- COMMENTS :
                      const SizedBox(height: CConstants.GOLDEN_SIZE * 3),
                      Text("Laisser un commentaire", style: Theme.of(context).textTheme.titleMedium),
                      CCommentsViewHandlerComponent(section: CSectionsTypesEnum.com, id: widget.comId ?? '---'),

                      // Free space.
                      const SizedBox(height: CConstants.GOLDEN_SIZE * 3),
                    ]),
                  ).animate(effects: CTransitionsTheme.model_1);
                })
              ]),
            )
          ],
        ),
      ),
    );
  }

  // METHOS -->-------------------------------------------------------------------------------------------------------------->
  load() {
    setState(() => isInLoading = true);

    Map data = {'comId': widget.comId};

    CApi.request.get('/com/quest/get.3MbecKe6Vd0CvcvDqu6n37Du74O', data: data).then(
      (res) {
        setState(() => isInLoading = false);

        if (res.data is Map && res.data['success']) {
          setState(() {
            comData = res.data['com'];
            posterData = res.data['poster'];
            comLevel = _managePCN(comData['visibility'] ?? {});
            isInMainLoading = false;
          });
        } else {
          _back();
        }
      },
      onError: (err) {
        setState(() => isInLoading = false);
      },
    );
  }

  String _managePCN(Map? visibility) {
    Map? data = {};

    switch (visibility?['level']) {
      case 'pool':
        data = PcnDataHandlerMv.getPool(visibility?['level_id']);
        break;
      case 'com_loc':
        data = PcnDataHandlerMv.getCom(visibility?['level_id']);
        break;
      case 'noyau_af':
        data = PcnDataHandlerMv.getNa(visibility?['level_id']);
        break;
    }

    if (data != null) return "Pool de ${data['nom']}";

    return "PCN inconu";
  }

  void _back() => context.pop();

  loadReactions() {
    setState(() => isInLoadingReactions = true);

    CApi.request.get('/com/quest/reactions.wgg3p0XpKDzkMiO9xOGjuG4bqim', data: {'comId': widget.comId}).then(
      (res) {
        setState(() {
          isInLoadingReactions = false;

          if (res.data is Map) reactionsData = res.data;
        });
      },
      onError: (err) => setState(() => isInLoadingReactions = false),
    );
  }

  putAReadReaction() {
    CApi.request.post('/com/quest/add.view.AXS3Szzd7P3WCgMMkBICFohEI4R', data: {'comId': widget.comId});
  }

  likeThis() {
    setState(() => isInLoadingReactions = true);

    CApi.request.post('/com/quest/like.reaction.sfCUO1AFChRWhGhkwZxcR5wOm9l', data: {'comId': widget.comId}).then((res) {
      setState(() => isInLoadingReactions = false);

      if (res.data is Map && res.data['success']) loadReactions();
    }).catchError((err) {
      setState(() => isInLoadingReactions = false);
    });
  }

  loadFavState() {}

  toggleFaveState() {}

  openUserProfile(String userId) {
    context.pushNamed(UserProfileDetailsScreen.routeName, extra: {'user_id': userId});
  }
}
