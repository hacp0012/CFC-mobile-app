import 'package:cfc_christ/env.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// A Singleton class, store preferences datas.
class CAppPreferences {
  CAppPreferences._();

  static final CAppPreferences _instance = CAppPreferences._();

  // ----------------------------------------------------------------

  /// Public shared preferences instance.
  SharedPreferences? instance;

  /// Public secure shared preferencee instance.
  /// _all methods of this instance return Future_.
  FlutterSecureStorage? secureInstance;

  /// User session token.
  String? loginToken;

  /// Preference Initilizer.
  /// Called in the main function.
  /// Or when want to updated preference.
  void initialize() async {
    secureInstance = const FlutterSecureStorage(aOptions: AndroidOptions(encryptedSharedPreferences: true));
    instance = await SharedPreferences.getInstance();

    loginToken = instance?.getString(Env.API_SESSION_TOKEN_NAME);
    debugPrint(loginToken);
  }

  /// Update session login token.
  void updateLoginToken([String? token]) {
    loginToken = token;
    if (token != null) {
      instance?.setString(Env.API_SESSION_TOKEN_NAME, token);
    }
  }

  // ----------------------------------------------------------------

  factory CAppPreferences() => _instance;
}
