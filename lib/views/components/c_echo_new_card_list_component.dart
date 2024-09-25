import 'package:cached_network_image/cached_network_image.dart';
import 'package:cfc_christ/classes/c_image_handler_class.dart';
import 'package:cfc_christ/classes/c_misc_class.dart';
import 'package:cfc_christ/configs/c_api.dart';
import 'package:cfc_christ/configs/c_constants.dart';
import 'package:cfc_christ/configs/c_styled_text_tags.dart';
import 'package:cfc_christ/model_view/pcn_data_handler_mv.dart';
import 'package:cfc_christ/views/components/c_images_grid_group_view_component.dart';
import 'package:cfc_christ/views/screens/echo/read_echo_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:styled_text/widgets/styled_text.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

class CEchoNewCardListComponent extends StatefulWidget {
  const CEchoNewCardListComponent({super.key, required this.echoData});

  final Map echoData;

  @override
  State<CEchoNewCardListComponent> createState() => _CEchoNewCardListComponentState();
}

class _CEchoNewCardListComponentState extends State<CEchoNewCardListComponent> {
  // DATAS -------------------------------------------------------------------------------------------------------------------
  Map echo = {};
  Map poster = {};
  Map reactions = {};
  List pictures = [];

  bool isInPushing = false;

  // INITALIZERS -------------------------------------------------------------------------------------------------------------
  @override
  void initState() {
    echo = widget.echoData['echo'];
    poster = widget.echoData['poster'];
    pictures = widget.echoData['pictures'];
    reactions = widget.echoData['reactions'];

    super.initState();
  }

  // VIEW --------------------------------------------------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    // final TapGestureRecognizer openEcho = TapGestureRecognizer()
    //   ..onTap = () => GoRouter.of(context).pushNamed(ReadEchoScreen.routeName);

    return Card(
      elevation: .0,
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(CConstants.GOLDEN_SIZE),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- POSTER -->
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: const EdgeInsets.only(right: CConstants.GOLDEN_SIZE),
                child: CircleAvatar(
                  radius: CConstants.GOLDEN_SIZE * 2,
                  backgroundImage: CachedNetworkImageProvider(CImageHandlerClass.userById(poster['id'])),
                ),
              ),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(poster['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(
                  _managePCN(poster['pool']),
                  style: Theme.of(context).textTheme.labelSmall,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  CMiscClass.date(DateTime.parse(echo['created_at'])).ago(),
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ]),
            ]),

            // --- Title -->
            Row(children: [
              const Padding(
                padding: EdgeInsets.all(CConstants.GOLDEN_SIZE / 2),
                child: Icon(CupertinoIcons.radiowaves_right, size: CConstants.GOLDEN_SIZE * 1.5),
              ),
              Expanded(
                child: Text(
                  echo['title'],
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ]),

            // --- SMALL DESCRIPTIONS -->
            GestureAnimator(
              child: StyledText(
                text: "${echo['text']} <blue>Lire la suite</blue>",
                tags: CStyledTextTags().tags,
              ),
              onTap: () => context.pushNamed(ReadEchoScreen.routeName, extra: {'echo_id': echo['id']}),
            ),

            // --- PICTURES -->
            const SizedBox(height: CConstants.GOLDEN_SIZE),
            if (pictures.isNotEmpty) CImagesGridGroupViewComponent(pictures: pictures),

            // --- LIKES AND COMMENT TEXT -->
            Padding(
              padding: const EdgeInsets.all(CConstants.GOLDEN_SIZE),
              child: Row(children: [
                Row(children: [
                  const Icon(CupertinoIcons.hand_thumbsup_fill, size: CConstants.GOLDEN_SIZE * 1.5),
                  const SizedBox(width: CConstants.GOLDEN_SIZE / 2),
                  Text(
                    "${CMiscClass.numberAbrev((reactions['likes']['count'] as int).toDouble())} J'aime-s",
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ]),
                const Spacer(),
                Text(
                  "${CMiscClass.numberAbrev((reactions['comments']['count'] as int).toDouble())} Commentaires",
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ]),
            ),

            // --- KIKES BUTTONS -->
            const Divider(indent: CConstants.GOLDEN_SIZE, endIndent: CConstants.GOLDEN_SIZE),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              TextButton.icon(
                onPressed: isInPushing ? null : likeThis,
                icon:  Icon(reactions['likes']['user'] ? CupertinoIcons.hand_thumbsdown : CupertinoIcons.hand_thumbsup, size: CConstants.GOLDEN_SIZE * 2,),
                label: Text(reactions['likes']['user'] ? "Je n'aime pas" : "J'aime"),
                style: const ButtonStyle(visualDensity: VisualDensity.compact),
              ),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(CupertinoIcons.heart, size: CConstants.GOLDEN_SIZE * 2),
                label: const Text("Favaris"),
                style: const ButtonStyle(visualDensity: VisualDensity.compact),
              ),
              TextButton.icon(
                onPressed: () => context.pushNamed(ReadEchoScreen.routeName, extra: {'echo_id': echo['id']}),
                icon: const Icon(CupertinoIcons.news, size: CConstants.GOLDEN_SIZE * 2),
                label: const Text("Lire"),
                style: const ButtonStyle(visualDensity: VisualDensity.compact),
              ),
            ]),
          ],
        ),
      ),
    );
  }

  // METHODS -----------------------------------------------------------------------------------------------------------------
  String _managePCN(String? visibility) {
    Map? data = {};

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
    data = PcnDataHandlerMv.getPool(visibility ?? '---');

    if (data != null) return "Pool de ${data['nom']}";

    return "PCN inconu";
  }

  void likeThis() {
    setState(() => isInPushing = true);

    CApi.request.post('/echo/quest/like.reaction.Tcn5FcFNnozQ0SX725E7HGpzmPo', data: {'echoId': echo['id']}).then((res) {
      setState(() => isInPushing = false);

      if (res.data is Map && res.data['success']) {
        setState(() {
          if (reactions['likes']['user'] && reactions['likes']['count'] > 0) {
            reactions['likes']['count'] -= 1;
          } else {
            reactions['likes']['count'] += 1;
          }

          reactions['likes']['user'] = !reactions['likes']['user'];
        });
      }
    }).catchError((err) {
      setState(() => isInPushing = false);
    });
  }
}
