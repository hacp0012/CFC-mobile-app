import 'package:cfc_christ/configs/c_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

class FindCfcAroundScreen extends StatefulWidget {
  static const String routeName = 'cfc.find.around';
  static const String routePath = 'cfc_around';

  const FindCfcAroundScreen({super.key});

  @override
  State<FindCfcAroundScreen> createState() => _FindCfcAroundScreenState();
}

class _FindCfcAroundScreenState extends State<FindCfcAroundScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CFC à proximité')),

      // --- body :
      body: ListView(children: [
        const SizedBox(height: CConstants.GOLDEN_SIZE * 2),
        Column(
          children: [
            WidgetAnimator(
              atRestEffect: WidgetRestingEffects.dangle(),
              child: const Icon(CupertinoIcons.map_pin_ellipse, size: CConstants.GOLDEN_SIZE * 5),
            ),
            Text("Cherche d'une communauté local à proximité.", style: Theme.of(context).textTheme.labelSmall),
          ],
        ),
      ]),
    );
  }
}
