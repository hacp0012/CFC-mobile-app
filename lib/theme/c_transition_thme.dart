import 'package:flutter/animation.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CTransitionsTheme {
  static List<Effect> model_1 = <Effect>[
    FadeEffect(duration: 630.ms, curve: Curves.ease),
    const SlideEffect(begin: Offset(0, .1)),
  ];
}
