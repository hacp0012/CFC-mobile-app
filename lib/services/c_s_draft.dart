import 'dart:convert';

import 'package:cfc_christ/database/app_preferences.dart';

/// Store end manage draft data.
class CSDraft {
  CSDraft(this.id) {
    String? rawData = CAppPreferences().instance?.getString(_storkey);

    if (rawData == null) {
      rawData = '{}';
      CAppPreferences().instance?.setString(_storkey, rawData);
    }

    _draftBase = jsonDecode(rawData) as Map;

    // For OD :
    Map? idDraft = _draftBase[id];

    if (idDraft == null) {
      _draftBase[id] = {};

      idDraft = {};

      CAppPreferences().instance?.setString(_storkey, jsonEncode(_draftBase));
    }

    draft = idDraft;
  }

  // DATAS ------------------------------------------------------------------------------------------------------------------>
  final String id;

  final String _storkey = "9hKUVZM31pTP6HG1kbY3pe86guXQs0Zubyp5";

  Map _draftBase = {};

  Map draft = {};

  // METHODS ---------------------------------------------------------------------------------------------------------------->
  /// Get the drafted data.
  String? data(String key) => draft[key];

  /// Keen (conserve) data.
  void keep(String key, String text) {
    draft[key] = text;

    _draftBase[id] = draft;

    CAppPreferences().instance?.setString(_storkey, jsonEncode(_draftBase));
  }

  /// Free this instance.
  /// It will remove all stored data on this instance, referenced by it [id].
  void free() {
    _draftBase.remove(id);

    CAppPreferences().instance?.setString(_storkey, jsonEncode(_draftBase));
  }

  /// Clear all stored Drafts.
  static void cleanAll() => CAppPreferences().instance?.remove('9hKUVZM31pTP6HG1kbY3pe86guXQs0Zubyp5');
}