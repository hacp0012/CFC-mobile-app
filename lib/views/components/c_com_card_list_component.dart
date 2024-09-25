import 'package:cached_network_image/cached_network_image.dart';
import 'package:cfc_christ/classes/c_image_handler_class.dart';
import 'package:cfc_christ/classes/c_misc_class.dart';
import 'package:cfc_christ/configs/c_constants.dart';
import 'package:cfc_christ/model_view/pcn_data_handler_mv.dart';
import 'package:cfc_christ/views/screens/comm/read_comm_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

class CComCardListComponent extends StatelessWidget {
  const CComCardListComponent({super.key, required this.comData, this.showTypeLabel = false, this.isInFavorite = false});

  final bool isInFavorite;
  final bool showTypeLabel;
  final Map comData;

  @override
  Widget build(BuildContext context) {
    // DATAS -----------------------------------------------------------------------------------------------------------------
    Map com = comData['com'];
    Map reactions = comData['reactions'];

    // COMPONENT -------------------------------------------------------------------------------------------------------------
    return GestureAnimator(
      child: Card(
        borderOnForeground: false,
        margin: const EdgeInsets.all(CConstants.GOLDEN_SIZE),
        child: Padding(
          padding: const EdgeInsets.all(CConstants.GOLDEN_SIZE),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Badge(
                isLabelVisible: isInFavorite,
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                padding: const EdgeInsets.symmetric(horizontal: 1.0),
                label: const Icon(CupertinoIcons.heart, size: 12),
                offset: const Offset(-3.0, 0.0),
                child: CircleAvatar(
                  radius: CConstants.GOLDEN_SIZE * 2,
                  backgroundImage: CachedNetworkImageProvider(CImageHandlerClass.userById(com['published_by'])),
                ),
              ),

              const SizedBox(width: 9.0),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                if (showTypeLabel == false)
                  Row(
                    children: [
                      const Icon(CupertinoIcons.news, size: 18),
                      const SizedBox(width: CConstants.GOLDEN_SIZE),
                      Text(
                        CMiscClass.date(DateTime.parse(com['created_at'])).ago(),
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ],
                  )
                else
                  Row(
                    children: [
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
                          'COMMUNIQUER',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: CMiscClass.whenBrightnessOf(context, dark: Colors.black),
                            // fontFamily: CConstants.FONT_FAMILY_PRIMARY,
                          ),
                        ),
                      ),

                      const SizedBox(width: CConstants.GOLDEN_SIZE / 2),
                    Text(
                      CMiscClass.date(DateTime.parse(com['created_at'])).ago(),
                      style: Theme.of(context).textTheme.labelSmall,
                    )
                    ]
                  ),

                // --- Secondary :
                // const SizedBox(width: CConstants.GOLDEN_SIZE),
                Text(_managePCN(com['visibility']), style: Theme.of(context).textTheme.labelSmall),
                // Text('Publié le 27 aout 2024', style: Theme.of(context).textTheme.labelSmall),

                // if (showTypeLabel)
                //   Row(children: [
                //     const Icon(CupertinoIcons.clock, size: 12),
                //     const SizedBox(width: CConstants.GOLDEN_SIZE / 2),
                //     Text(
                //       CMiscClass.date(DateTime.parse(com['created_at'])).ago(),
                //       style: Theme.of(context).textTheme.labelSmall,
                //     )
                //   ]),
              ]),

              // --- State badget :
              const Spacer(),
              if (com['status'] != 'NONE')
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: CConstants.GOLDEN_SIZE - 6,
                    horizontal: CConstants.GOLDEN_SIZE - 4,
                  ),
                  decoration: BoxDecoration(
                    // color: Colors.greenAccent.shade100, // Green.
                    // color: Colors.red.shade100, // Red.
                    color: Colors.black, // Black.
                    borderRadius: BorderRadius.circular(CConstants.DEFAULT_RADIUS),
                  ),
                  child: Text(
                    com['status'] == 'INWAIT' ? 'Prévu' : 'Réalisé',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.white),
                  ),
                ),
            ]),

            // --- Conconst const taints :
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // --- Texts :
              Row(children: [
                Expanded(
                  child: Text(
                    com['title'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
              ]),
              const SizedBox(height: CConstants.GOLDEN_SIZE),
              Text(CMiscClass.remeveMarkdownSymboles(com['text']), maxLines: 4, overflow: TextOverflow.ellipsis),

              // --- Reactions :
              Padding(
                padding: const EdgeInsets.only(top: 9.0),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                  // Row(children: [
                  //   const Icon(CupertinoIcons.clock, size: 16),
                  //   const SizedBox(width: CConstants.GOLDEN_SIZE / 2),
                  //   Text("il y a 15 mins", style: Theme.of(context).textTheme.labelSmall)
                  // ]),

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
                      "${CMiscClass.numberAbrev((reactions['comments']['count'] as int).toDouble())}  Commentaires",
                      style: Theme.of(context).textTheme.labelSmall,
                    )
                  ]),
                ]),
              ),
            ]),
          ]),
        ),
      ),
      onTap: () => context.pushNamed(ReadCommScreen.routeName, extra: {'com_id': com['id']}),
    );
  }

  // METHODS ---------------------------------------------------------------------------------------------------------------
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
