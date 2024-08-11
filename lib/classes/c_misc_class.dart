import 'package:flutter/material.dart';

class CMiscClass {
  /// Return [T] when brightness of [context] is [light] or when is [dark]
  /// otherwise return [null].
  static T? whenBrightnessOf<T>(BuildContext context, {T? light, T? dark}) {
    return Theme.of(context).brightness == Brightness.light ? light : dark;
  }
}