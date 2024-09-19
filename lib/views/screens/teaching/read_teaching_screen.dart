import 'package:cached_network_image/cached_network_image.dart';
import 'package:cfc_christ/classes/c_image_handler_class.dart';
import 'package:cfc_christ/classes/c_misc_class.dart';
import 'package:cfc_christ/classes/c_sections_types_enum.dart';
import 'package:cfc_christ/configs/c_api.dart';
import 'package:cfc_christ/configs/c_constants.dart';
import 'package:cfc_christ/configs/c_styled_text_tags.dart';
import 'package:cfc_christ/model_view/pcn_data_handler_mv.dart';
import 'package:cfc_christ/services/c_s_tts.dart';
import 'package:cfc_christ/theme/c_transition_thme.dart';
import 'package:cfc_christ/views/components/c_comments_view_handler_component.dart';
import 'package:cfc_christ/views/components/c_images_grid_group_view_component.dart';
import 'package:cfc_christ/views/layouts/default_layout.dart';
import 'package:cfc_christ/views/screens/user/user_profile_details_screen.dart';
import 'package:cfc_christ/views/widgets/c_audio_reader_widget.dart';
import 'package:cfc_christ/views/widgets/c_tts_reader_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:styled_text/styled_text.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

class ReadTeachingScreen extends StatefulWidget {
  static const String routeName = 'teaching.read';
  static const String routePath = 'read';

  const ReadTeachingScreen({super.key, this.teachId});

  final String? teachId;

  @override
  State<ReadTeachingScreen> createState() => _ReadTeachingScreenState();
}

class _ReadTeachingScreenState extends State<ReadTeachingScreen> {
  Map teachData = {};
  Map reactionsData = {};
  Map posterData = {};

  bool isInLoadingReactions = false;
  bool isInLoading = false;
  bool isInMainLoading = true;

  String teachLevel = '';

  // DATA ------------------------------------------------------------------------------------------------------------------->

  // INITIALIZER ------------------------------------------------------------------------------------------------------------>
  @override
  void initState() {
    super.initState();

    if (widget.teachId == null) {
      context.pop();
    } else {
      load();
      loadReactions();
      putAReadReaction();
    }
  }

  @override
  void dispose() {
    CSTts.inst.dispose();
    super.dispose();
  }

  // VIEW ------------------------------------------------------------------------------------------------------------------->
  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: Scaffold(
        /*appBar: AppBar(title: const Text('Enseignement'), actions: [
          IconButton(onPressed: () {}, icon: const Icon(CupertinoIcons.heart)),
        ]),*/

        // --- Body :
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: const Text("Enseignement"),
              pinned: false,
              snap: false,
              floating: true,
              actions: [
                IconButton(
                    onPressed: isInMainLoading || isInLoading ? null : toggleFaveState,
                    icon: const Icon(CupertinoIcons.heart)),
              ],
            ),

