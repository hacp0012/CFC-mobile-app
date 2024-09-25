import 'dart:ui';

import 'package:cfc_christ/configs/c_constants.dart';
import 'package:cfc_christ/services/c_s_boot.dart';
import 'package:cfc_christ/views/layouts/default_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:introduction_screen/introduction_screen.dart';

class PresentationScreen extends StatefulWidget {
  const PresentationScreen({super.key});

  static const String routeName = 'presentation';

  @override
  createState() => _PresentationScreenState();
}

class _PresentationScreenState extends State<PresentationScreen> {
  List<Widget> pages = [];
  int currentPage = 0;
  PageController pageController = PageController();

  @override
  void setState(VoidCallback fn) => super.setState(fn);

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      transparentStatusBar: true,
      child: Scaffold(
        /*body: Column(
          children: [
            Expanded(
              child: PageView(controller: pageController, onPageChanged: onPageChange, children: buildSplashesViews()),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: CConstants.GOLDEN_SIZE),
              child: Row(children: [
                Visibility(
                  visible: currentPage > 0,
                  child: TextButton(onPressed: backToPrevPage, child: const Text('Retour')).animate().fade(),
                ),
                const Spacer(),
                if (currentPage < 2)
                  FilledButton.tonal(onPressed: goToNextPage, child: const Text('Suivant'))
                else
                  FilledButton.icon(
                    onPressed: finishTransition,
                    icon: const Icon(CupertinoIcons.check_mark, size: CConstants.GOLDEN_SIZE * 2),
                    label: const Text("Terminer"),
                  ).animate().fadeIn(),
              ]),
            ),
          ],
        ),*/

        body: IntroductionScreen(
          pages: [
            PageViewModel(
              decoration: const PageDecoration(
                bodyAlignment: Alignment.center,
                imageAlignment: Alignment.bottomCenter,
              ),
              // title: "L'amour du Christ",
              titleWidget: Text(
                "L'amour du Christ",
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              image: SizedBox(
                height: 270,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(CConstants.DEFAULT_RADIUS),
                  child: Image.asset('lib/assets/pictures/final/picture_1.png'),
                ),
              ),
              bodyWidget: const Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                SizedBox(height: CConstants.GOLDEN_SIZE),
                Padding(
                  padding: EdgeInsets.all(CConstants.GOLDEN_SIZE),
                  child: Text(
                    "Je vous donne un commandement nouveau: Aimez-vous les uns les autres; comme "
                    "je vous ai aimés, vous aussi, aimez-vous les uns les autres.",
                    textAlign: TextAlign.center,
                  ),
                ),
                Text("Jean 13:34", style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.w200)),
              ]),
            ),
            PageViewModel(
              decoration: const PageDecoration(
                bodyAlignment: Alignment.center,
                imageAlignment: Alignment.bottomCenter,
              ),
              titleWidget: Text(
                "La joie du Christ",
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              image: SizedBox(
                height: 270,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(CConstants.DEFAULT_RADIUS),
                  child: Image.asset('lib/assets/pictures/final/picture_3.png'),
                ),
              ),
              bodyWidget: const Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                SizedBox(height: CConstants.GOLDEN_SIZE),
                Padding(
                  padding: EdgeInsets.all(CConstants.GOLDEN_SIZE),
                  child: Text(
                    "Mais le fruit de l’Esprit, c’est l’amour, la joie, la paix, la patience, "
                    "la bonté, la bénignité, la fidélité, la douceur, la tempérance",
                    textAlign: TextAlign.center,
                  ),
                ),
                Text("Galates 5:22", style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.w200)),
              ]),
            ),
            PageViewModel(
              decoration: const PageDecoration(
                bodyAlignment: Alignment.center,
                imageAlignment: Alignment.bottomCenter,
              ),
              titleWidget: Text(
                "La paix du Christ",
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              image: SizedBox(
                height: 270,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(CConstants.DEFAULT_RADIUS),
                  child: Image.asset('lib/assets/pictures/final/picture_2.png'),
                ),
              ),
              bodyWidget: const Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                SizedBox(height: CConstants.GOLDEN_SIZE),
                Padding(
                  padding: EdgeInsets.all(CConstants.GOLDEN_SIZE),
                  child: Text(
                    "Et que la paix de Christ, à laquelle vous avez été appelés pour former un "
                    "seul corps, règne dans vos cœurs. Et soyez reconnaissants.",
                    textAlign: TextAlign.center,
                  ),
                ),
                Text("Colossiens 3:15", style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.w200)),
              ]),
            ),
          ],
          showSkipButton: true,
          showNextButton: false,
          skip: const Text("Ignorer"),
          done: const Text("Terminer"),
          dotsDecorator: DotsDecorator(
            size: const Size.square(10.0),
            activeSize: const Size(20.0, 10.0),
            activeColor: Theme.of(context).colorScheme.secondary,
            // color: Colors.black26,
            spacing: const EdgeInsets.symmetric(horizontal: 3.0),
            activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
          ),
          onSkip: finishTransition,
          onDone: finishTransition,
        ),
      ),
    );
  }

  // ACTIONS --------- >
  void finishTransition() => CSBoot.firstTimeCompleted(context);

  void goToNextPage() => setState(() {
        pageController.animateToPage(++currentPage, duration: 500.ms, curve: Curves.easeIn);
      });

  void backToPrevPage() => setState(() {
        if (currentPage > 0) {
          // currentPage -= 1;
          pageController.animateToPage(--currentPage, duration: 500.ms, curve: Curves.easeIn);
        }
      });

  void onPageChange(int index) => setState(() => currentPage = index);

  // PAGES ----------- >
  List<Widget> buildSplashesViews() {
    var q = MediaQuery.sizeOf(context);
    return <Widget>[
      Stack(fit: StackFit.expand, children: [
        Positioned(width: q.width, child: Image.asset('lib/assets/pictures/final/picture_1.png', fit: BoxFit.cover)),
        Positioned(
          height: q.height,
          width: q.width,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(color: Colors.black.withOpacity(0)),
          ),
        ),
        Positioned(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            SizedBox(
              height: 207,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(CConstants.DEFAULT_RADIUS),
                child: Image.asset('lib/assets/pictures/final/picture_1.png'),
              ),
            ),
            Text(
              "L'amour du Christ",
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: CConstants.GOLDEN_SIZE),
            const Padding(
              padding: EdgeInsets.all(CConstants.GOLDEN_SIZE),
              child: Text(
                "Je vous donne un commandement nouveau: Aimez-vous les uns les autres; comme "
                "je vous ai aimés, vous aussi, aimez-vous les uns les autres.",
                textAlign: TextAlign.center,
              ),
            ),
            const Text("Jean 13:34", style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.w200)),
          ]),
        ),
      ]),
      Stack(fit: StackFit.expand, children: [
        Positioned(width: q.width, child: Image.asset('lib/assets/pictures/final/picture_3.png', fit: BoxFit.cover)),
        Positioned(
          height: q.height,
          width: q.width,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(color: Colors.black.withOpacity(0)),
          ),
        ),
        Positioned(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            SizedBox(
              height: 207,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(CConstants.DEFAULT_RADIUS),
                child: Image.asset('lib/assets/pictures/final/picture_3.png'),
              ),
            ),
            Text(
              "La joie du Christ",
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: CConstants.GOLDEN_SIZE),
            const Padding(
              padding: EdgeInsets.all(CConstants.GOLDEN_SIZE),
              child: Text(
                "Mais le fruit de l’Esprit, c’est l’amour, la joie, la paix, la patience, "
                "la bonté, la bénignité, la fidélité, la douceur, la tempérance",
                textAlign: TextAlign.center,
              ),
            ),
            const Text("Galates 5:22", style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.w200)),
          ]),
        ),
      ]),
      Stack(fit: StackFit.expand, children: [
        Positioned(width: q.width, child: Image.asset('lib/assets/pictures/final/picture_2.png', fit: BoxFit.cover)),
        Positioned(
          height: q.height,
          width: q.width,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(color: Colors.black.withOpacity(0)),
          ),
        ),
        Positioned(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            SizedBox(
              height: 207,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(CConstants.DEFAULT_RADIUS),
                child: Image.asset('lib/assets/pictures/final/picture_2.png'),
              ),
            ),
            Text(
              "La paix du Christ",
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: CConstants.GOLDEN_SIZE),
            const Padding(
              padding: EdgeInsets.all(CConstants.GOLDEN_SIZE),
              child: Text(
                "Et que la paix de Christ, à laquelle vous avez été appelés pour former un "
                "seul corps, règne dans vos cœurs. Et soyez reconnaissants.",
                textAlign: TextAlign.center,
              ),
            ),
            const Text("Colossiens 3:15", style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.w200)),
          ]),
        ),
      ]),
    ];
  }
}
