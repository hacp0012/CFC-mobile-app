import 'package:cfc_christ/classes/c_misc_class.dart';
import 'package:cfc_christ/configs/c_constants.dart';
import 'package:cfc_christ/services/c_s_boot.dart';
import 'package:cfc_christ/views/layouts/default_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const String routeName = 'splashscreen';

  @override
  createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool loadingError = false;

  bool showProgressIndicator = false;
  List<Widget> pages = [];

  @override
  void initState() {
    super.initState();

    // // Open permissions asker.
    // CSBoot.askingForPermissions();

    start();
  }

  @override
  void setState(VoidCallback fn) => super.setState(fn);

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: Scaffold(
        body: SafeArea(
          child: Container(
            // decoration: const BoxDecoration(color: CConstants.PRIMARY_COLOR),
            padding: const EdgeInsets.all(CConstants.GOLDEN_SIZE),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // --- Logo :
                  WidgetAnimator(
                    incomingEffect: WidgetTransitionEffects.incomingSlideInFromBottom(duration: const Duration(seconds: 1)),
                    atRestEffect: WidgetRestingEffects.bounce(),
                    child: CircleAvatar(
                      backgroundColor: CMiscClass.whenBrightnessOf<Color>(context, dark: CConstants.LIGHT_COLOR),
                      radius: CConstants.GOLDEN_SIZE * 10,
                      // backgroundColor: CConstants.LIGHT_COLOR,
                      child: Image.asset(
                        'lib/assets/icons/LOGO_CFC_512.png',
                        width: CConstants.GOLDEN_SIZE * 27,
                        height: CConstants.GOLDEN_SIZE * 27,
                      ),
                    ),
                  ),

                  // --- Logo Title :
                  WidgetAnimator(
                    incomingEffect: WidgetTransitionEffects.incomingSlideInFromBottom(
                      duration: const Duration(milliseconds: 1350),
                    ),
                    child: const Text(
                      "CFC",
                      style: TextStyle(
                        color: CConstants.PRIMARY_COLOR,
                        fontWeight: FontWeight.bold,
                        fontSize: CConstants.GOLDEN_SIZE * 5,
                        fontFamily: 'Poppins',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  // --- Message :
                  FittedBox(
                    child: WidgetAnimator(
                      incomingEffect: WidgetTransitionEffects.incomingSlideInFromBottom(
                        duration: const Duration(milliseconds: 1602),
                      ),
                      child: Text(
                        "Communauté Famille Chrétienne",
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),

                  // --- Loading text:
                  const SizedBox(height: CConstants.GOLDEN_SIZE * 2),
                  Visibility(
                    visible: showProgressIndicator,
                    child: SizedBox(
                      width: CConstants.GOLDEN_SIZE * 9,
                      child: LinearProgressIndicator(borderRadius: BorderRadius.circular(CConstants.GOLDEN_SIZE / 2)),
                    ).animate().fadeIn(duration: 810.ms),
                  ),
                  Visibility(
                    visible: loadingError,
                    child: Column(
                      children: [
                        Text(
                          "Erreur, veiller recharger et vérifier votre \nconnexion internet.",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        FilledButton.tonalIcon(
                          onPressed: start,
                          icon: const Icon(CupertinoIcons.arrow_counterclockwise, size: CConstants.GOLDEN_SIZE * 2),
                          label: const Text("Recommencer"),
                          style: const ButtonStyle(visualDensity: VisualDensity.compact),
                        ),
                      ],
                    ).animate().fadeIn(duration: 810.ms).slideY(begin: .5),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

// FUNCTIONS ----------------------- >
  void start() {
    loadingError = false;
    showProgressIndicator = true;

    CSBoot(
      onFinish: () {
        if (loadingError == false) {
          if (kDebugMode) {
            print("APP LOADING FINISH *********");
          }

          // Start first time launching process.
          CSBoot.isFirstTime(context);
        }
      },
      onFailed: () => setState(() {
        if (kDebugMode) {
          print("APP LOADING FAILED *********");
        }
        loadingError = true;
        showProgressIndicator = false;
      }),
    );
  }
}