            // --- BODY :
            SliverList.list(children: [
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
                      const Icon(CupertinoIcons.book),
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
                              "ENSEIGNEMENT",
                              style: Theme.of(context).textTheme.labelMedium?.copyWith(color: CConstants.LIGHT_COLOR),
                            ),
                          ),
                          Text(teachLevel, style: Theme.of(context).textTheme.labelMedium),
                        ]),
                      ),
                    ]),

                    // --- Heading image :
                    const SizedBox(height: CConstants.GOLDEN_SIZE * 1),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: CConstants.GOLDEN_SIZE),
                      child: Animate(
                        effects: [FadeEffect(duration: 1.seconds)],
                        child: CImagesGridGroupViewComponent(pictures: [teachData['picture'] ?? '---']),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: CConstants.GOLDEN_SIZE),
                      child: Row(
                        children: [
                          Expanded(
                            child: SelectableText(
                              teachData['title'] ?? '...',
                              style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),

                          // TTS reader :
                          CTtsReaderWidget.icon(text: () => teachData['text'] ?? '')
                        ],
                      ),
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Row(children: [
                        const Icon(CupertinoIcons.clock, size: CConstants.GOLDEN_SIZE * 1.5),
                        const SizedBox(width: CConstants.GOLDEN_SIZE / 2),
                        if (teachData['created_at'] != null)
                          Text(
                            CMiscClass.date(DateTime.parse(teachData['created_at'])).ago(),
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

                    // --- Infos:
                    const SizedBox(height: CConstants.GOLDEN_SIZE * 1),
                    Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Expanded(
                        child: Card(
                            child: Padding(
                          padding: const EdgeInsets.all(CConstants.GOLDEN_SIZE),
                          child:
                              Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                            Row(children: [
                              const Icon(CupertinoIcons.person_crop_circle, size: CConstants.GOLDEN_SIZE * 1.5),
                              const SizedBox(width: CConstants.GOLDEN_SIZE),
                              Text("Prédicateur", style: Theme.of(context).textTheme.labelSmall),
                            ]),
                            const SizedBox(height: CConstants.GOLDEN_SIZE / 2),
                            if (teachData['predicator'] != null)
                              StyledText(
                                text: "<bold>${teachData['predicator'] ?? '---'}</bold>",
                                tags: CStyledTextTags().tags,
                              ),
                          ]),
                        )),
                      ),
                      Expanded(
                        child: Card(
                            child: Padding(
                          padding: const EdgeInsets.all(CConstants.GOLDEN_SIZE),
                          child:
                              Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                            Row(children: [
                              const Icon(CupertinoIcons.book_fill, size: CConstants.GOLDEN_SIZE * 1.5),
                              const SizedBox(width: CConstants.GOLDEN_SIZE),
                              Text("Enseignement", style: Theme.of(context).textTheme.labelSmall),
                            ]),
                            const SizedBox(height: CConstants.GOLDEN_SIZE / 2),
                            if (teachData['date'] != null)
                              Text("Du ${CMiscClass.date(DateTime.parse(teachData['date'])).sementic()}"),
                            if (teachData['verse'] != null)
                              StyledText(text: "Versé : <bold>${teachData['verse']}</bold>", tags: CStyledTextTags().tags),
                          ]),
                        )),
                      ),
                    ]),

                    const SizedBox(height: CConstants.GOLDEN_SIZE * 1),
                    SelectableText(
                      teachData['text'] ?? '...',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontFamily: CConstants.FONT_FAMILY_PRIMARY,
                            fontWeight: FontWeight.normal,
                          ),
                    ),

                    // --- Download document -->
                    const SizedBox(height: CConstants.GOLDEN_SIZE),
                    Visibility(
                      visible: teachData['document'] != null,
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

                    // --- AUDIO :
                    const SizedBox(height: CConstants.GOLDEN_SIZE * 2),
                    if (teachData['audio'] != null) CAudioReaderWidget(audioSource: teachData['audio'] ?? '---'),

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
                    CCommentsViewHandlerComponent(section: CSectionsTypesEnum.teaching, id: widget.teachId ?? '---'),

                    // -- Free space.
                    const SizedBox(height: CConstants.GOLDEN_SIZE * 3),
                  ]),
                ).animate(effects: CTransitionsTheme.model_1);
              })
            ]),
          ],
        ),
      ),
    );
  }

  // METHODS ---------------------------------------------------------------------------------------------------------------->
  load() {
    setState(() => isInLoading = true);

    Map data = {'teachId': widget.teachId};

    CApi.request.get('/teaching/quest/get.m4tUR9UtiKrfOrwBIc9LuQ4XPU9', data: data).then(
      (res) {
        setState(() => isInLoading = false);

        if (res.data is Map && res.data['success']) {
          setState(() {
            teachData = res.data['teach'];
            posterData = res.data['poster'];
            teachLevel = _managePCN(teachData['visibility'] ?? {});
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

    CApi.request.get('/teaching/quest/reactions.yfZBOElWFt8n7GuAX4RzK6KyYDY', data: {'teachId': widget.teachId}).then(
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
    CApi.request.post('/teaching/quest/add.view.qAyA28hWGlZw5QxFYJr1XdMef8V', data: {'teachId': widget.teachId});
  }

  likeThis() {
    setState(() => isInLoadingReactions = true);

    CApi.request
        .post('/teaching/quest/like.reaction.Sm1Sp7H9HoCmRRJNZJwnL8t5udq', data: {'teachId': widget.teachId}).then((res) {
      setState(() => isInLoadingReactions = false);

      if (res.data is Map && res.data['success']) loadReactions();
    }).catchError(
      (err) {
        setState(() => isInLoadingReactions = false);
      },
    );
  }

  loadFavState() {}

  toggleFaveState() {}

  openUserProfile(String userId) {
    context.pushNamed(UserProfileDetailsScreen.routeName, extra: {'user_id': userId});
  }
}
