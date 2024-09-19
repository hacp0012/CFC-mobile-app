import 'dart:convert';

import 'package:cfc_christ/configs/c_api.dart';
import 'package:cfc_christ/database/app_preferences.dart';

class PcnDataHandlerMv {
  static const String storeKey = 'pcn_store_key';

  /// Download PCN resources.
  void download({Function(dynamic responseData)? onFinish, Function()? onError}) {
    // Launch in background if ressource exist.
    if (CAppPreferences().instance?.getString(storeKey) != null) {
      () async {
        _download(onError: onError, onFinish: (response) {});
      }();

      // Dpn wait.
      onFinish?.call(null);
    } else {
      // Wait until loading finish.
      _download(onFinish: onFinish, onError: onError);
    }
  }

  /// Download PCN resources.
  void _download({Function(dynamic responseData)? onFinish, Function()? onError}) {
    CApi.request.get('/misc/initial/pcn').then((response) {
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

  static List<Map> get pools {
    List<dynamic> data = jsonDecode(CAppPreferences().instance?.getString(storeKey) ?? '[]') as List<dynamic>;
    List<Map> list = [];

    for (Map data in data) {
      if (data['type'] == 'POOL') {
        list.add(data);
      }
    }

    return list;
  }

  static List<Map> fitchCom(String poolId) {
    List<dynamic> data = jsonDecode(CAppPreferences().instance?.getString(storeKey) ?? '[]') as List<dynamic>;
    List<Map> list = [];

    for (Map data in data) {
      if (data['type'] == 'COM' && data['parent'] == poolId) {
        list.add(data);
      }
    }

    return list;
  }

  static List<Map> fitchNa(String comId) {
    List<dynamic> data = jsonDecode(CAppPreferences().instance?.getString(storeKey) ?? '[]') as List<dynamic>;
    List<Map> list = [];

    for (Map data in data) {
      if (data['type'] == 'NA' && data['parent'] == comId) {
        list.add(data);
      }
    }

    return list;
  }

  /// Get pool by id.
  /// return {type, nom, label}
  static Map? getPool(String poolId) {
    for (Map pool in pools) {
      if (pool['id'] == poolId && pool['type'] == 'POOL') {
        return pool;
      }
    }

    return null;
  }

  // Get Com by id.
  /// return {nom, type, nom, label}
  static Map? getCom(String comId) {
    List<dynamic> data = jsonDecode(CAppPreferences().instance?.getString(storeKey) ?? '[]') as List<dynamic>;
    List<Map> list = [];

    for (Map data in data) {
      if (data['type'] == 'COM') {
        list.add(data);
      }
    }

    for (Map com in list) {
      if (com['id'] == comId && com['type'] == 'COM') {
        return com;
      }
    }

    return null;
  }

  // Get NA by id.
  /// return {nom, type, nom, label}
  static Map? getNa(String naId) {
    List<dynamic> data = jsonDecode(CAppPreferences().instance?.getString(storeKey) ?? '[]') as List<dynamic>;
    List<Map> list = [];

    for (Map data in data) {
      if (data['type'] == 'NA') {
        list.add(data);
      }
    }

    for (Map na in list) {
      if (na['id'] == naId && na['type'] == 'NA') {
        return na;
      }
    }

    return null;
  }
}
