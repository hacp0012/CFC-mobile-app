import 'dart:convert';

import 'package:cfc_christ/configs/c_api.dart';
import 'package:cfc_christ/database/app_preferences.dart';

class MiscDataHandlerMv {
  static const String storeKey = 'misc_data_store_key';

  /// Download PCN resources.
  void download({Function(dynamic responseData)? onFinish, Function()? onError}) {
    // Launch in background if ressource exist.
    if (CAppPreferences().instance?.get(storeKey) != null) {
      () {
        _download(onError: onError, onFinish: onFinish);
      }();
    } else {
      // Wait until loading finish.
      _download(onFinish: onFinish, onError: onError);
    }
  }

  /// Download PCN resources.
  void _download({Function(dynamic responseData)? onFinish, Function()? onError}) {
    CApi.request.get('/misc/initial/misc').then((response) {
      // Store data.
      CAppPreferences().instance?.setString(storeKey, jsonEncode(response.data));
      onFinish?.call(response.data);
    }).catchError((error) {
      String? data = CAppPreferences().instance?.getString(storeKey);
      // Raise error if empty.
      if (data == null) {
        onError?.call();
      } else {
        onFinish?.call(data);
      }
    });
  }

  /// Get countries code.
  static List<dynamic> get countriesCodes {
    List<dynamic> data = jsonDecode(CAppPreferences().instance?.getString(storeKey) ?? '[]') as List<dynamic>;
    return data;
  }
}
