import 'package:cfc_christ/configs/c_api.dart';
import 'package:cfc_christ/database/app_preferences.dart';
import 'package:cfc_christ/database/models/user_model.dart';
import 'package:cfc_christ/env.dart';

class RegisterMv {
  void verifyIfRegistred(
    String phoneCode,
    String phoneNumber, {
    Function()? onRegistered,
    Function()? onUnregistered,
    Function()? onFailed,
  }) async {
    CApi.request.post(
      "/auth/register/checkstate",
      data: {'phone_code': phoneCode, 'phone_number': phoneNumber},
    ).then((response) {
      if (response.data['state'] == 'REGISTERED') {
        onRegistered?.call();
      } else if (response.data['state'] == 'UNREGISTERED') {
        onUnregistered?.call();
      }
    }, onError: (e) {
      onFailed?.call();
    });
  }

  void register({
    required String name,
    required String fullname,
    required String civility,
    required String dBrith,
    required String phoneCode,
    required String phoneNumber,
    bool isParent = true,
    String? familyName,
    String? familyId,
    bool alreadyMember = false,
    String? pool,
    String? cl,
    String? na,

    // Callbacks :
    Function(Map data)? onSuccess,
    Function()? onFailed,
  }) {
    Map data = {
      'name': name,
      'fullname': fullname,
      'civility': civility,
      'd_brith': dBrith,
      'phone_code': phoneCode,
      'phone_number': phoneNumber,
      'is_parent': isParent,
      'family_name': familyName,
      'family_id': familyId,
      'already_member': alreadyMember,
      'pool': pool,
      'cl': cl,
      'na': na,
    };

    // Request :
    CApi.request.post("/auth/register", data: data).then(
          // Call success callback :
          (response) => onSuccess?.call(response.data),
          // Call failed callback :
          onError: (error) => onFailed?.call(),
        );
  }

  void validateAccount(String phoneCode, String phoneNumber, {Function()? onSuccess, Function()? onFailed}) {
    CApi.request.post('/auth/register/validate', data: {'phone_code': phoneCode, 'phone_number': phoneNumber}).then(
      (response) {
        if (response.data['state'] == 'VALIDATED') {
          onSuccess?.call();
        } else {
          onFailed?.call();
        }
      },
      onError: (error) => onFailed?.call(),
    );
  }

  void unregister({Function()? onSuccess, Function()? onFailed}) {
    CApi.request.delete('/auth/register/unregister').then(
      (response) {
        CAppPreferences().instance?.remove(Env.API_SESSION_TOKEN_NAME);
        CAppPreferences().instance?.remove(UserModel.tableName);
        CAppPreferences().updateLoginToken();

        onSuccess?.call();
      },
      onError: (error) {
        onFailed?.call();
      },
    );
  }
}
