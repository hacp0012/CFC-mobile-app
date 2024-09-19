import 'package:cached_network_image/cached_network_image.dart';
import 'package:cfc_christ/classes/c_document_handler_class.dart';
import 'package:cfc_christ/classes/c_image_handler_class.dart';
import 'package:cfc_christ/classes/c_misc_class.dart';
import 'package:cfc_christ/classes/c_sections_types_enum.dart';
import 'package:cfc_christ/configs/c_api.dart';
import 'package:cfc_christ/configs/c_constants.dart';
import 'package:cfc_christ/configs/c_styled_text_tags.dart';
import 'package:cfc_christ/model_view/pcn_data_handler_mv.dart';
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
import 'package:styled_text/widgets/styled_text.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

class ReadEchoScreen extends StatefulWidget {
  static const String routeName = 'echo.read';
  static const String routePath = 'read';

  const ReadEchoScreen({super.key, required this.echoId});

  final String? echoId;

  @override
  State<ReadEchoScreen> createState() => _ReadEchoScreenState();
}

class _ReadEchoScreenState extends State<ReadEchoScreen> {
  // DATA -->-----------------------------------------------------------------------------------------------------------------
  Map echoData = {};
  Map reactionsData = {};
  Map posterData = {};
  List picturesList = [];
  Map? poolData;
  String posterPool = '';

  bool isInLoading = true;
  bool isInLoadingReactions = true;
  bool isInMainLoading = true;

  bool favState = false;

  // INITIALIZER -->----------------------------------------------------------------------------------------------------------
  @override
  void initState() {
    super.initState();

    if (widget.echoId == null) {
      context.pop();
    } else {
      load();
      loadReactions();
      putAReadReaction();
    }
  }

