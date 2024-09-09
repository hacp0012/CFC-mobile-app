import 'dart:convert';
import 'dart:math';

import 'package:cfc_christ/configs/c_api.dart';
import 'package:cfc_christ/database/app_preferences.dart';
import 'package:cfc_christ/database/models/user_model.dart';
import 'package:cfc_christ/env.dart';
import 'package:cfc_christ/model_view/favorites_mv.dart';
import 'package:cfc_christ/model_view/notification_mv.dart';
import 'package:cfc_christ/services/bg/c_s_background.dart';
import 'package:cfc_christ/services/c_s_draft.dart';
import 'package:cfc_christ/services/c_s_tts.dart';
import 'package:cfc_christ/views/screens/user/user_uncomfirmed_home_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_cache_manager_dio/flutter_cache_manager_dio.dart';

class LoginMv {
  String get deviceId {
    // ! Get device name id !
    return "device-${Random.secure().nextInt(9999999)}";
  }

  Future<Map> verifyIfRegistred({
    required String phoneCode,
    required String phoneNumber,
    void Function()? onAvalable,
    void Function()? onInvalide,
    void Function()? onUnregistred,
  }) async {
    var response = await CApi.request.post(
      "/auth/login/checkstate",
      data: {'phone_code': phoneCode, 'phone_number': phoneNumber},
    );

    // Print data.
    // print(response.data);
    if (response.data['state'] == "UNREGISTERED") {
      onUnregistred?.call();
      // onInvalide?.call();
    } else if (response.data['state'] == 'VALIDATED') {
      onAvalable?.call();
    } else if (response.data['state'] == 'INVALIDE') {
      onInvalide?.call();
    }

    return response.data as Map;
  }

  void login(String phoneCode, String phoneNumber, {Function()? onFinish, Function()? onFailed}) async {
    Map data = {'phone_code': phoneCode, 'phone_number': phoneNumber, 'infos': "$deviceId-$phoneNumber"};

    var response = await CApi.request.post("/auth/login", data: data);

    // Processing data:
    // store token.
    if (response.data['state'] == 'LOGED') {
      storeTokenKey(response.data['token']);

      FlutterBackgroundService().startService();
      // FlutterBackgroundService().invoke('UPDATE_PREFERENCE_STORAGE');
      onFinish?.call();
    } else {
      onFailed?.call();
    }
  }

  void downloadAndInstallUserDatas({Function()? onFinish, Function()? onFailed}) {
    CApi.requestWithCache.post("/auth/login/userdata").then((response) {
      CAppPreferences().instance?.setString(UserModel.tableName, jsonEncode(response.data));

      onFinish?.call();
    }, onError: (error) {
      if (kDebugMode) {
        print("USER DATA DOWNLOAD ERROR -->-----------------------------------");
        print(error);
      }
      onFailed?.call();
    });
  }

  void storeTokenKey(String key) => CAppPreferences().updateLoginToken(key);

  void logout({Function()? onSuccess, Function()? onFailed}) async {
    // CAppPreferences().instance?.clear();
    DioCacheManager.instance.emptyCache();
    CApi.request.delete('/auth/login/logout').then((response) {
      // CAppPreferences().instance?.remove(Env.API_SESSION_TOKEN_NAME);
      // CAppPreferences().instance?.remove(UserModel.tableName);
      // CAppPreferences().updateLoginToken();
      // DioCacheManager.instance.emptyCache();
      // Finish.

      if (response.data['state'] == 'LOGED_OUT') {
        onSuccess?.call();
      } else {
        onFailed?.call();
      }
    }, onError: (error) {
      onFailed?.call();
    });

    CAppPreferences().instance?.remove(Env.API_SESSION_TOKEN_NAME);
    CAppPreferences().instance?.remove(UserModel.tableName);
    CAppPreferences().instance?.remove(UserUncomfirmedHomeScreen.parentStoreKey);
    CAppPreferences().updateLoginToken();
    CAppPreferences().instance?.remove(CSTts.configsStoreKey);
    FavoritesMv().cleanCache();
    NotificationMv.clear();
    CSDraft.cleanAll();
    CSBackground.killService();
  }
}
