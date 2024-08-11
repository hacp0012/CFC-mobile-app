import 'package:cfc_christ/configs/c_constants.dart';
import 'package:cfc_christ/views/components/c_echo_new_card_list_component.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreenPartialViewEchos extends StatefulWidget {
  const HomeScreenPartialViewEchos({super.key});

  @override
  State<StatefulWidget>  createState() => _HomeScreenPartialViewEchosState();
}

class _HomeScreenPartialViewEchosState extends State<HomeScreenPartialViewEchos> {
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
        return const CEchoNewCardListComponent();
      }),

      // --- Bottom Empty space :
      const SizedBox(height: CConstants.GOLDEN_SIZE * 9),
    ]);
  }
}