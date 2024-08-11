import 'dart:convert';
import 'dart:math';

import 'package:cfc_christ/configs/c_api.dart';
import 'package:cfc_christ/database/app_preferences.dart';
import 'package:cfc_christ/database/models/user_model.dart';
import 'package:cfc_christ/env.dart';
import 'package:flutter/foundation.dart';

class LoginMv {
  String get deviceId {
    // TODO: Get device name id.
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
        print("USER DATA DOWNLOAD ERROR ---------------------------------------------");
        print(error);
      }
      onFailed?.call();
    });
  }

  void storeTokenKey(String key) => CAppPreferences().updateLoginToken(key);

  void logout({Function()? onSuccess, Function()? onFailed}) async {
    CAppPreferences().instance?.remove(Env.API_SESSION_TOKEN_NAME);
    CAppPreferences().instance?.remove(UserModel.tableName);
    CAppPreferences().updateLoginToken();
    CApi.request.delete('/auth/login/logout').then((response) {
      // CAppPreferences().instance?.remove(Env.API_SESSION_TOKEN_NAME);
      // CAppPreferences().instance?.remove(UserModel.tableName);
      // CAppPreferences().updateLoginToken();
      // Finish.

      onSuccess?.call();
    }, onError: (error) {
      onFailed?.call();
    });
  }
}
