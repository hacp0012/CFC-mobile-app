import 'dart:convert';

import 'package:cfc_christ/database/app_preferences.dart';
import 'package:cfc_christ/database/models/user_model.dart';

class UserMv {
  /// Get user data. if user is Authenticated.
  static Map<String, dynamic>? get data {
    String? data = CAppPreferences().instance?.getString(UserModel.tableName);

    if (data != null) {
      return jsonDecode(data) as Map<String, dynamic>;
    }

    return null;
  }
}
