import 'package:cfc_christ/configs/c_api.dart';

class COtpHandlerClass {
  static Future<String> get readFromSms async {
    // Future.error("");
    return Future.value("CODE : 0000");
  }

  static void validate(String otp, {Function(Map data)? onSuccess, Function()? onFailed}) {
    CApi.request.post("/feature/otp/validate/$otp").then(
      (response) {
        if (response.data['state'] == 'VALIDE') {
          onSuccess?.call(response.data);
        } else {
          onFailed?.call();
        }
      },
      onError: (error) => onFailed?.call(),
    );
  }

  static void request(String phoneCode, String phoneNumber, {Function(String, int)? onSuccess, Function()? onFailed}) async {
    CApi.request.post("/feature/otp/send", data: {'phone_code': phoneCode, 'phone_number': phoneNumber}).then((response) {
      if (response.data['state'] == 'SENT') {
        onSuccess?.call(response.data['otp'], response.data['expire_at']);
      } else {
        onFailed?.call();
      }
    }, onError: (error) => onFailed?.call());
  }
}
