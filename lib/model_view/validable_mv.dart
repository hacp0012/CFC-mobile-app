// ignore_for_file: constant_identifier_names

import 'package:cfc_christ/configs/c_api.dart';
import 'package:flutter/foundation.dart';

class ValidableMv {
  static const String TYPE_COUPLE_BIND = 'JOIN_COUPLE_INVITATION';
  static const String TYPE_CHILD_BIND = 'CHILD_JOIN_INVITATION';
  static const String TYPE_CHILD_CAN_MARIED = 'CHILD_CAN_BE_MARIED';

  Map validable;

  ValidableMv(this.validable);

  // METHODES ---------------------------------------------------------------------------------------------------------------:

  static Future<int> chechIfHasNew() async {
    try {
      var responseData = await CApi.request.get('/feature/validable/has_validable');
      return responseData.data['count'];
    } catch (e) {
      debugPrint("Chicking validabe failed.");
    }

    return 0;
  }

  static Future<Map> download() async {
    try {
      var responseData = await CApi.requestWithCache.get('/feature/validable/list');
      // print(responseData.data);

      return responseData.data;
    } catch (e) {
      debugPrint('Donwload Validable failed.');
    }

    return {};
  }

  void validate({Function()? onFinish, Function()? onFailed}) async {
    Map data = {'validable_id': validable['id']};

    CApi.request.post('/feature/validable/validate', data: data).then((res) {
      if (res.data['state'] == 'VALIDATED') {
        onFinish?.call();
      } else {
        onFailed?.call();
      }
    }).catchError((e) {
      onFinish?.call();
    });
  }

  void reject({Function()? onFinish, Function()? onFailed}) {
    Map data = {'validable_id': validable['id']};

    CApi.request.post('/feature/validable/reject', data: data).then((res) {
      if (res.data['state'] == 'VALIDATED') {
        onFinish?.call();
      } else {
        onFailed?.call();
      }
    }).catchError((e) {
      onFinish?.call();
    });
  }

  void viewContoller(String badget) {}
}