  // VIEW -->-----------------------------------------------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: Scaffold(
        body: CustomScrollView(slivers: [
          SliverAppBar(
            pinned: false,
            snap: false,
            floating: true,
            title: const Row(
              children: [
                Icon(CupertinoIcons.radiowaves_right),
                SizedBox(width: CConstants.GOLDEN_SIZE),
                Text('Echo'),
              ],
            ),
            actions: [
              IconButton(
                onPressed: isInLoading || isInMainLoading ? null : toggleFaveState,
                icon: const Icon(CupertinoIcons.heart),
              ),
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
                  // --- BODY -->
                  const SizedBox(height: CConstants.GOLDEN_SIZE),
                  Row(children: [
                    Padding(
                      padding: const EdgeInsets.only(right: CConstants.GOLDEN_SIZE),
                      child: GestureAnimator(
                        child: CircleAvatar(
                          radius: CConstants.GOLDEN_SIZE * 2.5,
                          backgroundImage: CachedNetworkImageProvider(CImageHandlerClass.userById(posterData['id'])),
                        ),
                        onTap: () =>
                            context.pushNamed(UserProfileDetailsScreen.routeName, extra: {'user_id': posterData['id']}),
                      ),
                    ),
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(posterData['fullname'] ?? '---', style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                        posterPool,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ]),
                  ]),

                  // --- PICTURES -->
                  const SizedBox(height: CConstants.GOLDEN_SIZE),
                  Visibility(visible: picturesList.isNotEmpty, child: CImagesGridGroupViewComponent(pictures: picturesList)),

                  // --- Title -->
                  const SizedBox(height: CConstants.GOLDEN_SIZE),
                  Row(children: [
                    Expanded(child: Text(echoData['title'] ?? '--', style: Theme.of(context).textTheme.titleMedium)),
                    // TTS reader :
                    CTtsReaderWidget.icon(text: () => echoData['text']),
                  ]),

                  Row(children: [
                    if (echoData['created_at'] != null)
                      Text(
                        "Publié ${CMiscClass.date(DateTime.parse(echoData['created_at'])).ago()}",
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    const SizedBox(width: CConstants.GOLDEN_SIZE * 1),
                    Row(children: [
                      const Icon(CupertinoIcons.hand_thumbsup_fill, size: CConstants.GOLDEN_SIZE * 1.5),
                      const SizedBox(width: CConstants.GOLDEN_SIZE / 2),
                      Text(
                        "${CMiscClass.numberAbrev(((reactionsData['likes']?['count'] ?? 0) as int).toDouble())}"
                        "${(reactionsData['likes']?['user'] ?? false) ? " et vous" : ''}",
                        style: Theme.of(context).textTheme.labelSmall,
                      )
                    ]),
                    const SizedBox(width: CConstants.GOLDEN_SIZE * 2),
                    Row(children: [
                      const Icon(CupertinoIcons.eye, size: CConstants.GOLDEN_SIZE * 1.5),
                      const SizedBox(width: CConstants.GOLDEN_SIZE / 2),
                      Text(
                        CMiscClass.numberAbrev(((reactionsData['views']?['count'] ?? 0) as int).toDouble()),
                        style: Theme.of(context).textTheme.labelSmall,
                      )
                    ]),
                    const Spacer(),
                    Text(
                      "${CMiscClass.numberAbrev(((reactionsData['comments']?['count'] ?? 0) as int).toDouble())} Commentaires",
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ]),

                  // --- SMALL DESCRIPTIONS -->
                  const SizedBox(height: CConstants.GOLDEN_SIZE * 2),
                  StyledText(
                    text: echoData['text'],
                    tags: CStyledTextTags().tags,
                  ),

                  // --- Download document -->
                  const SizedBox(height: CConstants.GOLDEN_SIZE),
                  Visibility(
                    visible: echoData['document'] != null,
                    child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      Expanded(
                        child: TextButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.download, size: CConstants.GOLDEN_SIZE * 2),
                          label:
                              Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                            const Text("Télécharger le document associé"),
                            Text("document.ext", style: Theme.of(context).textTheme.labelSmall),
                          ]),
                          style: const ButtonStyle(visualDensity: VisualDensity.compact, alignment: Alignment.centerLeft),
                        ),
                      ),
                    ]),
                  ),

                  // --- AUDIO :
                  // const SizedBox(height: CConstants.GOLDEN_SIZE * 3),
                  const SizedBox(height: CConstants.GOLDEN_SIZE),
                  if (echoData['audio'] != null)
                    CAudioReaderWidget(audioSource: CDocumentHandlerClass.byPid(echoData['audio'])),

                  // --- LIKES AND COMMENT TEXT -->
                  /*const SizedBox(height: CConstants.GOLDEN_SIZE),
                            Padding(
                padding: const EdgeInsets.all(CConstants.GOLDEN_SIZE),
                child: Row(children: [
                  Row(children: [
                    const Icon(CupertinoIcons.hand_thumbsup_fill, size: CConstants.GOLDEN_SIZE * 1.5),
                    const SizedBox(width: CConstants.GOLDEN_SIZE / 2),
                    Text(
                      "${CMiscClass.numberAbrev(((reactionsData['likes']?['count'] ?? 0) as int).toDouble())}"
                      "${(reactionsData['likes']?['user'] ?? false) ? " et vous" : ''}",
                      style: Theme.of(context).textTheme.labelSmall,
                    )
                  ]),
                  const SizedBox(width: CConstants.GOLDEN_SIZE * 2),
                  Row(children: [
                    const Icon(CupertinoIcons.eye, size: CConstants.GOLDEN_SIZE * 1.5),
                    const SizedBox(width: CConstants.GOLDEN_SIZE / 2),
                    Text(
                      CMiscClass.numberAbrev(((reactionsData['views']?['count'] ?? 0) as int).toDouble()),
                      style: Theme.of(context).textTheme.labelSmall,
                    )
                  ]),
                  const Spacer(),
                  Text(
                    "${CMiscClass.numberAbrev(((reactionsData['comments']?['count'] ?? 0) as int).toDouble())} Commentaires",
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ]),
                            ),*/

                  // --- KIKES BUTTONS -->
                  // const Divider(indent: CConstants.GOLDEN_SIZE, endIndent: CConstants.GOLDEN_SIZE),
                  const SizedBox(height: CConstants.GOLDEN_SIZE * 2),
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
                  /*Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                TextButton.icon(
                  onPressed: isInLoadingReactions ? null : likeThis,
                  icon: Icon(
                    reactionsData['likes']['user'] ? CupertinoIcons.hand_thumbsup_fill : CupertinoIcons.hand_thumbsup,
                    size: CConstants.GOLDEN_SIZE * 2,
                  ),
                  label: const Text("J'aime"),
                  style: const ButtonStyle(visualDensity: VisualDensity.compact),
                ),
                TextButton.icon(
                  onPressed: toggleFaveState,
                  icon: const Icon(CupertinoIcons.heart, size: CConstants.GOLDEN_SIZE * 2),
                  label: const Text("Favaris"),
                  style: const ButtonStyle(visualDensity: VisualDensity.compact),
                ),
                            ]),*/

                  // 0998 038 882

                  // --- COMMENTS :
                  const SizedBox(height: CConstants.GOLDEN_SIZE * 3),
                  Text("Commentaires", style: Theme.of(context).textTheme.titleMedium),
                  CCommentsViewHandlerComponent(section: CSectionsTypesEnum.echo, id: widget.echoId ?? '---'),

                  // --- Free space:
                  const SizedBox(height: CConstants.GOLDEN_SIZE * 3),
                ]).animate(effects: CTransitionsTheme.model_1),
              );
            })
          ]),
        ]),
      ),
    );
  }

  // METHODS -->--------------------------------------------------------------------------------------------------------------
  load() {
    setState(() => isInLoading = true);

    Map data = {'echoId': widget.echoId};

    CApi.request.get('/echo/quest/get.WM6cArGmD28c34T93173emBfxQl', data: data).then(
      (res) {
        setState(() => isInLoading = false);

        if (res.data is Map && res.data['success']) {
          setState(() {
            echoData = res.data['echo'];
            posterData = res.data['poster'];
            picturesList = res.data['pictures'];
            posterPool = _managePCN(posterData['pool']);
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

  String _managePCN(String? pool) {
    Map? data = PcnDataHandlerMv.getPool(pool ?? '---');

    // switch (visibility?['level']) {
    //   case 'pool':
    //     data = PcnDataHandlerMv.getPool(visibility?['level_id']);
    //     break;
    //   case 'com_loc':
    //     data = PcnDataHandlerMv.getCom(visibility?['level_id']);
    //     break;
    //   case 'noyau_af':
    //     data = PcnDataHandlerMv.getNa(visibility?['level_id']);
    //     break;
    // }

    if (data != null) return "Pool de ${data['nom']}";

    return "Pool inconu";
  }

  void _back() => context.pop();

  loadReactions() {
    setState(() => isInLoadingReactions = true);

    CApi.request.get('/echo/quest/reactions.2aMeWrZNsATywaFe9IfouKnH2Et', data: {'echoId': widget.echoId}).then(
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
    CApi.request.post('/echo/quest/add.view.rBXQcq9eeABp0GMqjC1LkS7BKsH', data: {'echoId': widget.echoId});
  }

  likeThis() {
    setState(() => isInLoadingReactions = true);

    CApi.request.post('/echo/quest/like.reaction.Tcn5FcFNnozQ0SX725E7HGpzmPo', data: {'echoId': widget.echoId}).then((res) {
      setState(() => isInLoadingReactions = false);

      if (res.data is Map && res.data['success']) loadReactions();
    }).catchError((err) {
      setState(() => isInLoadingReactions = false);
    });
  }

  loadFavState() {}

  toggleFaveState() {}

  openUserProfile(String userId) {}
}
