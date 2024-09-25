import 'package:cached_network_image/cached_network_image.dart';
import 'package:cfc_christ/classes/c_image_handler_class.dart';
import 'package:cfc_christ/classes/c_misc_class.dart';
import 'package:cfc_christ/model_view/pcn_data_handler_mv.dart';
import 'package:cfc_christ/views/screens/teaching/read_teaching_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cfc_christ/configs/c_constants.dart';
import 'package:go_router/go_router.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

class CEnseignementCardListComponent extends StatelessWidget {
  const CEnseignementCardListComponent({
    super.key,
    required this.teachData,
    this.showTypeLabel = false,
    this.isInFavorite = false,
  });
  // DATAS -------------------------------------------------------------------------------------------------------------------
  final bool isInFavorite;
  final bool showTypeLabel;
  final Map teachData;

  // COMPONENT ---------------------------------------------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    Map teach = teachData['teach'];
    Map reactions = teachData['reactions'];
    Map poster = teachData['poster'];

    return Card(
      // color: Colors.white,
      borderOnForeground: false,
      elevation: 0,
      margin: const EdgeInsets.all(CConstants.GOLDEN_SIZE),
      child: GestureAnimator(
        child: Padding(
          padding: const EdgeInsets.all(CConstants.GOLDEN_SIZE),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // --> User state :
            Row(children: [
              Badge(
                isLabelVisible: isInFavorite,
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                padding: const EdgeInsets.symmetric(horizontal: 1.0),
                label: const Icon(CupertinoIcons.heart, size: 12),
                offset: const Offset(3.0, 0.0),
                child: CircleAvatar(
                  radius: CConstants.GOLDEN_SIZE * 2,
                  backgroundImage: CachedNetworkImageProvider(CImageHandlerClass.userById(poster['id'])),
                ),
              ),
              const SizedBox(width: CConstants.GOLDEN_SIZE),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  if (showTypeLabel == false)
                    const Icon(CupertinoIcons.book, size: 18)
                  else
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: CConstants.GOLDEN_SIZE - 6,
                        horizontal: CConstants.GOLDEN_SIZE - 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade200,
                        borderRadius: BorderRadius.circular(CConstants.DEFAULT_RADIUS),
                      ),
                      child: Text(
                        'ENSEIGNEMENT',
                        style: TextStyle(
                          color: CMiscClass.whenBrightnessOf<Color>(context, dark: Colors.black),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          fontFamily: CConstants.FONT_FAMILY_PRIMARY,
                        ),
                      ),
                    ),
                  Text(
                    _managePCN(teach['visibility']),
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ]),
              ),
            ]),

            // --> Conconst const taints :
            const SizedBox(width: 9.0),
            Column(children: [
              // --- Texts :
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 9.0),
                child: Row(children: [
                  Expanded(
                    child: Text(
                      teach['title'],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 18),
                    ),
                  ),
                ]),
              ),

              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(CConstants.DEFAULT_RADIUS)),
                child: Image(
                  image: CachedNetworkImageProvider(
                    CImageHandlerClass.byPid(teach['picture'], defaultImage: 'images.image_1'),
                  ),
                  fit: BoxFit.cover,
                  height: CConstants.GOLDEN_SIZE * 17,
                  width: double.infinity,
                ),
              ),

              // Text :
              Row(children: [
                Expanded(
                  child: Text(CMiscClass.remeveMarkdownSymboles(teach['text']), maxLines: 5, overflow: TextOverflow.ellipsis),
                ),
              ]),

              // --- Reactions :
              Padding(
                padding: const EdgeInsets.only(top: 9.0),
                child: FittedBox(
                  child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                    Row(children: [
                      const Icon(CupertinoIcons.clock, size: 16),
                      const SizedBox(width: CConstants.GOLDEN_SIZE / 2),
                      Text(
                        CMiscClass.date(DateTime.parse(teach['created_at'])).ago(),
                        style: Theme.of(context).textTheme.labelSmall,
                      )
                    ]),

                    // --- VIEWS :
                    const SizedBox(width: CConstants.GOLDEN_SIZE),
                    Row(children: [
                      const Icon(CupertinoIcons.eye, size: 16),
                      const SizedBox(width: CConstants.GOLDEN_SIZE / 2),
                      Text(
                        "${CMiscClass.numberAbrev((reactions['views']['count'] as int).toDouble())} vues",
                        style: Theme.of(context).textTheme.labelSmall,
                      )
                    ]),

                    // --- LIKES :
                    const SizedBox(width: CConstants.GOLDEN_SIZE),
                    Row(children: [
                      const Icon(CupertinoIcons.hand_thumbsup, size: 16),
                      const SizedBox(width: CConstants.GOLDEN_SIZE / 2),
                      Text(
                        "${CMiscClass.numberAbrev((reactions['likes']['count'] as int).toDouble())} j'aims",
                        style: Theme.of(context).textTheme.labelSmall,
                      )
                    ]),

                    // --- COMMENTS :
                    const SizedBox(width: CConstants.GOLDEN_SIZE),
                    Row(children: [
                      const Icon(CupertinoIcons.chat_bubble_2, size: 16),
                      const SizedBox(width: CConstants.GOLDEN_SIZE / 2),
                      Text(
                        "${CMiscClass.numberAbrev((reactions['comments']['count'] as int).toDouble())} Commentaires",
                        style: Theme.of(context).textTheme.labelSmall,
                      )
                    ]),
                  ]),
                ),
              ),
            ]),
          ]),
        ),
        onTap: () => context.pushNamed(ReadTeachingScreen.routeName, extra: {'teach_id': teach['id']}),
      ),
    );
  }

  // METHODS -----------------------------------------------------------------------------------------------------------------
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
}
