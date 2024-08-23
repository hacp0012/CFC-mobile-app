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
    Map data = jsonDecode(CAppPreferences().instance?.getString(storeKey) ?? '{}');
    return data['phone_codes'] ?? [];
  }

  /// Get countries code.
  /// {state: ACTIVE|INWAIT, name, level, role: STANDARD_USER|COMMUNICATION_MANAGER|EVANGELISM_MANAGER, can: []}.
  static List<dynamic> get roles {
    Map data = jsonDecode(CAppPreferences().instance?.getString(storeKey) ?? '{}');
    return data['roles'] ?? [];
  }

  static Map getRole(String? role) {
    Map element = {};

    for (Map roler in roles) {
      if (roler['role'] == role) {
        return roler;
      } else if (roler['role'] == 'STANDARD_USER') {
        element = roler;
      }
    }

    return element;
  }
}
