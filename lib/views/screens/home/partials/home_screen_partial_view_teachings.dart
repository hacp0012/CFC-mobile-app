import 'package:cfc_christ/views/components/c_enseignement_card_list_component.dart';
import 'package:flutter/cupertino.dart';
import 'package:cfc_christ/configs/c_constants.dart';
import 'package:flutter/material.dart';

class HomeScreenPartialViewTeachings extends StatefulWidget {
  const HomeScreenPartialViewTeachings({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenPartialViewTeachingsState();
}

class _HomeScreenPartialViewTeachingsState extends State<HomeScreenPartialViewTeachings> {
  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      // --- PCN Set :
      InkWell(
        child: Row(children: [
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Pool de Bukavu, CL Notre-Dame, NA Notre-Dame",
              style: Theme.of(context).textTheme.labelSmall?.copyWith(color: CConstants.PRIMARY_COLOR),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(right: CConstants.GOLDEN_SIZE),
            child: Icon(CupertinoIcons.map_pin_ellipse, size: CConstants.GOLDEN_SIZE * 2),
          ),
        ]),
        onTap: () {},
      ),

      // --- LIST Body :
      ...List<Widget>.generate(9, (int index) {
        return const CEnseignementCardListComponent();
      }),

      // --- Bottom Empty space :
      const SizedBox(height: CConstants.GOLDEN_SIZE * 9),
    ]);
  }
}