import 'package:cfc_christ/views/layouts/empty_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cfc_christ/configs/c_constants.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

class ErrorScreen extends StatefulWidget {
  const ErrorScreen({super.key, required this.routeState});

  final GoRouterState routeState;

  static const String routeName = 'error';

  @override
  createState() => _ErrorScreenState();
}

class _ErrorScreenState extends State<ErrorScreen> {
  @override
  Widget build(BuildContext context) {
    return EmptyLayout(
      child: Scaffold(
        appBar: AppBar(centerTitle: true, title: const Text("Erreur survenue")),
        body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            WidgetAnimator(
              atRestEffect: WidgetRestingEffects.wave(),
              child: Icon(
                CupertinoIcons.xmark_octagon,
                size: CConstants.GOLDEN_SIZE * 18,
                color: Theme.of(context).colorScheme.error,
              ),
            ),

            // Text.
            const SizedBox(height: CConstants.GOLDEN_SIZE),
            Text(
              "ERREUR",
              style: TextStyle(fontSize: CConstants.GOLDEN_SIZE * 5, color: Theme.of(context).colorScheme.error),
            ),
            const Padding(
              padding: EdgeInsets.all(CConstants.GOLDEN_SIZE * 3),
              child: TextAnimator(
                "vocibus adhuc adversarium accumsan pretium vituperatoribus odio assueverit voluptatum",
                textAlign: TextAlign.center,
              ),
            ),

            // Button.
            WidgetAnimator(
              atRestEffect: WidgetRestingEffects.wave(),
              child: ElevatedButton(onPressed: () {}, child: const Text("Retourner")),
            ),
          ]),
        ),
      ),
    );
  }
}
