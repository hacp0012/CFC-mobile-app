import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

class RoutesTransitions {
  static CustomTransitionPage fadeIn(BuildContext context, state, Widget child) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 1000),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Change the opacity of the screen using a Curve based on the the animation's
        // value
        return FadeTransition(
          opacity: CurveTween(curve: Curves.ease).animate(animation),
          child: child,
        );
      },
    );
  }

  static CustomTransitionPage slide(BuildContext context, state, Widget child) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 270),
      reverseTransitionDuration: const Duration(milliseconds: 270),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Change the opacity of the screen using a Curve based on the the animation's
        // value
        return SlideTransition(
          position: Tween<Offset>(begin: const Offset(1.0, 0.0), end: Offset.zero).animate(animation),
          child: child,
        );
      },
    );
  }
}
